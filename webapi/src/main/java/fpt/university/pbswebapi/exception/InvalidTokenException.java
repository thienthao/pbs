package fpt.university.pbswebapi.exception;

public class InvalidTokenException extends Exception {

    public InvalidTokenException() {
        super();
    }


    public InvalidTokenException(String message) {
        super(message);
    }


    public InvalidTokenException(String message, Throwable cause) {
        super(message, cause);
    }
}
