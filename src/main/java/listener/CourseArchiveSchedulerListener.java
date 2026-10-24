package listener;

import dao.CourseDao;
import dao.LessonDao;
import dao.LessonProgressDao;
import dao.ModuleDao;
import dao.RegistrationDao;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import service.CourseService;

/**
 * Worker nền chạy định kỳ mỗi phút khi Tomcat khởi động:
 * Tự động kiểm tra và chuyển trạng thái các khóa học đã hết hạn tuyển sinh (archive_at <= NOW()) sang ARCHIVED.
 */
@WebListener
public class CourseArchiveSchedulerListener implements ServletContextListener {
    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "CourseArchiveWorker");
            t.setDaemon(true);
            return t;
        });

        CourseService courseService = new CourseService(
                new CourseDao(), new ModuleDao(), new LessonDao(),
                new LessonProgressDao(), new RegistrationDao()
        );

        // Khởi động worker: Chạy lần đầu sau 10 giây, định kỳ mỗi 60 giây (1 phút)
        scheduler.scheduleAtFixedRate(() -> {
            try {
                int count = courseService.processScheduledArchives();
                if (count > 0) {
                    System.out.println("[CourseArchiveWorker] Đã tự động lưu trữ " + count + " khóa học hết hạn đăng ký.");
                }
            } catch (Exception e) {
                System.err.println("[CourseArchiveWorker] Lỗi xử lý quét khóa học hết hạn: " + e.getMessage());
            }
        }, 10, 60, TimeUnit.SECONDS);

        System.out.println("[CourseArchiveSchedulerListener] Worker quét lưu trữ khóa học đã được khởi tạo thành công (chu kỳ 60s).");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
            System.out.println("[CourseArchiveSchedulerListener] Worker quét lưu trữ khóa học đã dừng.");
        }
    }
}
