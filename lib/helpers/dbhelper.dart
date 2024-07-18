import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/rent_payment_class.dart';
import '../classes/tenant_class.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String tenantTable = 'tenant_table';
  String colId = 'id';
  String colName = 'name';
  String colAddress = 'address';
  String colContractDuration = 'contractDuration';
  String colPhoneNumber = 'phoneNumber';
  String colRentAmount = 'rentAmount';
  String colStartDate = 'startDate';

  String paymentTable = 'payment_table';
  String colTenantId = 'tenantId';
  String colMonth = 'month';
  String colAmount = 'amount';
  String colIsPaid = 'isPaid';
  String colPaymentDate = 'paymentDate';
  String colPaidAmount = 'paidAmount';

  Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, 'tenant_payments.db');
    final db = await openDatabase(dbPath, version: 2, onCreate: _createDb, onUpgrade: _upgradeDb);
    return db;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $tenantTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colAddress TEXT, $colContractDuration INTEGER, $colPhoneNumber TEXT, $colRentAmount REAL, $colStartDate TEXT)',
    );

    await db.execute(
      'CREATE TABLE $paymentTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTenantId INTEGER, $colMonth TEXT, $colAmount REAL, $colIsPaid INTEGER, $colPaymentDate TEXT, $colPaidAmount REAL)',
    );
  }

  void _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $paymentTable ADD COLUMN $colPaidAmount REAL');
      await db.execute('ALTER TABLE $paymentTable ADD COLUMN $colPaymentDate TEXT');
    }
  }

  Future<int> insertTenant(Tenant tenant) async {
    final db = await this.db;
    final int result = await db!.insert(tenantTable, tenant.toMap());
    return result;
  }

  Future<List<Tenant>> getTenantList() async {
    final db = await this.db;
    final List<Map<String, dynamic>> tenantMapList = await db!.query(tenantTable);
    final List<Tenant> tenantList = [];
    for (var tenantMap in tenantMapList) {
      tenantList.add(Tenant.fromMap(tenantMap));
    }
    return tenantList;
  }

  Future<int> insertPayment(RentPayment payment) async {
    final db = await this.db;
    final int result = await db!.insert(paymentTable, payment.toMap());
    return result;
  }

  Future<List<RentPayment>> getPaymentList(int tenantId) async {
    final db = await this.db;
    final List<Map<String, dynamic>> paymentMapList = await db!.query(paymentTable, where: '$colTenantId = ?', whereArgs: [tenantId]);
    final List<RentPayment> paymentList = [];
    for (var paymentMap in paymentMapList) {
      paymentList.add(RentPayment.fromMap(paymentMap));
    }
    return paymentList;
  }

  Future<int> updatePayment(RentPayment payment) async {
    final db = await this.db;
    final int result = await db!.update(paymentTable, payment.toMap(), where: '$colId = ?', whereArgs: [payment.id]);
    return result;
  }

  Future<int> deleteTenant(int id) async {
    final db = await this.db;
    final int result = await db!.delete(tenantTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  // Add the updateTenant method
  Future<int> updateTenant(Tenant tenant) async {
    final db = await this.db;
    final int result = await db!.update(tenantTable, tenant.toMap(), where: '$colId = ?', whereArgs: [tenant.id]);
    return result;
  }
}
