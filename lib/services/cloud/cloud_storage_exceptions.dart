class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CouldNotCreateException extends CloudStorageExceptions {}

class CouldNotGetAllHistoryExceptions extends CloudStorageExceptions {}

// dont see any use cases for update

class CouldNotDeleteHistoryExceptions extends CloudStorageExceptions {}
