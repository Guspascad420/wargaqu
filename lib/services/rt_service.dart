import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/expense/expense.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/model/unique_code/unique_code.dart';
import 'package:wargaqu/model/user/user.dart';

import '../model/citizen/citizen_with_status.dart';
import '../model/income/income.dart';
import '../model/transaction/transaction_data.dart';

class RtService {
  final FirebaseFirestore _firestore;

  RtService(this._firestore);

  Future<({String role, String rtId, String rwId})> validateRt(String uniqueCode) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('registrationCodes')
          .where('code', isEqualTo: uniqueCode)
          .where('status', isEqualTo: 'AVAILABLE')
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Kode unik tidak valid!');
      }
      final codeDoc = querySnapshot.docs.first;
      final String rtId = codeDoc.reference.parent.parent!.id;
      final String role = codeDoc.data()['role'];

      final DocumentSnapshot rtDoc = await _firestore.collection('rts').doc(rtId).get();

      final rwMap = rtDoc.data() as Map<String, dynamic>;
      final String rwIdValue = rwMap['rwId'];
      return (rtId: rtId, role: role, rwId: rwIdValue);
    } on FirebaseException catch (e) {
      throw Exception('Gagal mengambil data: ${e.message}');
    }
  }

  Future<void> claimRtCode(String rtId, String role, String officialName, String uniqueCode, WriteBatch batch) async {
    final querySnapshot = await _firestore.collection('rts')
        .doc(rtId).collection('registrationCodes').where('code', isEqualTo: uniqueCode).limit(1).get();
    final uniqueCodeRef = querySnapshot.docs.first.reference;

    batch.update(uniqueCodeRef, {
      'role': role,
      'status': 'USED',
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchRtDocStream(String rtId) {
    return _firestore
        .collection('rts')
        .doc(rtId)
        .snapshots();
  }

  Future<List<UserModel>> fetchRtTreasurers(String rtId) async {
    final snapshot = await _firestore
        .collection('users')
        .where('rtId', isEqualTo: rtId)
        .where('role', isEqualTo: 'bendahara_rt')
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return UserModel.fromJson(data);
    }).toList();
  }

  Stream<List<CitizenWithStatus>> fetchCitizensWithPaymentStatus(String rtId, String selectedBillPeriod) {
    try {
      final querySnapshotStream = _firestore
          .collection('bills')
          .where('rtId', isEqualTo: rtId)
          .where('role', isEqualTo: "warga")
          .snapshots();

      return querySnapshotStream.map((snapshot) {
        if (snapshot.docs.isEmpty) {
          return [];
        }

        return snapshot.docs.map((doc) {
          final user = UserModel.fromJson(doc.data());

          final status = user.billsStatus[selectedBillPeriod] ?? 'belum_bayar';

          return CitizenWithStatus(user: user, paymentStatus: status);
        }).toList();
      });
    } catch (e) {
      throw Exception('Gagal memuat data pengguna.');
    }
  }

  Stream<List<UserModel>> fetchPendingCitizens(String rtId) {
    final querySnapshotStream = _firestore
        .collection('users')
        .where("rtId", isEqualTo: rtId)
        .where("status", isEqualTo: "pending_confirmation")
        .snapshots();
    return querySnapshotStream.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return UserModel.fromJson(data);
      }).toList();
    });
  }

  Future<UserModel?> fetchRtChairman(String rtId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('rtId', isEqualTo: rtId)
          .where('role', isEqualTo: 'ketua_rt')
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final chairmanMap = snapshot.docs.first.data();
      return UserModel.fromJson(chairmanMap);

    } on FirebaseException catch (e) {
      throw Exception('Gagal mengambil data: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga');
    }
  }

  Future<List<ReportData>> fetchMonthlyReportsByRtId(String rtId) async {
    try {
      final snapshot = await _firestore
          .collection('monthlyReports')
          .where('rtId', isEqualTo: rtId)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MonthlyReport.fromJson(data);
      }).toList();

    } catch (e) {
      throw Exception('Gagal memuat data rekening bank.');
    }
  }

  Stream<List<UniqueCode>> fetchRegistrationCodes(String rtId) {
    final querySnapshotStream = _firestore
        .collection('rts')
        .doc(rtId)
        .collection('registrationCodes')
        .snapshots();

    return querySnapshotStream.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return UniqueCode.fromJson(data);
      }).toList();
    });
  }

  Future<List<ReportData>> fetchYearlyReportsByRtId(String rtId) async {
    try {
      final snapshot = await _firestore
          .collection('yearlyReports')
          .where('rtId', isEqualTo: rtId)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return YearlyReport.fromJson(data);
      }).toList();

    } catch (e) {
      print('Error pas ngambil rekening bank: $e');
      throw Exception('Gagal memuat data rekening bank.');
    }
  }

  Future<List<RtData>> fetchRtsByRwId(String rwId) async {
    try {
      final snapshot = await _firestore.collection('rts').where('rwId', isEqualTo: rwId).get();
      if (snapshot.docs.isEmpty) return [];
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return RtData.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception("Gagal memuat daftar RT.");
    }
  }

  Stream<List<RtData>> fetchRtsByRwIdStream(String rwId) {
    final querySnapshotStream = _firestore
        .collection('rts')
        .where("rwId", isEqualTo: rwId)
        .snapshots();

    return querySnapshotStream.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return RtData.fromJson(data);
      }).toList();
    });
  }
  Stream<List<TransactionData>> fetchTransactions(String rtId) {
    final incomeSnapshotStream = _firestore
        .collection('rts')
        .doc(rtId)
        .collection('incomes')
        .snapshots();

    Stream<List<TransactionData>> incomeStream = incomeSnapshotStream.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return TransactionData.fromJson(data);
      }).toList();
    });

    final expenseSnapshotStream = _firestore
        .collection('rts')
        .doc(rtId)
        .collection('expenses')
        .snapshots();

    Stream<List<TransactionData>> expenseStream = expenseSnapshotStream.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return TransactionData.fromJson(data);
      }).toList();
    });


    return Rx.combineLatest2(
      incomeStream,
      expenseStream,
       (List<TransactionData> incomes, List<TransactionData> expenses) {
        final combinedList = [...incomes, ...expenses];
        combinedList.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
        return combinedList;
      },
    );
  }


  Future<void> addExpense({
    required String rtId,
    required Expense newExpense,
  }) async
  {
    final rtDocRef = _firestore.collection('rts').doc(rtId);
    final newExpenseDocRef = rtDocRef.collection('expenses').doc();

    final currentDate = DateTime.now();
    final periodId = DateFormat('yyyy-MM').format(currentDate);
    final reportId = '${rtId}_$periodId';
    final reportDocRef = _firestore.collection('monthlyReports').doc(reportId);

    try {
      await _firestore.runTransaction((transaction) async {
        final reportDoc = await transaction.get(reportDocRef);

        transaction.set(newExpenseDocRef, {
          ...newExpense.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
          'runtimeType': 'expense'
        });

        transaction.update(rtDocRef, {
          'currentBalance': FieldValue.increment(-newExpense.amount),
          'updatedAt': FieldValue.serverTimestamp(),
          'currentMonthExpenses': FieldValue.increment(newExpense.amount),
        });

        if (!reportDoc.exists) {
          transaction.set(reportDocRef, {
            'entityId': rtId,
            'periodYearMonth': periodId,
            'monthlyIncome': 0,
            'monthlyExpenses': newExpense.amount,
            'netMonthlyResult': -newExpense.amount,
            'outgoingTransactionCount': 1,
            'runtimeType': 'monthly'
          });
        }
        else {
          final currentData = reportDoc.data()!;
          final newNetResult = (currentData['monthlyIncome'] ?? 0) - newExpense.amount - (currentData['monthlyExpenses'] ?? 0);

          transaction.update(reportDocRef, {
            'monthlyExpenses': FieldValue.increment(newExpense.amount),
            'outgoingTransactionCount': FieldValue.increment(1),
            'netMonthlyResult': newNetResult,
          });
        }
      });
    } on FirebaseException catch (e) {
      print('Firebase Error saat mencatat pengeluaran: ${e.message}');
      throw Exception('Gagal menyimpan data pengeluaran: ${e.code}');
    } catch (e) {
      print('General Error saat mencatat pengeluaran: $e');
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<void> addIncome({
    required String rtId,
    required Income newIncome,
  }) async {
    final rtDocRef = _firestore.collection('rts').doc(rtId);
    final newIncomeDocRef = rtDocRef.collection('incomes').doc();

    final currentDate = DateTime.now();
    final periodId = DateFormat('yyyy-MM').format(currentDate);
    final reportId = '${rtId}_$periodId';
    final reportDocRef = _firestore.collection('monthlyReports').doc(reportId);

    try {
      await _firestore.runTransaction((transaction) async {
        final reportDoc = await transaction.get(reportDocRef);

        transaction.set(newIncomeDocRef, {
          ...newIncome.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
          'runtimeType': 'income'
        });

        transaction.update(rtDocRef, {
          'currentBalance': FieldValue.increment(newIncome.amount),
          'updatedAt': FieldValue.serverTimestamp(),
          'currentMonthIncome': FieldValue.increment(newIncome.amount),
        });

        if (!reportDoc.exists) {
          transaction.set(reportDocRef, {
            'entityId': rtId,
            'periodYearMonth': periodId,
            'monthlyIncome': newIncome.amount,
            'monthlyExpenses': 0,
            'netMonthlyResult': newIncome.amount,
            'incomingTransactionCount': 1,
            'outgoingTransactionCount': 0,
            'lastUpdated': FieldValue.serverTimestamp(),
            'runtimeType': 'monthly'
          });
        } else {
          final currentData = reportDoc.data()!;
          final newNetResult = (currentData['monthlyIncome'] ?? 0) + newIncome.amount - (currentData['monthlyExpenses'] ?? 0);

          transaction.update(reportDocRef, {
            'monthlyIncome': FieldValue.increment(newIncome.amount),
            'incomingTransactionCount': FieldValue.increment(1),
            'netMonthlyResult': newNetResult,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      });
    } on FirebaseException catch (e) {
      print('Firebase Error saat mencatat pengeluaran: ${e.message}');
      throw Exception('Gagal menyimpan data pengeluaran: ${e.code}');
    } catch (e) {
      print("Gagal menjalankan transaksi: $e");
      // Lempar lagi errornya biar bisa ditangani di Notifier/UI
      throw Exception("Gagal menyimpan transaksi pemasukan.");
    }
  }

  Future<void> addNewCode({
    required String rtId,
    required UniqueCode newCode,
  }) async {
    try {
      await _firestore.collection('rts').doc(rtId).collection('registrationCodes').add(newCode.toJson());
    } on FirebaseException catch (e) {
      throw Exception('Gagal menyimpan data pengeluaran: ${e.code}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<void> deleteCode({
    required String rtId,
    required String codeToDelete,
  }) async {
    try {
     QuerySnapshot querySnapshot =  await _firestore.collection('rts').doc(rtId)
         .collection('registrationCodes').where('code', isEqualTo: codeToDelete).get();
     if (querySnapshot.docs.isNotEmpty) {
       DocumentSnapshot docToDelete = querySnapshot.docs.first;

       await docToDelete.reference.delete();
     }
    } on FirebaseException catch (e) {
      throw Exception('Gagal menyimpan data pengeluaran: ${e.code}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<void> addBankAccount({
    required String rtId,
    required String bankName,
    required String accountNumber,
    required String accountHolder,
  }) async {
    try {
      final bankAccount = BankAccount(bankName: bankName, accountNumber: accountNumber, accountHolder: accountHolder);
      await _firestore.collection('rts').doc(rtId).update({'bankAccounts': FieldValue.arrayUnion([bankAccount.toJson()])});
    } on FirebaseException catch (e) {
      throw Exception('Gagal menyimpan data pengeluaran: ${e.code}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<void> addNewRt({
    required int rtNumber,
    required String rtName,
    required String rwId,
    required String address,
  }) async {
    try {
      await _firestore.collection('rts').add({
        'rtNumber': rtNumber,
        'rtName': rtName,
        'rwId': rwId,
        'address': address,
        'currentBalance': 0,
        'bankAccounts': []
      });
    } on FirebaseException catch (e) {
      throw Exception('Gagal menyimpan data pengeluaran: ${e.code}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<void> updateCitizenStatus({
    required String userId,
    required bool isApproved,
    String? rejectionReason,
    String? rtId
  }) async {
    try {
      if (isApproved && rtId != null) {
        await _firestore.runTransaction((transaction) async {
          final userRef = _firestore.collection('users').doc(userId);
          transaction.update(userRef, {'status': 'ACTIVE'});

          final rtRef = _firestore.collection('rts').doc(rtId);
          transaction.update(rtRef, {'population': FieldValue.increment(1)});
        });
        debugPrint('User status dan populasi RT berhasil diupdate secara transaksional! 🎉');
      } else {
        await _firestore.collection('users').doc(userId).update({'status': 'rejected',
          "rejectionReason": rejectionReason, "rejectedAt": DateTime.now()});
      }
    } on FirebaseException catch (e) {
      throw Exception('Gagal memperbarui status: ${e.code}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }
}