package dto;

public class GoogleAuthResult {

    public enum Status {
        NEW_USER_CREATED,
        UNVERIFIED_ACTIVATED,
        EXISTING_USER
    }

    private final UserDto user;
    private final Status status;
    private final boolean hasPassword;

    public GoogleAuthResult(UserDto user, Status status) {
        this(user, status, true);
    }

    public GoogleAuthResult(UserDto user, Status status, boolean hasPassword) {
        this.user = user;
        this.status = status;
        this.hasPassword = hasPassword;
    }

    public UserDto getUser() {
        return user;
    }

    public Status getStatus() {
        return status;
    }

    public boolean hasPassword() {
        return hasPassword;
    }

    public boolean isHasPassword() {
        return hasPassword;
    }
}
