import json

with open('database/playlists_data.json', 'r', encoding='utf-8') as f:
    courses = json.load(f)

sql_lines = []
sql_lines.append("BEGIN;")
sql_lines.append("")
sql_lines.append("-- 1. Tạo các danh mục khóa học nếu chưa có")
sql_lines.append("""INSERT INTO settings (type, name, value, priority, status, description) VALUES
    ('COURSE_CATEGORY', 'Nhân tướng học & Nhân trắc học', 'PHYSIOGNOMY', 4, 'ACTIVE', 'Kiến thức nhân tướng học, diện mạo và nhân trắc học ứng dụng'),
    ('COURSE_CATEGORY', 'Tử Vi & Phong Thủy', 'TU_VI', 5, 'ACTIVE', 'Nghiên cứu lá số Tử Vi, âm dương ngũ hành và giải đoán vận hạn'),
    ('COURSE_CATEGORY', 'Chiêm Tinh & Cung Hoàng Đạo', 'ASTROLOGY', 6, 'ACTIVE', 'Khám phá bí mật 12 cung hoàng đạo và chiêm tinh học ứng dụng')
ON CONFLICT (type, name) DO NOTHING;
""")

sql_lines.append("-- Xóa sạch registrations, quiz_answers, quiz_attempts, lesson_progress liên quan")
sql_lines.append("""DELETE FROM quiz_answers;
DELETE FROM quiz_attempts;
DELETE FROM lesson_progress;
DELETE FROM registrations;
DELETE FROM courses WHERE id IN (1, 2, 3) OR title IN (
    'Nhân Tướng Học Ứng Dụng - Thầy Viên Minh',
    '[TVK6] Nhập Môn Tử Vi Đẩu Số & Học Thuyết Ngũ Hành',
    'Bí Mật Tính Cách 12 Cung Hoàng Đạo'
);
""")

course_id_counter = 1
module_id_counter = 1
lesson_id_counter = 1
quiz_id_counter = 1
question_id_counter = 1
answer_id_counter = 1
quiz_q_counter = 1

