package service;

public class InactiveAccountException extends IllegalStateException {

    private final String email;

    public InactiveAccountException(String message, String email) {
        super(message);
        this.email = email;
    }

    public String getEmail() {
        return email;
    }
}
