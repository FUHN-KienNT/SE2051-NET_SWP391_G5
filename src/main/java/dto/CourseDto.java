package dto;

import entity.enums.CourseStatus;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CourseDto {
    private Long id;
    private String title;
    private Long categoryId;
    private String categoryName;
    private String description;
    private BigDecimal price;
    private CourseStatus status;
    private Long managerId;
    private Long expertId;
    private String managerName;
    private String expertName;
    private List<ModuleDto> modules = new ArrayList<>();

    public CourseDto() {
    }

    public CourseDto(Long id, String title, Long categoryId, String categoryName, String description,
                     BigDecimal price, CourseStatus status, String managerName, String expertName,
                     List<ModuleDto> modules) {
        this.id = id;
        this.title = title;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description;
        this.price = price;
        this.status = status;
        this.managerName = managerName;
        this.expertName = expertName;
        this.modules = modules != null ? modules : new ArrayList<>();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public CourseStatus getStatus() {
        return status;
    }

    public void setStatus(CourseStatus status) {
        this.status = status;
    }

    public Long getManagerId() {
        return managerId;
    }

    public void setManagerId(Long managerId) {
        this.managerId = managerId;
    }

    public Long getExpertId() {
        return expertId;
    }

    public void setExpertId(Long expertId) {
        this.expertId = expertId;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public String getExpertName() {
        return expertName;
    }

    public void setExpertName(String expertName) {
        this.expertName = expertName;
    }

    public List<ModuleDto> getModules() {
        return modules;
    }

    public void setModules(List<ModuleDto> modules) {
        this.modules = modules != null ? modules : new ArrayList<>();
    }

    public int getTotalLessons() {
        if (modules == null) return 0;
        int count = 0;
        for (ModuleDto m : modules) {
            if (m.getLessons() != null) {
                count += m.getLessons().size();
            }
        }
        return count;
    }

    public int getTotalQuizzes() {
        if (modules == null) return 0;
        int count = 0;
        for (ModuleDto m : modules) {
            if (m.getQuizzes() != null) {
                count += m.getQuizzes().size();
            }
        }
        return count;
    }

    public String getThumbnailUrl() {
        if (modules != null) {
            for (ModuleDto m : modules) {
                if (m.getLessons() != null) {
                    for (LessonDto l : m.getLessons()) {
                        String thumb = l.getThumbnailUrl();
                        if (thumb != null && !thumb.contains("unsplash")) {
                            // Replace mqdefault with hqdefault for crisp course cards
                            return thumb.replace("mqdefault.jpg", "hqdefault.jpg");
                        }
                    }
                }
            }
        }
        return "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=60";
    }
}
