class DatabaseAlreadyOpenException implements Exception {}

class UnableToGetDocumentsDirectoryException implements Exception {}

class DatabaseIsNotOpenException implements Exception {}

class CouldNotDeleteUserException implements Exception {}

// while trying to add User which already exists with given email
class UserAlreadyExistsException implements Exception {}

// if user does not exist in user table
class UserDoesNotExistException implements Exception {}

// make sure owner exists in the databse with correct id
class InvalidUserException implements Exception {}

// if note that needs to be deleted does not exist
class CouldNotFindNoteException implements Exception {}

// unable to update note
class CouldNotUpdateNoteException implements Exception {}
