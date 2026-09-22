package dto;

public class LoginDto {
    private String loginId;
    private String password;
    private boolean rememberMe;

    public LoginDto() {
    }

    public LoginDto(String loginId, String password, boolean rememberMe) {
        this.loginId = loginId;
        this.password = password;
        this.rememberMe = rememberMe;
    }

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isRememberMe() {
        return rememberMe;
    }

    public void setRememberMe(boolean rememberMe) {
        this.rememberMe = rememberMe;
    }
}
