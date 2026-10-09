package controller;

import dao.CourseDao;
import dao.RegistrationDao;
import dto.RegistrationDto;
import dto.UserDto;
import entity.enums.PaymentStatus;
import entity.enums.RegistrationStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.OffsetDateTime;
import java.util.List;
import service.RegistrationService;
import util.SessionUtil;

@WebServlet(name = "RegistrationServlet", urlPatterns = {"/registrations/*"})
public class RegistrationServlet extends HttpServlet {
    private RegistrationService registrationService;

    @Override
    public void init() throws ServletException {
        this.registrationService = new RegistrationService(new RegistrationDao(), new CourseDao());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "my";
        processAction(action, req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "enroll";
        processAction(action, req, resp);
    }

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        switch (action) {
            case "checkout":
                showCheckout(req, resp);
                break;
            case "payment":
                showPayment(req, resp);
                break;
            case "confirm-payment":
                confirmPayment(req, resp);
                break;
            case "my":
                showMyRegistrations(req, resp);
                break;
            case "course":
                showCourseRegistrations(req, resp);
                break;
            case "enroll":
                enroll(req, resp);
                break;
            case "cancel":
                cancel(req, resp);
                break;
            case "payment-return":
                paymentReturn(req, resp);
                break;
            case "payment-callback":
                paymentCallback(req, resp);
                break;
            case "update-status":
                updateRegistrationStatus(req, resp);
                break;
            default:
                showMyRegistrations(req, resp);
                break;
        }
    }

    private void showCheckout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr != null) {
            long courseId = Long.parseLong(courseIdStr);
            try (java.sql.Connection con = util.DbConnection.getConnection()) {
                new CourseDao().findById(con, courseId).ifPresent(c -> req.setAttribute("course", c));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        req.getRequestDispatcher("/WEB-INF/views/registration/checkout.jsp").forward(req, resp);
    }

    private void showPayment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr != null) {
            long courseId = Long.parseLong(courseIdStr);
            try (java.sql.Connection con = util.DbConnection.getConnection()) {
                new CourseDao().findById(con, courseId).ifPresent(c -> req.setAttribute("course", c));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        req.setAttribute("paymentCode", "CR" + System.currentTimeMillis() % 1000000);
        req.getRequestDispatcher("/WEB-INF/views/registration/payment.jsp").forward(req, resp);
    }

    private void confirmPayment(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr != null) {
            long courseId = Long.parseLong(courseIdStr);
            RegistrationDto reg = registrationService.enroll(currentUser.getId(), courseId);
            registrationService.updatePayment(reg.getId(), PaymentStatus.SUCCESS, "PAY-" + System.currentTimeMillis(), OffsetDateTime.now());
        }
        resp.sendRedirect(req.getContextPath() + "/registrations/my?success=true");
    }

    private void showMyRegistrations(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        List<RegistrationDto> list = registrationService.getByUser(currentUser.getId());
        req.setAttribute("registrations", list);
        req.getRequestDispatcher("/WEB-INF/views/registration/my.jsp").forward(req, resp);
    }

    private void showCourseRegistrations(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr != null) {
            long courseId = Long.parseLong(courseIdStr);
            List<RegistrationDto> list = registrationService.getByCourse(courseId);
            req.setAttribute("registrations", list);
        }
        req.getRequestDispatcher("/WEB-INF/views/registration/course.jsp").forward(req, resp);
    }

    private void enroll(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr != null) {
            long courseId = Long.parseLong(courseIdStr);
            RegistrationDto reg = registrationService.enroll(currentUser.getId(), courseId);
            if (reg.getStatus() == RegistrationStatus.ACTIVE) {
                resp.sendRedirect(req.getContextPath() + "/courses/learn?registrationId=" + reg.getId());
                return;
            } else {
                resp.sendRedirect(req.getContextPath() + "/registrations/my?pendingId=" + reg.getId());
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/courses/catalog");
    }

    private void cancel(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                registrationService.cancel(Long.parseLong(idStr), currentUser.getId());
            } catch (SecurityException e) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/registrations/my");
    }

    private void paymentReturn(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String regIdStr = req.getParameter("registrationId");
        String statusStr = req.getParameter("status");
        if (regIdStr != null) {
            long regId = Long.parseLong(regIdStr);
            PaymentStatus pStatus = "SUCCESS".equalsIgnoreCase(statusStr) ? PaymentStatus.SUCCESS : PaymentStatus.FAILED;
            registrationService.updatePayment(regId, pStatus, req.getParameter("transactionNo"), OffsetDateTime.now());
        }
        resp.sendRedirect(req.getContextPath() + "/registrations/my");
    }

    private void paymentCallback(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String regIdStr = req.getParameter("registrationId");
        String statusStr = req.getParameter("status");
        if (regIdStr != null) {
            long regId = Long.parseLong(regIdStr);
            PaymentStatus pStatus = "SUCCESS".equalsIgnoreCase(statusStr) ? PaymentStatus.SUCCESS : PaymentStatus.FAILED;
            registrationService.updatePayment(regId, pStatus, req.getParameter("transactionNo"), OffsetDateTime.now());
            resp.getWriter().write("OK");
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing registrationId");
        }
    }

    private void updateRegistrationStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String statusStr = req.getParameter("status");
        if (idStr != null && statusStr != null) {
            long regId = Long.parseLong(idStr);
            PaymentStatus pStatus = PaymentStatus.fromDb(statusStr);
            registrationService.updatePayment(regId, pStatus, "MANUAL-" + System.currentTimeMillis(), OffsetDateTime.now());
        }
        resp.sendRedirect(req.getContextPath() + "/registrations/course");
    }
}
