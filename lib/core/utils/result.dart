/// Result type for handling success/error states
/// Provides type-safe error handling without exceptions
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final String message;
  final Object? error;
  const Failure(this.message, [this.error]);
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T? get dataOrNull => switch (this) {
        Success(data: final data) => data,
        Failure() => null,
      };
  
  String? get errorMessage => switch (this) {
        Success() => null,
        Failure(message: final message) => message,
      };

  R when<R>({
    required R Function(T) success,
    required R Function(String, Object?) failure,
  }) {
    return switch (this) {
      Success(data: final data) => success(data),
      Failure(message: final message, error: final error) => failure(message, error),
    };
  }
}
