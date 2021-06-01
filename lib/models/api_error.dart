class ApiError {
  final String errorType;
  final String description;

  ApiError({
    required this.errorType,
    required this.description,
  });

  ///Returns null if the response is not an error
  static dynamic fromJSON(Map<String, String> json) => ApiError(
        description: json['description']!,
        errorType: json['error']!,
      );
}
