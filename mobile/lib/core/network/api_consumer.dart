abstract interface class GetApiConsumer {
  Future<T> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });
}

abstract interface class PostApiConsumer {
  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  });
}

abstract interface class PatchApiConsumer {
  Future<T> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  });
}

abstract interface class DeleteApiConsumer {
  Future<T> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });
}

abstract interface class ApiConsumer
    implements
        GetApiConsumer,
        PostApiConsumer,
        PatchApiConsumer,
        DeleteApiConsumer {}
