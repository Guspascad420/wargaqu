import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/pages/RT/bill_management/add_bills_screen.dart';
import 'package:wargaqu/pages/RT/bill_management/bill_management_tab.dart';
import 'package:wargaqu/pages/RT/bill_management/payment_method_settings_screen.dart';
import 'package:wargaqu/pages/RT/citizen_activity/bill_selector.dart';
import 'package:wargaqu/pages/citizen/bank_account/bank_account_selection_screen.dart';

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
      // Aksi untuk Tab 1
        print("FAB on Tab 1 Pressed: Adding new item...");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aksi untuk Tab Pertama: Tambah Item Baru')),
        );
        break;
      case 1:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddBillsScreen())
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Bill> availableBills = ref.watch(availableBillsProvider);
    final List<BankAccount> bankAccounts = ref.watch(bankAccountsProvider);

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
          floatingActionButton: _currentTabIndex == 2
              ? null
              : FloatingActionButton.extended(
                  onPressed: _handleFabPressed,
                  label: Text('Tambah Iuran Baru'),
                  icon: Icon(Icons.add),
                ),
          body: TabBarView(
            controller: _tabController,
            children: [
              BillManagementTab(availableBills: availableBills),
              BillManagementTab(availableBills: availableBills),
              PaymentMethodSettingsScreen(bankAccounts: bankAccounts)
            ],
          ),
        )
    );
  }
}

