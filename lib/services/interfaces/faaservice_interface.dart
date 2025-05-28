abstract interface class FaaServiceInterface {
  // Calls a function as a serverless function
  // Can throw a FunctionCallError if the function call fails
  Future<Map<String, dynamic>> callFunction(
    String functionName,
    Map<String, dynamic> payload,
  );
}

class FunctionCallError implements Exception {
  final String message;
  FunctionCallError(this.message);
}
