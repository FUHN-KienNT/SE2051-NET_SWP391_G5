import org.mindrot.jbcrypt.BCrypt;

public class Test {
    public static void main(String[] args) {
        String hash = "$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS";
        String[] tests = {"123456", "12345678", "admin123", "admin", "password", "123", "123456789", "courson", "1234"};
        for (String t : tests) {
            if (BCrypt.checkpw(t, hash)) {
                System.out.println("MATCH FOUND: " + t);
                return;
            }
        }
        System.out.println("NO MATCH FOUND");
    }
}
