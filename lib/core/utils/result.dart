/// Classe générique Result<T> pour gérer succès et échecs de manière fonctionnelle.
/// Inspiré du pattern Either / Result de la Clean Architecture.
sealed class Result<T> {
  const Result();
}

/// Représente un succès avec une valeur de type T
final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Représente un échec avec un message d'erreur
final class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;
  const Failure(this.message, {this.exception});
}

/// Extensions utilitaires sur Result<T>
extension ResultExtension<T> on Result<T> {
  /// Vrai si succès
  bool get isSuccess => this is Success<T>;

  /// Vrai si échec
  bool get isFailure => this is Failure<T>;

  /// Retourne la valeur si succès, null sinon
  T? get dataOrNull => isSuccess ? (this as Success<T>).data : null;

  /// Retourne le message d'erreur si échec, null sinon
  String? get errorOrNull => isFailure ? (this as Failure<T>).message : null;

  /// Exécute [onSuccess] ou [onFailure] selon le résultat
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(String message) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      Failure<T>(:final message) => onFailure(message),
    };
  }
}
