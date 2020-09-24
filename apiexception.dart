class APIException implements Exception {
    String _message;

    APIException(String message) {
        this._message = message;
    }

    @override
    String toString() {
        return "APIException $_message";
    }
}