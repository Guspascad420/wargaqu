import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/pages/RT/bill_management/add_bills_screen.dart';
import 'package:wargaqu/pages/RT/bill_management/bill_management_tab.dart';
import 'package:wargaqu/pages/RT/bill_management/new_bank_account_form/new_bank_account_form.dart';
import 'package:wargaqu/pages/RT/bill_management/payment_method_settings_tab.dart';
import 'package:wargaqu/pages/RT/citizen_activity/bill_selector.dart';
import 'package:wargaqu/pages/citizen/bank_account/bank_account_selection_screen.dart';

import '../../../providers/rt_providers.dart';

class BillManagementScreen extends ConsumerStatefulWidget {
  const BillManagementScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BillManagementScreenState();
}

class _BillManagementScreenState extends ConsumerState<BillManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
      print("Current Tab Index: $_currentTabIndex");
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleFabPressed() {
    switch (_currentTabIndex) {
      case 0:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddBillsScreen(billType: BillType.regular))
        );
        break;
      case 1:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddBillsScreen(billType: BillType.incidental))
        );
        break;
      case 2:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NewBankAccountForm())
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rtData = ref.watch(rtDataProvider);
    final List<BankAccount> bankAccounts = rtData!.bankAccounts;

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                'Pengelolaan Pembayaran Iuran',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              toolbarHeight: 65.h,
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kTextTabBarHeight),
                  child: Material(
                    elevation: 3,
                    shadowColor: Colors.black.withOpacity(0.4),
                    child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
                        tabs: [
                          Tab(text: 'Iuran Bulanan'),
                          Tab(text: 'Iuran Khusus'),
                          Tab(text: 'Pengaturan Pembayaran'),
                        ]
                    ),
                  )
              )
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _handleFabPressed,
            label: Text(_currentTabIndex == 2 ? 'Tambah Rekening' : 'Tambah Iuran Baru',
                style: GoogleFonts.roboto(fontWeight: FontWeight.w600, color: Colors.white)),
            icon: Icon(Icons.add, color: Colors.white),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              BillManagementTab(billType: BillType.regular),
              BillManagementTab(billType: BillType.incidental),
              PaymentMethodSettingsTab(bankAccounts: bankAccounts)
            ],
          ),
        )
    );
  }
}