for c in courses:
    cid = course_id_counter
    course_id_counter += 1
    title = c['title'].replace("'", "''")
    desc = c['description'].replace("'", "''")
    cat_val = c['categoryValue']
    videos = c['videos']
    
    sql_lines.append(f"-- =====================================================================")
    sql_lines.append(f"-- KHÓA HỌC {cid}: {title} ({len(videos)} bài giảng)")
    sql_lines.append(f"-- =====================================================================")
    sql_lines.append(f"""INSERT INTO courses (id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at)
VALUES (
    {cid},
    '{title}',
    (SELECT id FROM settings WHERE type = 'COURSE_CATEGORY' AND value = '{cat_val}' LIMIT 1),
    'COURSE_CATEGORY',
    '{desc}',
    0,
    'PUBLISHED',
    2,
    3,
    now(),
    now()
);""")

    # Chia video thành các module hợp lý (khoảng 8-15 video mỗi module)
    chunk_size = 8 if len(videos) <= 20 else (10 if len(videos) <= 40 else 13)
    module_chunks = [videos[i:i + chunk_size] for i in range(0, len(videos), chunk_size)]
    
    for m_idx, chunk in enumerate(module_chunks, 1):
        mid = module_id_counter
        module_id_counter += 1
        
        if cid == 1:
            m_titles = ["Căn Bản Nhân Tướng & Tam Đình Ngũ Nhạc", "Giải Mã Ngũ Quan & Diện Mạo", "Khí Sắc, Tâm Tướng & Ứng Dụng Đời Sống"]
            m_title = m_titles[m_idx - 1] if m_idx <= len(m_titles) else f"Chuyên đề nâng cao phần {m_idx}"
        elif cid == 2:
            m_titles = ["Nhập Môn Lá Số Tử Vi & Học Thuyết Ngũ Hành", "Hệ Thống 12 Cung & Can Chi Bản Mệnh", "Luận Giải Chính Tinh & Phụ Tinh", "Kỹ Thuật Luận Đoán & Workshop Chuyên Sâu"]
            m_title = m_titles[m_idx - 1] if m_idx <= len(m_titles) else f"Chuyên đề nâng cao phần {m_idx}"
        else:
            m_titles = ["Truyền Thuyết & Bản Chất 12 Cung Hoàng Đạo", "Tình Yêu, Nghề Nghiệp & Bí Mật Tính Cách", "Xếp Hạng & Khám Phá Thế Giới Hoàng Đạo", "Giải Mã Chi Tiết Từng Chòm Sao", "Bí Ẩn Tarot & Tương Lai 12 Chòm Sao"]
            m_title = m_titles[m_idx - 1] if m_idx <= len(m_titles) else f"Chuyên đề nâng cao phần {m_idx}"
        
        m_title_escaped = m_title.replace("'", "''")
        sql_lines.append(f"""INSERT INTO modules (id, course_id, title, order_index, created_at)
VALUES ({mid}, {cid}, '{m_title_escaped}', {m_idx}, now());""")

        for l_idx, v in enumerate(chunk, 1):
            lid = lesson_id_counter
            lesson_id_counter += 1
            v_title = v['title'].replace("'", "''")
            vid = v['videoId']
            embed_url = f"https://www.youtube.com/embed/{vid}"
            content = f"<p>Bài giảng: <strong>{v_title}</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>".replace("'", "''")
            
            sql_lines.append(f"""INSERT INTO lessons (id, module_id, title, content, video_url, document_url, order_index, created_at, updated_at)
VALUES ({lid}, {mid}, '{v_title}', '{content}', '{embed_url}', NULL, {l_idx}, now(), now());""")

        # Add a quiz for each module
        qid = quiz_id_counter
        quiz_id_counter += 1
        q_title = f"Kiểm tra trắc nghiệm: {m_title}".replace("'", "''")
        sql_lines.append(f"""INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES ({qid}, {mid}, '{q_title}', 80, 15, {len(chunk) + 1}, now(), now());""")

        # Add question 1
        q1_id = question_id_counter
        question_id_counter += 1
        q1_text = f"Nội dung trọng tâm được nhấn mạnh trong chương '{m_title}' là gì?".replace("'", "''")
        sql_lines.append(f"""INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES ({q1_id}, {mid}, '{q1_text}', 'SINGLE_CHOICE', 5, now());""")

        a1_id = answer_id_counter
        answer_id_counter += 1
        a2_id = answer_id_counter
        answer_id_counter += 1
        a3_id = answer_id_counter
        answer_id_counter += 1
        
        sql_lines.append(f"""INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index) VALUES
({a1_id}, {q1_id}, 'Hiểu rõ nguyên lý cốt lõi và ứng dụng thực tiễn vào đời sống', true, 1),
({a2_id}, {q1_id}, 'Chỉ ghi nhớ máy móc lý thuyết mà không cần thực hành', false, 2),
({a3_id}, {q1_id}, 'Bỏ qua các nguyên tắc cơ bản ban đầu', false, 3);""")

        qq1_id = quiz_q_counter
        quiz_q_counter += 1
        sql_lines.append(f"""INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES ({qq1_id}, {qid}, {q1_id}, {mid}, 1, 5);""")

sql_lines.append("""
-- =====================================================================
-- Gán sẵn 3 khóa học cho tài khoản học viên student1 (id=4)
-- =====================================================================
INSERT INTO registrations (id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at) VALUES
(1, 4, 1, now(), 0, 'ACTIVE', NULL, NULL, 0, 'FREE', now()),
(2, 4, 2, now(), 0, 'ACTIVE', NULL, NULL, 0, 'FREE', now()),
(3, 4, 3, now(), 0, 'ACTIVE', NULL, NULL, 0, 'FREE', now())
ON CONFLICT (user_id, course_id) DO UPDATE SET status = 'ACTIVE', payment_status = 'FREE';

-- Cập nhật tất cả sequences
SELECT setval('settings_id_seq', (SELECT COALESCE(MAX(id), 1) FROM settings));
SELECT setval('courses_id_seq', (SELECT COALESCE(MAX(id), 1) FROM courses));
SELECT setval('modules_id_seq', (SELECT COALESCE(MAX(id), 1) FROM modules));
SELECT setval('lessons_id_seq', (SELECT COALESCE(MAX(id), 1) FROM lessons));
SELECT setval('quizzes_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quizzes));
SELECT setval('questions_id_seq', (SELECT COALESCE(MAX(id), 1) FROM questions));
SELECT setval('answer_options_id_seq', (SELECT COALESCE(MAX(id), 1) FROM answer_options));
SELECT setval('quiz_questions_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quiz_questions));
SELECT setval('registrations_id_seq', (SELECT COALESCE(MAX(id), 1) FROM registrations));

COMMIT;
""")

with open('database/seed_full_courses.sql', 'w', encoding='utf-8') as f:
    f.write("\n".join(sql_lines))

print("Generated database/seed_full_courses.sql successfully!")
