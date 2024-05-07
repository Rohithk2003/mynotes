import 'package:MyNotes/services/crud/crud_exceptions.dart';
import 'package:MyNotes/services/crud/crud_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
        "id" INTEGER NOT NULL,
        "user_id" INTEGER NOT NULL,
        "text" TEXT,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';

class NotesService {
  Database? _db;

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> deleteUser({
    required String email,
  }) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<DatabaseUser> createUser({
    required String email,
  }) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }
    int id = await db.insert(
      userTable,
      {emailColumn: email.toLowerCase()},
    );
    return DatabaseUser(id: id, email: email);
  }

  Future<DatabaseUser> getUser({
    required String email,
  }) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw UserDoesNotExistException();
    }
    return DatabaseUser.fromRow(results.first);
  }

  Future<DatabaseNote> createNote({
    required DatabaseUser owner,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw InvalidUserException();
    }

    final noteId = await db.insert(
      noteTable,
      {
        userIdColumn: dbUser.id,
        textColumn: text,
      },
    );
    return DatabaseNote.fromRow(
      {
        idColumn: noteId,
        userIdColumn: dbUser.id,
        text: text,
      },
    );
  }

  Future<DatabaseNote> getNote({
    required int id,
  }) async {
    final db = _getDatabaseOrThrow();
    final note = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (note.isEmpty) {
      throw CouldNotFindNoteException();
    }
    return DatabaseNote.fromRow(note.first);
  }

  Future<DatabaseNote> updateNote({
    required int id,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: id);
    final updateCount = await db.update(
      noteTable,
      {
        textColumn: text,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    if (updateCount == 0) {
      throw CouldNotUpdateNoteException();
    }
    final updatedNote = await getNote(
      id: id,
    );
    return updatedNote;
  }

  Future<Iterable<DatabaseNote>> getAllNote({
    required String email,
  }) async {
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: email);

    final notes = await db.query(
      noteTable,
      where: 'user_id = ?',
      whereArgs: [dbUser.id],
    );
    final notesRow = notes.map((n) => DatabaseNote.fromRow(n));
    return notesRow;
  }

  Future<void> deleteNote({
    required int id,
  }) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotFindNoteException();
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    int noOfRows = await db.delete(noteTable);
    return noOfRows;
  }

  Future<int> deleteAllNotesOfaUser({
    required String email,
  }) async {
    final db = _getDatabaseOrThrow();

    final dbUser = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [
        email.toLowerCase(),
      ],
    );
    if (dbUser.isEmpty) {
      throw UserDoesNotExistException();
    }
    DatabaseUser user = DatabaseUser.fromRow(dbUser.first);
    int noOfRows =
        await db.delete(noteTable, where: 'user_id = ?', whereArgs: [user.id]);
    return noOfRows;
  }

  Future<void> open() async {
    if (_db == null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);

      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;
  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;

  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String;

  @override
  String toString() => 'Note, ID = $id, userId = $userId, Text = $text';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
