package dto;

import java.util.Collections;
import java.util.List;

/**
 * DTO chứa kết quả gợi ý khóa học thông minh cho học viên:
 * - recommendedCourses: Danh sách khóa học được đề xuất (tối đa 3 khóa học)
 * - advice: Lời khuyên học tập từ Gemini AI (hoặc quy tắc thông minh dự phòng)
 * - aiPowered: true nếu được sinh ra trực tiếp từ Google Gemini AI, false nếu dùng quy tắc fallback
 */
public class StudentAiRecommendationDto {
    private final List<CourseDto> recommendedCourses;
    private final String advice;
    private final boolean aiPowered;

    public StudentAiRecommendationDto(List<CourseDto> recommendedCourses, String advice, boolean aiPowered) {
        this.recommendedCourses = (recommendedCourses != null) ? recommendedCourses : Collections.emptyList();
        this.advice = advice;
        this.aiPowered = aiPowered;
    }

    public List<CourseDto> getRecommendedCourses() {
        return recommendedCourses;
    }

    public String getAdvice() {
        return advice;
    }

    public boolean isAiPowered() {
        return aiPowered;
    }
}
