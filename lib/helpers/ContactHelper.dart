import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contactsNew.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $contactTable("
          "$idColumn INTEGER PRIMARY KEY,"
          "$nameColumn TEXT,"
          "$emailColumn TEXT,"
          "$phoneColumn TEXT,"
          "$imgColumn TEXT)");
    });
  }

  // repository

  Future<Contact> save(Contact contact) async {
    Database database = await db;
    contact.id = await database.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> find(int id) async {
    Database database = await db;
    List<Map> maps = await database.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> delete(int id) async {
    Database database = await db;
    return await database
        .delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> update(Contact contact) async {
    Database database = await db;
    return await database.update(contactTable, contact.toMap(),
        where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List<Contact>> list() async {
    Database database = await db;
    List listMap = await database.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for (var map in listMap) {
      listContact.add(Contact.fromMap(map));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database database = await db;
    return Sqflite.firstIntValue(
        await database.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {
    Database database = await db;
    database.close();
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
