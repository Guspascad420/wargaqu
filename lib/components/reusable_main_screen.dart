import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/pages/citizen/notifications/notifications_screen.dart';
import 'package:wargaqu/theme/app_colors.dart';

class ReusableMainScreen extends StatefulWidget {
  const ReusableMainScreen({super.key, required this.bottomNavigationBarItems,
    required this.widgetOptions,
    this.appBarTitleBuilder, this.toolbarHeightBuilder,
    this.specialAppBarColorTriggerIndex, this.specialAppBarColor,
    this.defaultAppBarColor, this.specialTitleTriggerIndex});

  final List<BottomNavigationBarItem> bottomNavigationBarItems;
  final List<Widget> widgetOptions;
  final String Function(int selectedIndex, BuildContext context)? appBarTitleBuilder;
  final double Function(int selectedIndex)? toolbarHeightBuilder;
  final int? specialAppBarColorTriggerIndex;
  final int? specialTitleTriggerIndex;
  final Color? specialAppBarColor;
  final Color? defaultAppBarColor;

  @override
  State<ReusableMainScreen> createState() => _ReusableMainScreenState();
}

class _ReusableMainScreenState extends State<ReusableMainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color appBarBackgroundColor;
    if (widget.specialAppBarColorTriggerIndex != null &&
        _selectedIndex == widget.specialAppBarColorTriggerIndex) {
      appBarBackgroundColor = widget.specialAppBarColor ?? AppColors.primary400;
    } else {
      appBarBackgroundColor = widget.defaultAppBarColor ??
          Theme.of(context).appBarTheme.backgroundColor ??
          Colors.deepPurple;
    }

    final double currentToolbarHeight = widget.toolbarHeightBuilder?.call(_selectedIndex) ?? 70.h;
    final String currentAppBarTitle = widget.appBarTitleBuilder?.call(_selectedIndex, context) ?? "WargaQu";

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarBackgroundColor,
          toolbarHeight: currentToolbarHeight,
          automaticallyImplyLeading: false,
          title: Text(currentAppBarTitle,
              maxLines: 2, style: widget.specialTitleTriggerIndex != null
                  && _selectedIndex == widget.specialTitleTriggerIndex ? Theme.of(context).textTheme.titleMedium
                  : Theme.of(context).textTheme.titleLarge),
          centerTitle: widget.specialTitleTriggerIndex != null
              && _selectedIndex == widget.specialTitleTriggerIndex ? true : false,
          actions: [
            if (_selectedIndex == 0)
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const NotificationsScreen())
                    );
                  },
                  icon: Icon(Icons.notifications_outlined, size: 30.r,)
              )
          ],
        ),
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
        )
    );
  }

}