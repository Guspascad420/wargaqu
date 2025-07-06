import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/components/transaction_tab_view.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/providers/providers.dart';

import '../providers/rt_providers.dart';
import '../providers/user_providers.dart';
import '../theme/app_colors.dart';
import '../utils/currency_input_formatter.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  ConsumerState<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  bool _isEditingTitle = false;
  String _transactionTitle = '';
  String _selectedAccountId = 'Kas Tunai RT';
  bool _didSubmit = false;
  final _titleEditController = TextEditingController();
  final _amountController = TextEditingController();
  final _focusNode = FocusNode();
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _titleEditController.dispose();
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
      _selectTime(context, picked);
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

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 24.sp),
          SizedBox(width: 16.w),
          Text(title, style: GoogleFonts.roboto(fontSize: 15.sp, color: Theme.of(context).colorScheme.onSurface)),
          const Spacer(),
          child,
        ],
      ),
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

  Widget _buildMainForm(BuildContext context, String expectedSign) {
    final bankAccounts = ref.watch(rtDataProvider)?.bankAccounts;
    final dateFormatter = DateFormat('dd/MM/yy, HH:mm');
    final selectedType = ref.watch(transactionTypeProvider);

    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem<String>(
        value: "Kas Tunai RT",
        alignment: AlignmentDirectional.centerEnd,
        child: Text("Kas Tunai RT", style: GoogleFonts.roboto(fontSize: 15.sp,
            fontWeight: FontWeight.w500)),
      )
    ];
    if (bankAccounts != null) {
      List<DropdownMenuItem<String>> bankAccountMenuItems = bankAccounts.map((BankAccount account) {
        return DropdownMenuItem<String>(
          value: account.id,
          alignment: AlignmentDirectional.centerEnd,
          child: Text(account.bankName, style: GoogleFonts.roboto(fontSize: 15.sp, fontWeight: FontWeight.w500)),
        );
      }).toList();
      menuItems.addAll(bankAccountMenuItems);
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: _getBottomSheetBackgroundColor(selectedType),
            ),
            child: TransactionTabView(),
          ),
          amountInputContainer(_getBottomSheetBackgroundColor(selectedType),
              expectedSign, _amountController, _focusNode, selectedType),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Judul'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _transactionTitle.isEmpty ? 'Wajib diisi' : _transactionTitle,
                  style: GoogleFonts.roboto(fontSize: 15.sp, color: _transactionTitle.isEmpty ? Colors.red : Colors.grey.shade700),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () {
              setState(() {
                _titleEditController.text = _transactionTitle;
                _isEditingTitle = true;
              });
            },
          ),
          Divider(color: Colors.grey),
          _buildDetailRow(
            context,
            Icons.account_balance_wallet_outlined,
            'Rekening',
            DropdownButton<String>(
              value: _selectedAccountId,
              hint: Text('Pilih...', style: GoogleFonts.roboto(fontSize: 15.sp)),
              underline: const SizedBox.shrink(),
              icon: Icon(Icons.expand_more, color: Theme.of(context).colorScheme.onSurface),
              items: menuItems,
              alignment: AlignmentDirectional.centerEnd,
              onChanged: (String? newValue) {
                _selectedAccountId = newValue!;
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
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        Icon(Icons.expand_more, color: Theme.of(context).colorScheme.onSurface),
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

  Widget _buildTitleEditor(BuildContext context) {
    return Column(
      children: [
        AppBar(
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _isEditingTitle = false)),
          centerTitle: true,
          title: Text('Ubah Judul', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(icon: const Icon(Icons.check), onPressed: (){
              setState(() {
                _transactionTitle = _titleEditController.text;
                _isEditingTitle = false;
              });
            })
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _titleEditController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Judul Transaksi',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            onSubmitted: (value) {
              setState(() {
                _transactionTitle = value;
                _isEditingTitle = false;
              });
            },
          ),
        ),
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    final selectedType = ref.watch(transactionTypeProvider);

    final String currentText = _amountController.text;
    final String expectedSign = selectedType == TransactionType.income ? '+' : '-';
    final String currentSignPrefix = currentText.isNotEmpty ? currentText[0] : '';

    if (currentSignPrefix.isNotEmpty && currentSignPrefix != expectedSign) {
      final String numericPart = currentText.substring(1);

      if (_amountController.text.isNotEmpty && _amountController.text[0] != expectedSign) {
        _amountController.value = TextEditingValue(
          text: '$expectedSign$numericPart',
          selection: TextSelection.fromPosition(
            TextPosition(offset: ('$expectedSign$numericPart').length),
          ),
        );
      }
    }

    final rtData = ref.watch(rtDataProvider);
    final userId = ref.watch(userIdProvider);
    final formState = ref.watch(transactionNotifierProvider);
    ref.listen<AsyncValue<void>>(transactionNotifierProvider, (prev, next) {
      if (!_didSubmit) return;

      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );

      } else if (next is AsyncData<void>) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data transaksi berhasil disimpan!')),
        );
        Navigator.of(context).pop();
        setState(() {
          _didSubmit = false;
        });
      }
    });

    return PopScope(
      canPop: !_isEditingTitle,
      onPopInvoked: (bool didPop) {
        if (didPop) return;

        setState(() {
          _transactionTitle = _titleEditController.text;
          _isEditingTitle = false;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            // Grabber
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: _isEditingTitle ? Theme.of(context).colorScheme.surface : _getBottomSheetBackgroundColor(selectedType),
              ),
              child: Center(
                child: Container(
                  width: 40.w, height: 5.h,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                )
              )
            ),
            // AnimatedSwitcher untuk ganti halaman
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _isEditingTitle ? _buildTitleEditor(context) : _buildMainForm(context, expectedSign),
            ),
            _isEditingTitle
                ? SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.all(16.w),
                    child: ElevatedButton(
                      onPressed: (_amountController.text.isEmpty ||
                          _titleEditController.text.isEmpty ||
                          (_amountController.text.length >= 2 && _amountController.text.substring(1, 2) == '0'))
                          ? null
                          : () {
                              final formattedText = _amountController.text;
                              int amountAsInt = SignedAmountFormatter.formatCurrencyStringToInt(formattedText);
                              setState(() {
                                _didSubmit = true;
                              });
                              selectedType == TransactionType.expense
                                  ? ref.read(transactionNotifierProvider.notifier).executeNewExpense(
                                      rtId: rtData!.id,
                                      description: _titleEditController.text,
                                      amount: amountAsInt,
                                      expenseDate: _selectedDateTime,
                                      inputtedByUserId: userId!
                                    )
                                  : ref.read(transactionNotifierProvider.notifier).executeNewIncome(
                                      rtId: rtData!.id,
                                      description: _titleEditController.text,
                                      amount: amountAsInt,
                                      incomeDate: _selectedDateTime,
                                      inputtedByUserId: userId!
                                  );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary400,
                          minimumSize: Size(double.infinity, 50.h)),
                      child: formState.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Simpan', style: GoogleFonts.roboto(color: Colors.white,
                              fontWeight: FontWeight.bold, fontSize: 17.sp)),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}