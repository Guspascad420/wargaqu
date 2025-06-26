import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/components/transaction_tab_view.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/pages/citizen/bank_account/bank_account_selection_screen.dart';
import 'package:wargaqu/pages/citizen/notifications/notifications_screen.dart';
import 'package:wargaqu/theme/app_colors.dart';
import 'package:wargaqu/utils/currency_input_formatter.dart';

import '../providers/rt_providers.dart';

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
  final _amountController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  final _focusNode = FocusNode();
  final dateFormatter = DateFormat('dd/MM/yy, HH:mm');

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateTime) {
      _selectTime(context, picked); // Lanjut pilih waktu setelah tanggal dipilih
    }
  }

  Future<void> _selectTime(BuildContext context, DateTime pickedDate) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Widget amountInputContainer(Color backgroundColor, String sign, TextEditingController amountController,
      FocusNode focusNode, TransactionType selectedType) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Text('Rp', style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Colors.white, fontSize: 20.sp)
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: amountController,
                    focusNode: focusNode,
                    inputFormatters: [
                      SignedAmountFormatter(sign: selectedType == TransactionType.income ? '+' : '-'),
                    ],
                    textAlign: TextAlign.right,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.roboto(
                      fontSize: 38.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      fillColor: backgroundColor,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: '${sign}0',
                      hintStyle: GoogleFonts.roboto(
                        fontSize: 38.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mainTransactionSheetContent(BuildContext context,
      WidgetRef ref,
      List<BankAccount> mockBankAccounts,
      TextEditingController titleController,
      String expectedSign,
      VoidCallback onEditTitleTap) {

    final selectedType = ref.watch(transactionTypeProvider);
    final selectedAccountId = ref.watch(selectedAccountIdProvider);
    final bankAccounts = ref.watch(rtDataProvider)?.bankAccounts;
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem<String>(
        value: "Kas Tunai RT",
        child: Text("Kas Tunai RT", style: GoogleFonts.roboto(fontSize: 15.sp,
            fontWeight: FontWeight.w500)),
      )
    ];

    if (bankAccounts != null) {
     List<DropdownMenuItem<String>> bankAccountMenuItems = bankAccounts.map((BankAccount account) {
        return DropdownMenuItem<String>(
          value: account.id,
          child: Text(account.bankName, style: GoogleFonts.roboto(fontSize: 15.sp, fontWeight: FontWeight.w500)),
        );
      }).toList();
      menuItems.addAll(bankAccountMenuItems);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              color: _getBottomSheetBackgroundColor(selectedType),
            ),
            child: TransactionTabView(),
          ),
          amountInputContainer(_getBottomSheetBackgroundColor(selectedType),
              expectedSign, _amountController, _focusNode, selectedType),
          InkWell(
            onTap: onEditTitleTap,
            child: _buildDetailRow(
                context,
                Icons.edit_outlined,
                'Judul',
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 8.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      titleController.text.isEmpty
                          ? Text('Wajib diisi',
                              style: GoogleFonts.roboto(fontSize: 15.sp, color: Colors.red))
                          : Text(titleController.text,
                          style: GoogleFonts.roboto(fontSize: 15.sp, color: Colors.grey)),
                      Icon(Icons.keyboard_arrow_right_rounded)
                    ],
                  ),
                )
            ),
          ),
          Divider(color: Colors.grey),
          _buildDetailRow(
            context,
            Icons.account_balance_wallet_outlined,
            'Rekening',
            DropdownButton<String>(
              value: selectedAccountId,
              hint: Text('Pilih...', style: GoogleFonts.roboto(fontSize: 15.sp)),
              underline: const SizedBox.shrink(),
              icon: Icon(Icons.expand_more, color: Theme.of(context).primaryColor),
              items: menuItems,
              onChanged: (String? newValue) {
                ref.read(selectedAccountIdProvider.notifier).state = newValue;
              },
            ),
          ),
          Divider(color: Colors.grey),
          InkWell(
            onTap: () => _selectDate(context),
            child: _buildDetailRow(
                context,
                Icons.calendar_today_outlined,
                'Tanggal',
                Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 8.h),
                    child: Row(
                      children: [
                        Text(
                          dateFormatter.format(_selectedDateTime),
                          style: GoogleFonts.roboto(fontSize: 15.sp, fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor),
                        ),
                        Icon(Icons.expand_more, color: Theme.of(context).primaryColor),
                      ],
                    )
                )
            ),
          ),
          Divider(color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 24.sp),
          SizedBox(width: 16.w),
          Text(title, style: GoogleFonts.roboto(fontSize: 15.sp, color: Colors.grey.shade800)),
          const Spacer(),
          child,
        ],
      ),
    );
  }

  Widget _buildStickySaveButton(BuildContext context, TextEditingController titleController) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            )
          ]
      ),
      child: ElevatedButton(
        onPressed: (_amountController.text.substring(1,2) == '0'
            || titleController.text.isEmpty) ? null : () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.primary400,
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: Text('Simpan', style: GoogleFonts.roboto(fontSize: 15.sp,
            fontWeight: FontWeight.bold, color: Colors.white),),
      ),
    );
  }

  Widget titleEditor(
    BuildContext context,
    TextEditingController controller,
    Function(String) onSave,
    VoidCallback onCancel,
  ) {
    return Column(
      children: [
        // AppBar custom buat di dalem sheet
        Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onCancel, // Panggil callback cancel
              ),
              Text('Tambah Judul', style: GoogleFonts.roboto(fontSize: 18.sp,
                  fontWeight: FontWeight.bold, color: Colors.white)),
              IconButton(
                  onPressed: () => onSave(controller.text),
                  icon: Icon(Icons.check, color: Colors.white)
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(24.0),
          child: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Judul Transaksi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (value) => onSave(value), // Simpan juga kalo user teken enter
          ),
        ),
      ],
    );
  }

  Color _getBottomSheetBackgroundColor(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return AppColors.negative; // Example color for expense
      case TransactionType.income:
        return AppColors.positive;
    }
  }

  void _showAddTransactionSheet(BuildContext context, List<BankAccount> bankAccounts) {
    bool isEditingTitle = false;
    final titleController = TextEditingController();

    final initialSelectedType = ref.read(transactionTypeProvider); // Read once
    final initialSign = initialSelectedType == TransactionType.income ? '+' : '-';
    _amountController.text = '${initialSign}0';
    String transactionTitle = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!isEditingTitle) {
                _focusNode.requestFocus();
              }
            });
            return PopScope(
              canPop: !isEditingTitle,
              onPopInvoked: (bool didPop) {
                if (didPop) return;

                setModalState(() {
                  transactionTitle = titleController.text;
                  isEditingTitle = false;
                });
              },
              child: Consumer(
                builder: (context, ref, child) {
                  final selectedType = ref.watch(transactionTypeProvider);
                  final String currentText = _amountController.text;
                  final String expectedSign = selectedType == TransactionType.income ? '+' : '-';
                  final String currentSignPrefix = currentText.isNotEmpty ? currentText[0] : '';

                  // Only update if the prefix is wrong AND there's more than just a sign or empty
                  if (currentSignPrefix.isNotEmpty && currentSignPrefix != expectedSign) {
                    final String numericPart = currentText.substring(1);

                    // Schedule update after build to avoid conflicts
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Check again in callback in case of rapid changes
                      if (_amountController.text.isNotEmpty && _amountController.text[0] != expectedSign) {
                        _amountController.value = TextEditingValue(
                          text: '$expectedSign$numericPart',
                          selection: TextSelection.fromPosition(
                            TextPosition(offset: ('$expectedSign$numericPart').length),
                          ),
                        );
                      }
                    });
                  }

                  return Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).scaffoldBackgroundColor
                    ),
                    child: isEditingTitle
                        ? titleEditor(
                            context,
                            titleController,
                                (newTitle) {
                              setModalState(() {
                                transactionTitle = newTitle;
                                isEditingTitle = false;
                              });
                            },
                                () {
                              setModalState(() {
                                isEditingTitle = false;
                              });
                            }
                        )
                        : Column(
                      children: [
                        Expanded(
                            child: mainTransactionSheetContent(
                                context, ref, bankAccounts,
                                titleController, expectedSign,
                                    () {
                                      setModalState(() {
                                        titleController.text = transactionTitle;
                                        isEditingTitle = true;
                                      });
                                    }
                            )
                        ),
                        _buildStickySaveButton(context, titleController)
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUG: Setting initial amount: ${_amountController.text}");

    Color appBarBackgroundColor;
    Color appBarTitleColor;
    final List<BankAccount> bankAccounts = ref.watch(mockBankAccountsProvider);

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
        onPressed: () => _showAddTransactionSheet(context, bankAccounts),
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
