import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/add_transaction_sheet.dart';
import 'package:wargaqu/pages/citizen/notifications/notifications_screen.dart';
import 'package:wargaqu/theme/app_colors.dart';

class ReusableMainScreen extends ConsumerStatefulWidget {
  const ReusableMainScreen(
      {super.key,
      required this.bottomNavigationBarItems,
      required this.widgetOptions,
      this.appBarTitleBuilder,
      this.toolbarHeightBuilder,
      this.specialAppBarColorTriggerIndex,
      this.specialAppBarColor,
      this.defaultAppBarColor,
      this.specialTitleTriggerIndex,
      this.fabTriggerIndex});

  final List<BottomNavigationBarItem> bottomNavigationBarItems;
  final List<Widget> widgetOptions;
  final String? Function(int selectedIndex, BuildContext context)?
      appBarTitleBuilder;
  final double Function(int selectedIndex)? toolbarHeightBuilder;
  final int? specialAppBarColorTriggerIndex;
  final int? specialTitleTriggerIndex;
  final int? fabTriggerIndex;
  final Color? specialAppBarColor;
  final Color? defaultAppBarColor;

  @override
  ConsumerState<ReusableMainScreen> createState() => _ReusableMainScreenState();
}

class NoFabAnimation extends FloatingActionButtonAnimator {
  @override
  Offset getOffset(
          {required Offset begin,
          required Offset end,
          required double progress}) =>
      end;

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) =>
      AlwaysStoppedAnimation<double>(1.0);

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) =>
      AlwaysStoppedAnimation<double>(1.0);
}

class _ReusableMainScreenState extends ConsumerState<ReusableMainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color appBarBackgroundColor;
    Color appBarTitleColor;

    if (widget.specialAppBarColorTriggerIndex != null &&
        _selectedIndex == widget.specialAppBarColorTriggerIndex) {
      appBarBackgroundColor = widget.specialAppBarColor ?? AppColors.primary400;
      appBarTitleColor = Colors.white;
    } else {
      appBarBackgroundColor = widget.defaultAppBarColor ??
          Theme.of(context).appBarTheme.backgroundColor ??
          Colors.deepPurple;
      appBarTitleColor = Theme.of(context).colorScheme.onSurface;
    }

    final double currentToolbarHeight =
        widget.toolbarHeightBuilder?.call(_selectedIndex) ?? 70.h;
    final String currentAppBarTitle =
        widget.appBarTitleBuilder?.call(_selectedIndex, context) ?? "WargaQu";

    Widget? currentFab;
    if (widget.fabTriggerIndex != null &&
        _selectedIndex == widget.fabTriggerIndex) {
      currentFab = FloatingActionButton(
        onPressed: () => _showAddTransactionSheet(context),
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'Tambah Transaksi',
        heroTag: null,
        child: const Icon(Icons.add, color: Colors.white),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarBackgroundColor,
          toolbarHeight: currentToolbarHeight,
          automaticallyImplyLeading: false,
          title: Text(currentAppBarTitle,
              maxLines: 2,
              style: widget.specialTitleTriggerIndex != null &&
                      _selectedIndex == widget.specialTitleTriggerIndex
                  ? Theme.of(context).textTheme.titleMedium
                  : GoogleFonts.roboto(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: appBarTitleColor,
                    )),
          centerTitle: widget.specialTitleTriggerIndex != null &&
                  _selectedIndex == widget.specialTitleTriggerIndex
              ? true
              : false,
          actions: [
            if (_selectedIndex == 0)
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NotificationsScreen()));
                  },
                  icon: Icon(
                    Icons.notifications_outlined,
                    size: 30.r,
                  ))
          ],
        ),
        floatingActionButton: AnimatedSwitcher(
            duration: const Duration(milliseconds: 0),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: currentFab ?? const SizedBox.shrink()
        ),
        floatingActionButtonAnimator: NoFabAnimation(),
        body: widget.widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: widget.bottomNavigationBarItems,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary400,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          elevation: 8.0,
          selectedLabelStyle: GoogleFonts.roboto(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.roboto(),
        ));
  }
}
