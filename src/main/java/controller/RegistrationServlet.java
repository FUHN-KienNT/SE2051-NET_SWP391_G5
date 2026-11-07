package controller;

import dao.CourseDao;
import entity.Course;
import dao.RegistrationDao;
import dto.CourseDto;
import dto.RecentLearningDto;
import dto.StudentAiRecommendationDto;
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
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import service.RegistrationService;
import util.SessionUtil;
import util.VnPayUtil;
import util.VnPayUtil.VnPayVerifyResult;

@WebServlet(name = "RegistrationServlet", urlPatterns = { "/registrations/*" })
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
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "my";
        processAction(action, req, resp);
    }

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        switch (action) {
            case "checkout":
                if ("POST".equalsIgnoreCase(req.getMethod())) {
                    processCheckout(req, resp);
                } else {
                    showCheckout(req, resp);
                }
                break;
            case "payment":
                showPayment(req, resp);
                break;
            case "vnpay-create":
            case "pay-vnpay":
                createVnPayPayment(req, resp);
                break;

            case "my":
            case "my-courses":
            case "history":
                showMyRegistrations(req, resp);
                break;
            case "course":
            case "list":
                showCourseRegistrations(req, resp);
                break;
            case "detail":
                showRegistrationDetail(req, resp);
                break;
            case "enroll":
                String enrollCourseId = req.getParameter("courseId");
                if (enrollCourseId != null && !enrollCourseId.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/registrations/checkout?courseId=" + enrollCourseId.trim());
                } else {
                    resp.sendRedirect(req.getContextPath() + "/courses/catalog");
                }
                break;
            case "cancel":
                cancel(req, resp);
                break;
            case "vnpay-return":
            case "payment-return":
                paymentReturn(req, resp);
                break;
            case "vnpay-ipn":
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
        String flashErr = SessionUtil.popFlashError(req);
        if (flashErr != null) {
            req.setAttribute("errorMessage", flashErr);
        }
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            String regIdStr = req.getParameter("id");
            if (regIdStr == null || regIdStr.trim().isEmpty()) {
                regIdStr = req.getParameter("registrationId");
            }
            if (regIdStr != null && !regIdStr.trim().isEmpty()) {
                try {
                    long regId = Long.parseLong(regIdStr.trim());
                    RegistrationDto reg = registrationService.getById(regId);
                    if (reg != null) {
                        courseIdStr = String.valueOf(reg.getCourseId());
                    }
                } catch (Exception ignored) {}
            }
        }
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            SessionUtil.setFlashError(req, "Vui lòng chọn khóa học để thanh toán.");
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        }
        try {
            long courseId = Long.parseLong(courseIdStr.trim());
            if (registrationService.hasCourseAccess(currentUser.getId(), courseId)) {
                SessionUtil.setFlashSuccess(req, "Bạn đã đăng ký và sở hữu khóa học này rồi!");
                resp.sendRedirect(req.getContextPath() + "/courses/detail?id=" + courseId);
                return;
            }
            try (java.sql.Connection con = util.DbConnection.getConnection()) {
                new CourseDao().findById(con, courseId).ifPresent(c -> req.setAttribute("course", c));
            }
        } catch (NumberFormatException e) {
            SessionUtil.setFlashError(req, "Mã khóa học không hợp lệ: " + courseIdStr);
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (req.getAttribute("course") == null) {
            SessionUtil.setFlashError(req, "Không tìm thấy khóa học yêu cầu hoặc khóa học không tồn tại.");
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/registration/checkout.jsp").forward(req, resp);
    }

    private void processCheckout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            SessionUtil.setFlashError(req, "Vui lòng chọn khóa học để đăng ký.");
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        }
        try {
            long courseId = Long.parseLong(courseIdStr.trim());
            Course course = null;
            try (java.sql.Connection con = util.DbConnection.getConnection()) {
                course = new CourseDao().findById(con, courseId).orElse(null);
            }
            if (course == null) {
                SessionUtil.setFlashError(req, "Khóa học không tồn tại.");
                resp.sendRedirect(req.getContextPath() + "/courses/catalog");
                return;
            }

            String certName = req.getParameter("certificateName");
            if (certName == null || certName.trim().isEmpty()) {
                certName = currentUser.getFullName();
            }
            String phone = req.getParameter("studentPhone");
            String requestVat = req.getParameter("requestVat");
            String vatCompany = req.getParameter("vatCompany");
            String vatTaxCode = req.getParameter("vatTaxCode");
            String vatAddress = req.getParameter("vatAddress");

            BigDecimal finalPrice = course.getPrice() != null ? course.getPrice() : BigDecimal.ZERO;

            Map<String, Object> checkoutData = new HashMap<>();
            checkoutData.put("certName", certName.trim());
            checkoutData.put("phone", phone != null ? phone.trim() : "");
            checkoutData.put("finalPrice", finalPrice);
            checkoutData.put("requestVat", "on".equalsIgnoreCase(requestVat) || "true".equalsIgnoreCase(requestVat));
            checkoutData.put("vatCompany", vatCompany != null ? vatCompany.trim() : "");
            checkoutData.put("vatTaxCode", vatTaxCode != null ? vatTaxCode.trim() : "");
            checkoutData.put("vatAddress", vatAddress != null ? vatAddress.trim() : "");
            req.getSession().setAttribute("CHECKOUT_" + courseId, checkoutData);

            RegistrationDto reg = registrationService.enroll(currentUser.getId(), courseId, finalPrice);

            if (finalPrice.compareTo(BigDecimal.ZERO) <= 0 || reg.getStatus() == RegistrationStatus.ACTIVE) {
                SessionUtil.setFlashSuccess(req, "Đăng ký khóa học miễn phí thành công! Chào mừng bạn bắt đầu học tập.");
                resp.sendRedirect(req.getContextPath() + "/courses/learn?courseId=" + courseId);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/registrations/payment?courseId=" + courseId);
        } catch (Exception e) {
            SessionUtil.setFlashError(req, "Lỗi xử lý xác nhận đơn hàng: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/registrations/checkout?courseId=" + courseIdStr);
        }
    }

    private void showPayment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            String regIdStr = req.getParameter("id");
            if (regIdStr == null || regIdStr.trim().isEmpty()) {
                regIdStr = req.getParameter("registrationId");
            }
            if (regIdStr != null && !regIdStr.trim().isEmpty()) {
                try {
                    long regId = Long.parseLong(regIdStr.trim());
                    RegistrationDto reg = registrationService.getById(regId);
                    if (reg != null) {
                        courseIdStr = String.valueOf(reg.getCourseId());
                    }
                } catch (Exception ignored) {}
            }
        }
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            SessionUtil.setFlashError(req, "Vui lòng chọn khóa học để thanh toán.");
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        }
        try {
            long courseId = Long.parseLong(courseIdStr.trim());
            if (registrationService.hasCourseAccess(currentUser.getId(), courseId)) {
                SessionUtil.setFlashSuccess(req, "Bạn đã đăng ký và sở hữu khóa học này rồi!");
                resp.sendRedirect(req.getContextPath() + "/courses/detail?id=" + courseId);
                return;
            }
            Course course = null;
            try (java.sql.Connection con = util.DbConnection.getConnection()) {
                course = new CourseDao().findById(con, courseId).orElse(null);
            }
            if (course != null) {
                req.setAttribute("course", course);

                RegistrationDto pendingReg = null;
                List<RegistrationDto> myRegs = registrationService.getByUser(currentUser.getId());
                for (RegistrationDto r : myRegs) {
                    if (r.getCourseId() == courseId && r.getStatus() == RegistrationStatus.PENDING) {
                        pendingReg = r;
                        break;
                    }
                }

                @SuppressWarnings("unchecked")
                Map<String, Object> checkoutData = (Map<String, Object>) req.getSession().getAttribute("CHECKOUT_" + courseId);

                String certName = checkoutData != null && checkoutData.get("certName") != null ? (String) checkoutData.get("certName") : currentUser.getFullName();
                String phone = checkoutData != null && checkoutData.get("phone") != null ? (String) checkoutData.get("phone") : (currentUser.getPhone() != null ? currentUser.getPhone() : "");
                BigDecimal finalAmount = course.getPrice() != null ? course.getPrice() : BigDecimal.ZERO;
                if (pendingReg != null && pendingReg.getPaymentAmount() != null) {
                    finalAmount = pendingReg.getPaymentAmount();
                } else if (checkoutData != null && checkoutData.get("finalPrice") != null) {
                    finalAmount = (BigDecimal) checkoutData.get("finalPrice");
                }

                req.setAttribute("registration", pendingReg);
                req.setAttribute("certName", certName);
                req.setAttribute("phone", phone);
                req.setAttribute("finalAmount", finalAmount);
                req.setAttribute("paymentCode", pendingReg != null && pendingReg.getPaymentCode() != null ? pendingReg.getPaymentCode() : ("CR" + System.currentTimeMillis() % 1000000));
            }
        } catch (NumberFormatException e) {
            SessionUtil.setFlashError(req, "Mã khóa học không hợp lệ: " + courseIdStr);
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (req.getAttribute("course") == null) {
            SessionUtil.setFlashError(req, "Không tìm thấy khóa học yêu cầu hoặc khóa học không tồn tại.");
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/registration/payment.jsp").forward(req, resp);
    }

    /**
     * Khởi tạo giao dịch thanh toán qua VNPay và chuyển hướng tới cổng thanh toán VNPay Sandbox
     */
    private void createVnPayPayment(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String courseIdStr = req.getParameter("courseId");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        }

        try {
            long courseId = Long.parseLong(courseIdStr.trim());
            BigDecimal finalPrice = null;
            Object checkoutObj = req.getSession().getAttribute("CHECKOUT_" + courseId);
            if (checkoutObj instanceof Map) {
                @SuppressWarnings("unchecked")
                Map<String, Object> map = (Map<String, Object>) checkoutObj;
                finalPrice = (BigDecimal) map.get("finalPrice");
            }
            if (finalPrice == null) {
                List<RegistrationDto> myRegs = registrationService.getByUser(currentUser.getId());
                for (RegistrationDto r : myRegs) {
                    if (r.getCourseId() == courseId && r.getStatus() == RegistrationStatus.PENDING) {
                        finalPrice = r.getPaymentAmount();
                        break;
                    }
                }
            }
            RegistrationDto reg = registrationService.enroll(currentUser.getId(), courseId, finalPrice);

            // Nếu khóa học miễn phí hoặc đã được kích hoạt thành công từ trước
            if (reg.getStatus() == RegistrationStatus.ACTIVE) {
                SessionUtil.setFlashSuccess(req, "Khóa học đã được kích hoạt thành công!");
                resp.sendRedirect(req.getContextPath() + "/courses/learn?registrationId=" + reg.getId());
                return;
            }

            // Tạo link thanh toán VNPay (mặc định chuyển thẳng đến cổng Ngân hàng NCB theo yêu cầu)
            String bankCode = req.getParameter("bankCode");
            if (bankCode == null || bankCode.trim().isEmpty()) {
                bankCode = "NCB";
            } else if ("ALL".equalsIgnoreCase(bankCode.trim())) {
                bankCode = null;
            }

            String orderInfo = "Thanh toan khoa hoc #" + reg.getCourseId() + " Ma don #" + reg.getId();
            String vnpayUrl = VnPayUtil.createPaymentUrl(req, reg.getId(), reg.getPaymentAmount(), orderInfo, bankCode);

            resp.sendRedirect(vnpayUrl);
        } catch (Exception e) {
            SessionUtil.setFlashError(req, "Không thể khởi tạo cổng thanh toán VNPay: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/registrations/payment?courseId=" + courseIdStr);
        }
    }

    // #m_tiendo [TRẠM 1/4 - CONTROLLER]: Lấy danh sách đăng ký bằng getByUser() và lấy bài học gần nhất bằng getRecentLearning()
    private void showMyRegistrations(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String flashError = SessionUtil.popFlashError(req);
        if (flashError != null) {
            req.setAttribute("errorMessage", flashError);
        }
        String flashSuccess = SessionUtil.popFlashSuccess(req);
        if (flashSuccess != null) {
            req.setAttribute("successMessage", flashSuccess);
        }

        List<RegistrationDto> list = registrationService.getByUser(currentUser.getId());

        int totalCourses = list.size();
        int inProgressCourses = 0;
        int completedCourses = 0;
        int pendingCourses = 0;
        int totalCompletedLessons = 0;
        BigDecimal sumProgress = BigDecimal.ZERO;
        Set<String> categories = new LinkedHashSet<>();

        for (RegistrationDto r : list) {
            if (r.getCategoryName() != null && !r.getCategoryName().trim().isEmpty()) {
                categories.add(r.getCategoryName().trim());
            }
            if (r.getCourseStatus() == entity.enums.CourseStatus.DRAFT) {
                // Khóa học đang tạm khóa bảo trì / soạn nháp
            } else if (r.getStatus() == RegistrationStatus.PENDING) {
                pendingCourses++;
            } else if (r.getStatus() == RegistrationStatus.COMPLETED
                    || (r.getTotalLessons() > 0 && r.getCompletedLessons() >= r.getTotalLessons())) {
                completedCourses++;
            } else if (r.getStatus() == RegistrationStatus.ACTIVE) {
                inProgressCourses++;
            }

            if (r.getCompletedLessons() > 0) {
                totalCompletedLessons += r.getCompletedLessons();
            }
            if (r.getProgressPercentage() != null) {
                sumProgress = sumProgress.add(r.getProgressPercentage());
            }
        }

        BigDecimal avgProgress = BigDecimal.ZERO;
        if (totalCourses > 0) {
            avgProgress = sumProgress.divide(BigDecimal.valueOf(totalCourses), 1, java.math.RoundingMode.HALF_UP);
        }

        RecentLearningDto recentLearning = registrationService.getRecentLearning(currentUser.getId());
        StudentAiRecommendationDto aiRecommendation = registrationService.getStudentAiRecommendations(currentUser.getId(), list);

        req.setAttribute("registrations", list);
        req.setAttribute("recentLearning", recentLearning);
        req.setAttribute("aiRecommendation", aiRecommendation);
        req.setAttribute("totalCourses", totalCourses);
        req.setAttribute("inProgressCourses", inProgressCourses);
        req.setAttribute("completedCourses", completedCourses);
        req.setAttribute("pendingCourses", pendingCourses);
        req.setAttribute("avgProgress", avgProgress);
        req.setAttribute("totalCompletedLessons", totalCompletedLessons);
        req.setAttribute("categories", categories);

        req.getRequestDispatcher("/WEB-INF/views/registration/my.jsp").forward(req, resp);
    }

    private void showCourseRegistrations(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String courseIdStr = req.getParameter("courseId");
        String search = req.getParameter("search");
        String paymentStatus = req.getParameter("paymentStatus");
        String status = req.getParameter("status");

        List<RegistrationDto> rawList;
        CourseDto course = null;

        try {
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                long courseId = Long.parseLong(courseIdStr.trim());
                if (!registrationService.canViewCourseRegistrations(courseId, currentUser)) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem danh sách đăng ký của khóa học này.");
                    return;
                }
                course = registrationService.getCourseSummary(courseId);
                rawList = registrationService.getByCourse(courseId);
            } else {
                if (!"MANAGER".equalsIgnoreCase(currentUser.getRoleName()) && !"ADMIN".equalsIgnoreCase(currentUser.getRoleName())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem danh sách đăng ký.");
                    return;
                }
                rawList = registrationService.getAll();
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã khóa học không hợp lệ.");
            return;
        }

        List<RegistrationDto> filteredList = new java.util.ArrayList<>();
        String searchTrim = (search != null) ? search.trim().toLowerCase() : null;
        for (RegistrationDto r : rawList) {
            if (searchTrim != null && !searchTrim.isEmpty()) {
                boolean matchId = String.valueOf(r.getId()).equals(searchTrim);
                boolean matchUser = r.getUserName() != null && r.getUserName().toLowerCase().contains(searchTrim);
                boolean matchCourse = r.getCourseTitle() != null && r.getCourseTitle().toLowerCase().contains(searchTrim);
                boolean matchCode = r.getPaymentCode() != null && r.getPaymentCode().toLowerCase().contains(searchTrim);
                if (!matchId && !matchUser && !matchCourse && !matchCode) {
                    continue;
                }
            }
            if (paymentStatus != null && !paymentStatus.trim().isEmpty()) {
                if (r.getPaymentStatus() == null || !r.getPaymentStatus().name().equalsIgnoreCase(paymentStatus.trim())) {
                    continue;
                }
            }
            if (status != null && !status.trim().isEmpty()) {
                if (r.getStatus() == null || !r.getStatus().name().equalsIgnoreCase(status.trim())) {
                    continue;
                }
            }
            filteredList.add(r);
        }

        req.setAttribute("course", course);
        req.setAttribute("registrations", filteredList);
        req.setAttribute("courseList", registrationService.getCoursesForManager(currentUser));
        req.getRequestDispatcher("/WEB-INF/views/registration/course.jsp").forward(req, resp);
    }

    private void showRegistrationDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã đăng ký.");
            return;
        }
        try {
            RegistrationDto registration = registrationService.getById(Long.parseLong(idStr));
            if (registration == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đăng ký.");
                return;
            }
            if (!registrationService.canViewRegistration(registration, currentUser)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem đăng ký này.");
                return;
            }
            req.setAttribute("registration", registration);
            req.getRequestDispatcher("/WEB-INF/views/registration/detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đăng ký không hợp lệ.");
        }
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


    private enum VnPayProcessStatus {
        SUCCESS,
        ALREADY_CONFIRMED,
        INVALID_SIGNATURE,
        ORDER_NOT_FOUND,
        INVALID_AMOUNT,
        FAILED
    }

    private static class VnPayValidationResult {
        final VnPayProcessStatus status;
        final RegistrationDto registration;
        final VnPayVerifyResult verifyResult;
        final String message;

        VnPayValidationResult(VnPayProcessStatus status, RegistrationDto registration, VnPayVerifyResult verifyResult, String message) {
            this.status = status;
            this.registration = registration;
            this.verifyResult = verifyResult;
            this.message = message;
        }
    }

    /**
     * Xác thực và đối soát đồng nhất 100% giữa Return URL (Browser) và IPN Webhook (Server-to-Server)
     */
    private VnPayValidationResult validateAndProcessVnPay(Map<String, String[]> parameterMap) {
        VnPayVerifyResult result = VnPayUtil.verifyPayment(parameterMap);

        if (!result.isValidSignature()) {
            return new VnPayValidationResult(VnPayProcessStatus.INVALID_SIGNATURE, null, result, "Chữ ký bảo mật không hợp lệ từ VNPay (Invalid Checksum).");
        }

        long regId = result.getRegistrationId();
        if (regId <= 0) {
            return new VnPayValidationResult(VnPayProcessStatus.ORDER_NOT_FOUND, null, result, "Không tìm thấy mã đơn đăng ký từ phản hồi VNPay.");
        }

        RegistrationDto reg = registrationService.getById(regId);
        if (reg == null) {
            return new VnPayValidationResult(VnPayProcessStatus.ORDER_NOT_FOUND, null, result, "Không tìm thấy thông tin đơn đăng ký #" + regId);
        }

        // 1. Kiểm tra số tiền thanh toán (Amount Verification) - Đồng nhất cả IPN lẫn Return URL
        if (result.getAmount() != null && reg.getPaymentAmount() != null) {
            if (result.getAmount().compareTo(reg.getPaymentAmount()) != 0) {
                return new VnPayValidationResult(VnPayProcessStatus.INVALID_AMOUNT, reg, result,
                        "Số tiền thanh toán (" + result.getAmount() + ") không khớp với giá trị đơn hàng (" + reg.getPaymentAmount() + ").");
            }
        }

        // 2. Kiểm tra Idempotent: Đơn hàng đã thành công từ trước (do IPN hoặc Return xử lý trước)
        if (reg.getPaymentStatus() == PaymentStatus.SUCCESS || reg.getStatus() == RegistrationStatus.ACTIVE) {
            return new VnPayValidationResult(VnPayProcessStatus.ALREADY_CONFIRMED, reg, result, "Đơn hàng đã được xác nhận thanh toán thành công trước đó.");
        }

        // 3. Cập nhật kết quả giao dịch vào CSDL
        if (result.isSuccess()) {
            registrationService.updatePayment(regId, PaymentStatus.SUCCESS, result.getTransactionNo(), OffsetDateTime.now());
            return new VnPayValidationResult(VnPayProcessStatus.SUCCESS, reg, result, "Thanh toán VNPay thành công!");
        } else {
            registrationService.updatePayment(regId, PaymentStatus.FAILED, result.getTransactionNo(), OffsetDateTime.now());
            return new VnPayValidationResult(VnPayProcessStatus.FAILED, reg, result,
                    "Thanh toán VNPay không thành công: " + result.getMessage() + " (Mã: " + result.getResponseCode() + ").");
        }
    }

    /**
     * Xử lý kết quả trả về từ trình duyệt khách hàng sau khi thanh toán trên VNPay
     */
    private void paymentReturn(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        VnPayValidationResult val = validateAndProcessVnPay(req.getParameterMap());
        RegistrationDto reg = val.registration;

        // IDOR Defense / Ownership check: nếu học viên đang đăng nhập, kiểm tra có đúng đơn hàng của họ không
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser != null && reg != null && reg.getUserId() != currentUser.getId()) {
            SessionUtil.setFlashError(req, "Bạn không có quyền truy cập kết quả đơn đăng ký này.");
            resp.sendRedirect(req.getContextPath() + "/registrations/my");
            return;
        }

        switch (val.status) {
            case INVALID_SIGNATURE:
            case ORDER_NOT_FOUND:
                SessionUtil.setFlashError(req, val.message);
                resp.sendRedirect(req.getContextPath() + "/registrations/my");
                break;
            case INVALID_AMOUNT:
                SessionUtil.setFlashError(req, val.message);
                resp.sendRedirect(req.getContextPath() + (reg != null ? ("/registrations/payment?courseId=" + reg.getCourseId()) : "/registrations/my"));
                break;
            case ALREADY_CONFIRMED:
                SessionUtil.setFlashSuccess(req, "Đơn hàng của bạn đã được thanh toán thành công trước đó! Chúc bạn học tập hiệu quả.");
                resp.sendRedirect(req.getContextPath() + "/courses/learn?registrationId=" + reg.getId());
                break;
            case SUCCESS:
                SessionUtil.setFlashSuccess(req, "Thanh toán VNPay thành công! Bạn đã được kích hoạt khóa học \"" + (reg.getCourseTitle() != null ? reg.getCourseTitle() : "") + "\".");
                resp.sendRedirect(req.getContextPath() + "/courses/learn?registrationId=" + reg.getId());
                break;
            case FAILED:
                SessionUtil.setFlashError(req, val.message);
                resp.sendRedirect(req.getContextPath() + (reg != null ? ("/registrations/payment?courseId=" + reg.getCourseId()) : "/registrations/my"));
                break;
        }
    }

    /**
     * Webhook / IPN tiếp nhận thông báo kết quả thanh toán bất đồng bộ từ máy chủ VNPay
     */
    private void paymentCallback(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        VnPayValidationResult val = validateAndProcessVnPay(req.getParameterMap());

        switch (val.status) {
            case INVALID_SIGNATURE:
                resp.getWriter().write("{\"RspCode\":\"97\",\"Message\":\"Invalid Checksum\"}");
                break;
            case ORDER_NOT_FOUND:
                resp.getWriter().write("{\"RspCode\":\"01\",\"Message\":\"Order not found\"}");
                break;
            case INVALID_AMOUNT:
                resp.getWriter().write("{\"RspCode\":\"04\",\"Message\":\"Invalid Amount\"}");
                break;
            case ALREADY_CONFIRMED:
                resp.getWriter().write("{\"RspCode\":\"02\",\"Message\":\"Order already confirmed\"}");
                break;
            case SUCCESS:
            case FAILED:
                resp.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
                break;
        }
    }

    private void updateRegistrationStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null || (!"ADMIN".equalsIgnoreCase(currentUser.getRoleName()) && !"MANAGER".equalsIgnoreCase(currentUser.getRoleName()))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện thao tác này.");
            return;
        }
        String idStr = req.getParameter("id");
        String statusStr = req.getParameter("status");
        if (idStr != null && statusStr != null) {
            long regId = Long.parseLong(idStr);
            PaymentStatus pStatus = PaymentStatus.fromDb(statusStr);
            registrationService.updatePayment(regId, pStatus, "MANUAL-" + System.currentTimeMillis(),
                    OffsetDateTime.now());
        }
        resp.sendRedirect(req.getContextPath() + "/registrations/course");
    }
}
