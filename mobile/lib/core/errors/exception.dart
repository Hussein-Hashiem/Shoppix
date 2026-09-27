class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'No internet connection'});
}


// try {
//   final result = await remoteDataSource.getData();
//   return Right(result);
// } on ServerException catch (e) {
//   return Left(ServerFailure(e.message));
// } on CacheException catch (e) {
//   return Left(CacheFailure(e.message));
// }