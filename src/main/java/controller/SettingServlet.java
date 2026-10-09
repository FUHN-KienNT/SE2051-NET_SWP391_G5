package controller;

import dao.SettingDao;
import dto.SettingDto;
import entity.enums.SettingStatus;
import entity.enums.SettingType;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import service.SettingService;

@WebServlet(name = "SettingServlet", urlPatterns = {"/settings/*"})
public class SettingServlet extends HttpServlet {
    private SettingService settingService;

    @Override
    public void init() throws ServletException {
        this.settingService = new SettingService(new SettingDao());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "list";
        processAction(action, req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "save";
        processAction(action, req, resp);
    }

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        switch (action) {
            case "list":
                showList(req, resp);
                break;
            case "detail":
                showDetail(req, resp);
                break;
            case "save":
                saveSetting(req, resp);
                break;
            case "delete":
                deleteSetting(req, resp);
                break;
            case "toggle-status":
                toggleStatus(req, resp);
                break;
            default:
                showList(req, resp);
                break;
        }
    }

    private void toggleStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                long id = Long.parseLong(idStr.trim());
                SettingDto setting = settingService.getSetting(id);
                SettingStatus newStatus = setting.getStatus() == SettingStatus.ACTIVE ? SettingStatus.INACTIVE : SettingStatus.ACTIVE;
                settingService.updateStatus(id, newStatus);
                resp.sendRedirect(req.getContextPath() + "/settings/list?success=status_updated");
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/settings/list?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/settings/list");
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getParameter("type");
        if (type == null) type = "ALL";
        
        String status = req.getParameter("status");
        if (status == null) status = "ALL";
        
        String keyword = req.getParameter("keyword");
        if (keyword == null) keyword = "";
        
        String sortBy = req.getParameter("sortBy");
        if (sortBy == null || sortBy.trim().isEmpty()) {
            sortBy = "id";
        }
        
        String sortOrder = req.getParameter("sortOrder");
        if (sortOrder == null || sortOrder.trim().isEmpty()) {
            sortOrder = "asc";
        }

        try {
            List<SettingDto> list = settingService.search(type, status, keyword, sortBy, sortOrder);
            req.setAttribute("settings", list);
        } catch (Exception e) {
            req.setAttribute("settings", new java.util.ArrayList<>());
            req.setAttribute("error", "Đã xảy ra lỗi khi tải danh sách: " + e.getMessage());
        }

        req.setAttribute("currentType", type);
        req.setAttribute("currentStatus", status);
        req.setAttribute("currentKeyword", keyword);
        req.setAttribute("currentSortBy", sortBy);
        req.setAttribute("currentSortOrder", sortOrder);

        req.getRequestDispatcher("/WEB-INF/views/setting/list.jsp").forward(req, resp);
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            long id = Long.parseLong(idStr.trim());
            SettingDto setting = settingService.getSetting(id);
            req.setAttribute("setting", setting);
        }
        req.getRequestDispatcher("/WEB-INF/views/setting/detail.jsp").forward(req, resp);
    }

    private void saveSetting(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            SettingDto dto = bindSetting(req);
            settingService.saveSetting(dto);
            resp.sendRedirect(req.getContextPath() + "/settings/list?type=" + dto.getType().name() + "&success=true");
        } catch (Exception e) {
            String idStr = req.getParameter("id");
            String redirectUrl = req.getContextPath() + "/settings/detail" + (idStr != null && !idStr.isEmpty() ? "?id=" + idStr + "&" : "?") + "error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8");
            resp.sendRedirect(redirectUrl);
        }
    }

    private void deleteSetting(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                long id = Long.parseLong(idStr.trim());
                settingService.deleteSetting(id);
                resp.sendRedirect(req.getContextPath() + "/settings/list?deleted=true");
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/settings/list?error=" + e.getMessage());
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/settings/list");
    }

    private SettingDto bindSetting(HttpServletRequest req) {
        SettingDto dto = new SettingDto();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            dto.setId(Long.parseLong(idStr.trim()));
        }
        dto.setType(SettingType.fromDb(req.getParameter("type")));
        dto.setName(req.getParameter("name"));
        dto.setValue(req.getParameter("value"));
        String priorityStr = req.getParameter("priority");
        dto.setPriority(priorityStr != null && !priorityStr.trim().isEmpty() ? Integer.parseInt(priorityStr.trim()) : 0);
        String statusStr = req.getParameter("status");
        dto.setStatus(statusStr != null ? SettingStatus.fromDb(statusStr) : SettingStatus.ACTIVE);
        dto.setDescription(req.getParameter("description"));
        return dto;
    }
}
