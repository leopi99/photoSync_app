class ApiError {
  final String errorType;
  final String description;

  ApiError({
    required this.errorType,
    required this.description,
  });

  factory ApiError.fromJSON(Map<String, String> json) => ApiError(
        description: json['description']!,
        errorType: json['errorType']!,
      );
}
