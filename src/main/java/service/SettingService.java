package service;

import dao.SettingDao;
import dto.SettingDto;
import entity.Setting;
import entity.enums.SettingStatus;
import entity.enums.SettingType;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import util.DbConnection;
import util.ValidationUtil;

public class SettingService {
    private final SettingDao settingDao;

    public SettingService(SettingDao settingDao) {
        this.settingDao = settingDao;
    }

    public List<SettingDto> getByType(SettingType type) {
        try (Connection con = DbConnection.getConnection()) {
            List<Setting> list = settingDao.findByType(con, type);
            List<SettingDto> dtoList = new ArrayList<>();
            for (Setting s : list) {
                dtoList.add(mapSetting(s));
            }
            return dtoList;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách cấu hình: " + e.getMessage(), e);
        }
    }

    public List<SettingDto> search(String type, String status, String keyword, String sortBy, String sortOrder) {
        try (Connection con = DbConnection.getConnection()) {
            List<Setting> list = settingDao.search(con, type, status, keyword, sortBy, sortOrder);
            List<SettingDto> dtoList = new ArrayList<>();
            for (Setting s : list) {
                dtoList.add(mapSetting(s));
            }
            return dtoList;
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi tìm kiếm cấu hình: " + e.getMessage(), e);
        }
    }

    public void updateStatus(long id, SettingStatus status) {
        try (Connection con = DbConnection.getConnection()) {
            boolean updated = settingDao.updateStatus(con, id, status);
            if (!updated) {
                throw new IllegalArgumentException("Không tìm thấy cấu hình cần cập nhật.");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi cập nhật trạng thái: " + e.getMessage(), e);
        }
    }

    public SettingDto getSetting(long id) {
        try (Connection con = DbConnection.getConnection()) {
            return settingDao.findById(con, id)
                    .map(this::mapSetting)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy cấu hình ID: " + id));
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi truy xuất cấu hình: " + e.getMessage(), e);
        }
    }

    public long saveSetting(SettingDto dto) {
        validateSetting(dto);
        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                long id;
                if (dto.getId() != null && dto.getId() > 0) {
                    Optional<Setting> existingOpt = settingDao.findById(con, dto.getId());
                    if (!existingOpt.isPresent()) {
                        throw new IllegalArgumentException("Không tìm thấy cấu hình cần cập nhật.");
                    }
                    Setting s = existingOpt.get();
                    s.setType(dto.getType());
                    s.setName(dto.getName().trim());
                    s.setValue(dto.getValue().trim());
                    s.setPriority(dto.getPriority());
                    s.setStatus(dto.getStatus() != null ? dto.getStatus() : SettingStatus.ACTIVE);
                    s.setDescription(dto.getDescription());
                    settingDao.update(con, s);
                    id = s.getId();
                } else {
                    Setting s = new Setting();
                    s.setType(dto.getType());
                    s.setName(dto.getName().trim());
                    s.setValue(dto.getValue().trim());
                    s.setPriority(dto.getPriority());
                    s.setStatus(dto.getStatus() != null ? dto.getStatus() : SettingStatus.ACTIVE);
                    s.setDescription(dto.getDescription());
                    id = settingDao.insert(con, s);
                }
                con.commit();
                return id;
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            if ("23503".equals(e.getSQLState())) {
                throw new RuntimeException("Không thể lưu cấu hình vì nó đang được sử dụng ở bảng khác (Khóa học/Người dùng). Vui lòng kiểm tra lại.");
            }
            throw new RuntimeException("Lỗi lưu cấu hình: " + e.getMessage(), e);
        }
    }

    public void deleteSetting(long id) {
        try (Connection con = DbConnection.getConnection()) {
            preventReferencedDelete(id);
            boolean deleted = settingDao.delete(con, id);
            if (!deleted) {
                throw new IllegalArgumentException("Không tìm thấy cấu hình cần xóa.");
            }
        } catch (SQLException e) {
            if ("23503".equals(e.getSQLState())) {
                throw new RuntimeException("Không thể xóa cấu hình vì nó đang được sử dụng ở bảng khác.");
            }
            throw new RuntimeException("Lỗi xóa cấu hình: " + e.getMessage(), e);
        }
    }

    private void validateSetting(SettingDto dto) {
        if (dto == null) {
            throw new IllegalArgumentException("Dữ liệu cấu hình trống.");
        }
        if (dto.getType() == null) {
            throw new IllegalArgumentException("Loại cấu hình không được để trống.");
        }
        ValidationUtil.requireText(dto.getName(), "Tên cấu hình");
        ValidationUtil.requireText(dto.getValue(), "Giá trị cấu hình");
    }

    private void preventReferencedDelete(long id) {
        try (Connection con = DbConnection.getConnection()) {
            // Check users referencing role
            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(1) FROM users WHERE role_id = ?")) {
                ps.setLong(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        throw new IllegalStateException("Không thể xóa cấu hình đang được liên kết với người dùng.");
                    }
                }
            }
            // Check courses referencing category
            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(1) FROM courses WHERE category_id = ?")) {
                ps.setLong(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        throw new IllegalStateException("Không thể xóa danh mục đang có khóa học.");
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi kiểm tra ràng buộc trước khi xóa: " + e.getMessage(), e);
        }
    }

    private SettingDto mapSetting(Setting entity) {
        if (entity == null) return null;
        SettingDto dto = new SettingDto();
        dto.setId(entity.getId());
        dto.setType(entity.getType());
        dto.setName(entity.getName());
        dto.setValue(entity.getValue());
        dto.setPriority(entity.getPriority());
        dto.setStatus(entity.getStatus());
        dto.setDescription(entity.getDescription());
        return dto;
    }
}
