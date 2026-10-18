UPDATE lessons
SET content = '<p>Bài giảng: <strong>' || title || '</strong></p><p>Video bài giảng trực quan hướng dẫn chi tiết các nội dung kiến thức thực tiễn. Học viên xem kĩ video và ghi chú lại các ý chính.</p>'
WHERE content LIKE '%chi ti%';
