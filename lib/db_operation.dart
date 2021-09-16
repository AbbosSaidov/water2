import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:water2/models/loginrequest.dart';
import 'package:water2/models/counterpartyresponse.dart';

class DbOperation{
  Future<Database> openDb() async{
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'errrewtdatabase.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Auth(id INTEGER PRIMARY KEY, isLoginEnded INTEGER DEFAULT 0, userName TEXT, password TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    ) ;
    return database;
  }

  Future<void> insertAuth(Auth auth,Database da)async{
    // Get a reference to the database.
    final Database db = await da;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'Auth',
      auth.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Auth>> auths(Database da) async {
    // Get a reference to the database.
    final Database db = await da;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT password,id,userName,isLoginEnded from Auth');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Auth(
        id: maps[i]['id'],
        password: maps[i]['password'],
        login: maps[i]['userName'],
        isLoginEnded: maps[i]['isLoginEnded'],
      );
    });
  }
  Future<void> updateAuth(Auth auth,Database da)async{
    // Get a reference to the database.
    final db = await da;

    // Update the given Dog.
    await db.update(
      'Auth',
      auth.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [auth.id],
    );
  }
  Future<void> deleteAuth(Database da)async{
    // Get a reference to the database.
    final db = await da;

    // Remove the Dog from the database.
    await db.delete(
      'Auth',
      // Use a `where` clause to delete a specific dog.
      /*  where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],*/
    );
  }
  Future<Database> openDbCounterParties() async{
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'carddatabase.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE CounterParties( name TEXT,"
              " code TEXT NOT NULL UNIQUE, adress TEXT, disctrict TEXT, primechanie TEXT, type TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    ) ;
    return database;
  }
  Future<void> insertCounterParties(CounterParties counterParties,Database da)async{
    // Get a reference to the database.
    final Database db = await da;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'CounterParties',
      counterParties.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<CounterParties>> CounterPartiess(Database da) async {
    // Get a reference to the database.
    final Database db = await da;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT name,name,code,adress,disctrict,primechanie,type from CounterParties');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return CounterParties(
        name: maps[i]['name'],
        code: maps[i]['code'],
        adress: maps[i]['adress'],
        disctrict: maps[i]['disctrict'],
        primechanie: maps[i]['primechanie'],
        type: maps[i]['type'],
      );
    });
  }
  Future<void> updateCounterParties(CounterParties counterParties,String code,Database da)async{
    // Get a reference to the database.
    final db = await da;

    // Update the given Dog.
    await db.update(
      'CounterParties',
      counterParties.toMap(),
      // Ensure that the Dog has a matching id.
      where: "code = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [counterParties.code],
    );
  }
  Future<void> deleteCounterParties(Database da)async{
    // Get a reference to the database.
    final db = await da;

    // Remove the Dog from the database.
    await db.delete(
      'CounterParties',
      // Use a `where` clause to delete a specific dog.
      /*  where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],*/
    );
  }
}
