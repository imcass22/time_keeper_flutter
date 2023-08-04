class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in crud
class CouldNotCreateNoteException extends CloudStorageException {}

// R in crud
class CouldNotGetAllNotesException extends CloudStorageException {}

// U in Crud
class CouldNotUpdateNoteException extends CloudStorageException {}

// D in crud
class CouldNotDeleteNoteException extends CloudStorageException {}
