class ErrorModel {
  final int status;
  final String errorMessage;
  final Map<String, List<String>>? errors;

  ErrorModel({required this.status, required this.errorMessage, this.errors});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    Map<String, List<String>>? parsedErrors;
    if (jsonData['errors'] is Map) {
      parsedErrors = (jsonData['errors'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => e.toString()).toList(),
        ),
      );
    }

    final String message = parsedErrors != null && parsedErrors.isNotEmpty
        ? parsedErrors.values.first.first
        : jsonData['title']?.toString() ??
              jsonData['message']?.toString() ??
              'Unexpected error occurred';

    return ErrorModel(
      errorMessage: message,
      status: jsonData['status'] is int
          ? jsonData['status']
          : int.tryParse(jsonData['status']?.toString() ?? '') ?? 500,
      errors: parsedErrors,
    );
  }
}
