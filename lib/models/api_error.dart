class ApiError {
  final String errorType;
  final String description;

  ApiError({
    required this.errorType,
    required this.description,
  });

  ///Returns null if the response is not an error
  static fromJSON(Map<String, String> json) => json['description'] != null
      ? ApiError(
          description: json['description']!,
          errorType: json['errorType']!,
        )
      : null;
}
