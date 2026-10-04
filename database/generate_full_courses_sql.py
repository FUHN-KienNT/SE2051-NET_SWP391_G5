import json

with open('database/playlists_data.json', 'r', encoding='utf-8') as f:
    courses = json.load(f)

# Ngân hàng câu hỏi trắc nghiệm chuyên sâu cho từng Module (12 Modules)
QUIZ_DATA = {
    # Module 1 (Khóa 1): Căn Bản Nhân Tướng & Tam Đình Ngũ Nhạc
    1: [
        {
            "question": "Trong nhân tướng học, 'Tam Đình' trên khuôn mặt con người bao gồm những bộ vị nào?",
            "options": [
                ("Thượng đình (chân tóc đến lông mày), Trung đình (lông mày đến đầu mũi), Hạ đình (nhân trung đến cằm)", True),
                ("Tiền đình (trán), Hậu đình (gáy), Trung đình (hai bên gò má)", False),
                ("Thượng đình (mắt và trán), Trung đình (miệng và cằm), Hạ đình (tai và cổ)", False),
                ("Thiên đình (đỉnh đầu), Địa đình (vùng cằm), Nhân đình (vùng mũi)", False),
            ]
        },
        {
            "question": "'Ngũ Nhạc' trong diện tướng tương ứng với 5 ngọn núi biểu trưng cho 5 bộ vị trọng yếu nào?",
            "options": [
                ("Trán (Nam Nhạc), Cằm (Bắc Nhạc), Mũi (Trung Nhạc), Gò má trái (Đông Nhạc), Gò má phải (Tây Nhạc)", True),
                ("Hai tai, Hai mắt và Khuôn miệng", False),
                ("Đỉnh đầu, Thái dương trái, Thái dương phải, Cằm và Cổ", False),
                ("Trán, Sống mũi, Nhân trung, Môi trên và Môi dưới", False),
            ]
        },
        {
            "question": "Ý nghĩa chính của bộ vị 'Thượng Đình' (từ chân tóc đến lông mày) phản ánh điều gì về đương số?",
            "options": [
                ("Tiền vận (thời niên thiếu, sự nghiệp ban đầu) cùng năng lực tư duy, trí tuệ và phúc ấm tổ tiên", True),
                ("Hậu vận từ tuổi 50 trở đi cùng con cái và điền sản", False),
                ("Tình trạng tài chính và khả năng tích lũy tài sản lúc trung niên", False),
                ("Sức khỏe nội tạng và tuổi thọ tuyệt đối", False),
            ]
        },
        {
            "question": "Yếu tố cốt lõi nhất để một khuôn mặt đạt tiêu chuẩn 'Ngũ Nhạc triều quy' là gì?",
            "options": [
                ("Bốn ngọn núi Đông - Tây - Nam - Bắc đều chầu về ngọn núi Trung Nhạc (Mũi) với tỉ lệ cân phân, đắc cách", True),
                ("Mũi phải thật cao nhọn và lấn át hoàn toàn trán và cằm", False),
                ("Hai gò má phải phẳng lì, không nổi khối so với sống mũi", False),
                ("Trán và cằm phải vuông vức tuyệt đối không có độ cong tự nhiên", False),
            ]
        },
    ],
    # Module 2 (Khóa 1): Giải Mã Ngũ Quan & Diện Mạo
    2: [
        {
            "question": "'Ngũ Quan' trong nhân tướng học gồm có 5 giác quan và cơ quan nào?",
            "options": [
                ("Lông mày (Bảo thọ quan), Mắt (Giám sát quan), Tai (Thái thính quan), Mũi (Thẩm biện quan), Miệng (Xuất nạp quan)", True),
                ("Tóc, Râu, Lông mày, Móng tay và Răng", False),
                ("Mắt, Mũi, Miệng, Lưỡi và Da thịt", False),
                ("Trán, Cằm, Gò má, Thái dương và Nhân trung", False),
            ]
        },
        {
            "question": "Tướng 'Giám sát quan' (Đôi mắt) được coi là quý tướng và phản ánh tâm hồn thanh khiết khi có đặc điểm nào?",
            "options": [
                ("Tròng đen trắng phân minh, ánh mắt sáng có thần khí nhưng ẩn tàng, không lộ hung quang", True),
                ("Mắt lộ tam bạch hoặc tứ bạch, lòng trắng nhiều hơn lòng đen", False),
                ("Mắt luôn đảo liên tục, ánh nhìn sắc lẹm và trừng trộ", False),
                ("Mắt lờ đờ không có tiêu cự rõ ràng", False),
            ]
        },
        {
            "question": "Bộ vị 'Ấn Đường' (nằm giữa hai đầu lông mày) mang ý nghĩa phong thủy và nhân tướng là gì?",
            "options": [
                ("Cửa ngõ của vận khí (Cung Mệnh), thể hiện độ rộng mở của tâm trí và vận hạn hiện tại", True),
                ("Cung Phu Thê phản ánh hạnh phúc gia đình", False),
                ("Cung Nô Bộc phản ánh mối quan hệ với cấp dưới và bạn bè", False),
                ("Cung Tử Tức phản ánh đường con cái", False),
            ]
        },
        {
            "question": "Đặc điểm của một 'Thẩm biện quan' (Mũi) đắc cách biểu trưng cho tài lộc dồi dào là gì?",
            "options": [
                ("Sống mũi thẳng đầy đặn, chuẩn đầu (chóp mũi) tròn trịa, hai cánh mũi (dực đình) dày dặn và kín đáo", True),
                ("Sống mũi gồ ghề, đầu mũi nhọn hoắt và lỗ mũi hếch lên trên", False),
                ("Cánh mũi mỏng manh, nhìn trực diện thấy rõ toàn bộ lỗ mũi", False),
                ("Mũi lệch nghiêng sang một bên so với trục đối xứng khuôn mặt", False),
            ]
        },
    ],
    # Module 3 (Khóa 1): Khí Sắc, Tâm Tướng & Ứng Dụng Đời Sống
    3: [
        {
            "question": "Câu châm ngôn nổi tiếng 'Tướng tùy tâm sinh, tướng tùy tâm diệt' mang hàm nghĩa giáo dục gì trong nhân tướng học?",
            "options": [
                ("Diện mạo và khí sắc con người có thể biến chuyển tích cực thông qua việc tu dưỡng tâm tính, đạo đức và lối sống", True),
                ("Tướng mạo là bất biến từ khi sinh ra và không bao giờ thay đổi theo thời gian", False),
                ("Chỉ cần phẫu thuật thẩm mỹ thay đổi hình tướng là số phận tự động giàu sang", False),
                ("Tâm hồn không có liên hệ gì đến thần thái và ánh mắt bên ngoài", False),
            ]
        },
        {
            "question": "Trong việc quan sát 'Khí sắc', sắc diện nào báo hiệu cơ thể dồi dào sinh lực và tinh thần phấn chấn thuận lợi?",
            "options": [
                ("Sắc hồng hào nhuận sáng, ẩn hiện dưới da tựa như ngọc bích", True),
                ("Sắc xám xịt như tro tàn hoặc ám đen ở vùng trán và ấn đường", False),
                ("Sắc trắng bệch như vôi bột, không có huyết sắc", False),
                ("Sắc đỏ rực bất thường bừng bừng như lửa thiêu đốt", False),
            ]
        },
        {
            "question": "Khi ứng dụng quan sát nhân tướng trong tuyển dụng và đối nhân xử thế, điều quan trọng hàng đầu cần tránh là gì?",
            "options": [
                ("Phán xét một chiều định kiến qua một nét tướng đơn lẻ mà không xét tổng thể 'Tâm tướng' và thần thái", True),
                ("Lắng nghe giọng nói và xem tướng đi đứng cử chỉ", False),
                ("Quan sát cách họ đối xử với người yếu thế hơn mình", False),
                ("Xem xét sự hòa nhã trong nụ cười và ánh mắt", False),
            ]
        },
        {
            "question": "Thần thái (Thần khí) của một người thành tựu vững bền thường bộc lộ rõ nhất qua yếu tố nào?",
            "options": [
                ("Điềm tĩnh, tự tại, ánh mắt trầm ổn và lời nói đi đôi với việc làm", True),
                ("Nói to át giọng người khác, cử chỉ hung hăng vội vã", False),
                ("Hay liếc ngang liếc dọc và luôn tỏ ra bí hiểm", False),
                ("Cười cợt thiếu kiểm soát trong mọi hoàn cảnh", False),
            ]
        },
    ],
    # Module 4 (Khóa 2): Nhập Môn Lá Số Tử Vi & Học Thuyết Ngũ Hành
    4: [
        {
            "question": "Học thuyết Ngũ Hành trong tử vi bao gồm 5 yếu tố nào theo vòng tương sinh thuận chiều?",
            "options": [
                ("Mộc sinh Hỏa, Hỏa sinh Thổ, Thổ sinh Kim, Kim sinh Thủy, Thủy sinh Mộc", True),
                ("Kim sinh Mộc, Mộc sinh Thổ, Thổ sinh Thủy, Thủy sinh Hỏa, Hỏa sinh Kim", False),
                ("Hỏa sinh Thủy, Thủy sinh Kim, Kim sinh Thổ, Thổ sinh Mộc", False),
                ("Thủy sinh Thổ, Thổ sinh Kim, Kim sinh Hỏa, Hỏa sinh Mộc", False),
            ]
        },
        {
            "question": "Hệ thống Can Chi dùng để an lá số Tử Vi gồm bao nhiêu Thiên Can và bao nhiêu Địa Chi?",
            "options": [
                ("10 Thiên Can và 12 Địa Chi", True),
                ("12 Thiên Can và 10 Địa Chi", False),
                ("8 Thiên Can và 8 Địa Chi", False),
                ("12 Thiên Can và 12 Địa Chi", False),
            ]
        },
        {
            "question": "Bốn yếu tố thời gian bắt buộc phải có để thiết lập một lá số Tử Vi chuẩn xác là gì?",
            "options": [
                ("Giờ sinh, ngày sinh, tháng sinh và năm sinh (tính theo Âm lịch hoặc quy đổi chuẩn xác) kèm giới tính", True),
                ("Chỉ cần ngày tháng năm sinh Dương lịch, không cần giờ sinh", False),
                ("Giờ sinh, nhóm máu, nơi sinh và năm sinh", False),
                ("Tên tuổi của cha mẹ và thời điểm cất tiếng khóc chào đời", False),
            ]
        },
        {
            "question": "Cặp quan hệ tương khắc nào sau đây là chuẩn xác theo quy luật Ngũ Hành?",
            "options": [
                ("Kim khắc Mộc, Mộc khắc Thổ, Thổ khắc Thủy, Thủy khắc Hỏa, Hỏa khắc Kim", True),
                ("Kim khắc Hỏa, Hỏa khắc Thủy, Thủy khắc Kim", False),
                ("Thổ khắc Mộc, Mộc khắc Kim, Kim khắc Thủy", False),
                ("Mộc khắc Thủy, Thủy khắc Hỏa, Hỏa khắc Thổ", False),
            ]
        },
    ],
    # Module 5 (Khóa 2): Hệ Thống 12 Cung & Can Chi Bản Mệnh
    5: [
        {
            "question": "Trên bàn cờ lá số Tử Vi, 12 cung chức vị tượng trưng cho các phương diện cuộc đời bắt đầu bằng cung trọng tâm nào?",
            "options": [
                ("Cung Mệnh", True),
                ("Cung Tài Bạch", False),
                ("Cung Quan Lộc", False),
                ("Cung Thiên Di", False),
            ]
        },
        {
            "question": "'Tam hợp Mệnh' là sự phối hợp mật thiết giữa ba cung vị then chốt nào quyết định thành bại cuộc đời?",
            "options": [
                ("Cung Mệnh, Cung Quan Lộc và Cung Tài Bạch (Mệnh - Tài - Quan)", True),
                ("Cung Mệnh, Cung Phụ Mẫu và Cung Huynh Đệ", False),
                ("Cung Mệnh, Cung Thiên Di và Cung Phu Thê", False),
                ("Cung Mệnh, Cung Phúc Đức và Cung Điền Trạch", False),
            ]
        },
        {
            "question": "Cung Thân trong lá số Tử Vi đại diện cho điều gì và bắt đầu chi phối mạnh mẽ từ giai đoạn nào?",
            "options": [
                ("Hậu vận, hành động thực tế của đương số và bắt đầu chi phối rõ nét từ tuổi trung niên (sau 30 tuổi)", True),
                ("Tuổi thơ ấu từ 1 đến 15 tuổi", False),
                ("Tiền tài của cha mẹ truyền lại", False),
                ("Trạng thái sức khỏe thể chất trong năm sinh", False),
            ]
        },
        {
            "question": "Cung xung chiếu trực tiếp với Cung Mệnh trên vòng 12 Địa Chi là cung nào?",
            "options": [
                ("Cung Thiên Di (phản ánh môi trường xã hội bên ngoài khi xuất hành ra ngoài)", True),
                ("Cung Tật Ách (phản ánh bệnh tật tai ương)", False),
                ("Cung Phu Thê (phản ánh bạn đời hôn phối)", False),
                ("Cung Nô Bộc (phản ánh bạn bè cộng sự)", False),
            ]
        },
    ],
    # Module 6 (Khóa 2): Luận Giải Chính Tinh & Phụ Tinh
    6: [
        {
            "question": "Trong Tử Vi Đẩu Số có tổng cộng bao nhiêu Chính Tinh (các ngôi sao lớn quyết định tính chất cốt lõi)?",
            "options": [
                ("14 Chính Tinh (thuộc hai chòm Tử Vi và Thiên Phủ)", True),
                ("10 Chính Tinh", False),
                ("12 Chính Tinh", False),
                ("18 Chính Tinh", False),
            ]
        },
        {
            "question": "Ngôi sao nào được mệnh danh là 'Đế tinh' (Vua của các vì sao), tượng trưng cho quyền uy, đức độ và khả năng lãnh đạo?",
            "options": [
                ("Sao Tử Vi", True),
                ("Sao Thất Sát", False),
                ("Sao Cự Môn", False),
                ("Sao Tham Lang", False),
            ]
        },
        {
            "question": "Bộ 'Tứ Hóa' - bốn biến hóa then chốt mang lại vận hội và thách thức trong lá số Tử Vi gồm những sao nào?",
            "options": [
                ("Hóa Khoa, Hóa Quyền, Hóa Lộc, Hóa Kỵ", True),
                ("Hóa Tinh, Hóa Khí, Hóa Thần, Hóa Sát", False),
                ("Hóa Tài, Hóa Phúc, Hóa Thọ, Hóa Khang", False),
                ("Hóa Sinh, Hóa Thành, Hóa Hoại, Hóa Diệt", False),
            ]
        },
        {
            "question": "Bộ 'Lục Sát Tinh' trong Tử Vi mang tính chất xung phá, rèn luyện tôi luyện bản lĩnh gồm những sao nào?",
            "options": [
                ("Kình Dương, Đà La, Hỏa Tinh, Linh Tinh, Địa Không, Địa Kiếp", True),
                ("Văn Xương, Văn Khúc, Tả Phụ, Hữu Bật, Thiên Khôi, Thiên Việt", False),
                ("Đào Hoa, Hồng Loan, Hỷ Thần, Thiên Hỷ, Long Trì, Phượng Các", False),
                ("Lộc Tồn, Thiên Mã, Quốc Ấn, Đường Phù, Hóa Lộc, Hóa Quyền", False),
            ]
        },
    ],
    # Module 7 (Khóa 2): Kỹ Thuật Luận Đoán & Workshop Chuyên Sâu
    7: [
        {
            "question": "Nguyên tắc quan trọng khi luận giải một cung vị bất kỳ trên lá số Tử Vi là phải phối hợp những yếu tố nào?",
            "options": [
                ("Cung vị chính tinh đắc hãm, tam phương tứ chính (cung chiếu, hai cung tam hợp) và giáp cung", True),
                ("Chỉ nhìn duy nhất 1 ngôi sao tại cung đó mà không cần xem các cung liên quan", False),
                ("Bỏ qua hoàn toàn ngũ hành nạp âm của bản mệnh và cung an sao", False),
                ("Chỉ xét ngày sinh Dương lịch mà không xét can chi năm tháng", False),
            ]
        },
        {
            "question": "Khái niệm 'Đại Hạn' trong Tử Vi chỉ chu kỳ vận hạn kéo dài bao nhiêu năm?",
            "options": [
                ("Chu kỳ 10 năm", True),
                ("Chu kỳ 1 năm", False),
                ("Chu kỳ 5 năm", False),
                ("Chu kỳ 12 năm", False),
            ]
        },
        {
            "question": "Khi gặp cách cục 'Hung tinh đắc địa' trên lá số, người có ý chí kiên định thường đạt được điều gì?",
            "options": [
                ("Phát dã như lôi, biến khó khăn nghịch cảnh thành bàn đạp để tạo dựng thành tựu đột phá", True),
                ("Luôn luôn thất bại thảm hại không bao giờ vực dậy được", False),
                ("Sống an nhàn thụ động không cần phải nỗ lực học tập", False),
                ("Tránh né mọi va chạm và chỉ làm công việc tĩnh lặng", False),
            ]
        },
        {
            "question": "Đạo đức nghề nghiệp căn bản của một chuyên gia hoặc người nghiên cứu Tử Vi chân chính là gì?",
            "options": [
                ("Giúp người khác thấu hiểu điểm mạnh điểm yếu, định hướng tu tâm dưỡng đức và vượt qua vận hạn bằng trí tuệ, tránh mê tín dọa dẫm", True),
                ("Phán những điều ma mị rùng rợn để trục lợi cúng bái giải hạn vô căn cứ", False),
                ("Khẳng định số phận là tuyệt đối không thể thay đổi bằng nỗ lực cá nhân", False),
                ("Khuyên học viên bỏ mặc công việc chờ đợi số trời an bài", False),
            ]
        },
    ],
    # Module 8 (Khóa 3): Truyền Thuyết & Bản Chất 12 Cung Hoàng Đạo
    8: [
        {
            "question": "12 Cung Hoàng Đạo trong Chiêm tinh học phương Tây được chia đều thành 4 nhóm nguyên tố tự nhiên nào?",
            "options": [
                ("Lửa (Fire), Đất (Earth), Khí (Air), Nước (Water)", True),
                ("Kim, Mộc, Thủy, Hỏa", False),
                ("Trời, Đất, Biển, Rừng", False),
                ("Sắt, Gỗ, Đá, Bụi", False),
            ]
        },
        {
            "question": "Nhóm 3 cung hoàng đạo thuộc nguyên tố 'Lửa' (Fire) tràn đầy nhiệt huyết và tính tiên phong gồm những cung nào?",
            "options": [
                ("Bạch Dương (Aries), Sư Tử (Leo), Nhân Mã (Sagittarius)", True),
                ("Kim Ngưu, Xử Nữ, Ma Kết", False),
                ("Song Tử, Thiên Bình, Bảo Bình", False),
                ("Cự Giải, Bọ Cạp, Song Ngư", False),
            ]
        },
        {
            "question": "Vòng Hoàng Đạo bắt đầu bằng cung nào vào thời điểm điểm phân mùa xuân (Xuân phân ~21/03)?",
            "options": [
                ("Bạch Dương (Aries)", True),
                ("Kim Ngưu (Taurus)", False),
                ("Ma Kết (Capricorn)", False),
                ("Song Ngư (Pisces)", False),
            ]
        },
        {
            "question": "Đặc tính chung nổi bật nhất của nhóm cung nguyên tố 'Đất' (Kim Ngưu, Xử Nữ, Ma Kết) là gì?",
            "options": [
                ("Thực tế, kiên định, đáng tin cậy và có tư duy tổ chức logic vững vàng", True),
                ("Bốc đồng, nóng nảy và thích mạo hiểm không tính toán", False),
                ("Mộng mơ, cảm xúc lấn át lý trí và hay thay đổi tâm trạng", False),
                ("Tùy hứng, tự do bay bổng và ghét mọi nguyên tắc ổn định", False),
            ]
        },
    ],
    # Module 9 (Khóa 3): Tình Yêu, Nghề Nghiệp & Bí Mật Tính Cách
    9: [
        {
            "question": "Trong mối quan hệ tình cảm, các cung cùng nhóm nguyên tố nào thường tạo nên sự đồng điệu sâu sắc về mặt cảm xúc và sự thấu cảm?",
            "options": [
                ("Nhóm nguyên tố Nước (Cự Giải, Bọ Cạp, Song Ngư)", True),
                ("Nhóm nguyên tố Đất và Lửa xung khắc trực diện", False),
                ("Nhóm Khí và Đất", False),
                ("Bất kỳ cung nào không phân biệt tính chất", False),
            ]
        },
        {
            "question": "Nhóm cung Khí (Song Tử, Thiên Bình, Bảo Bình) thường phát huy tối đa tiềm năng bản thân trong những lĩnh vực nào?",
            "options": [
                ("Truyền thông, ngoại giao, nghiên cứu ý tưởng, công nghệ sáng tạo và viết lách", True),
                ("Lao động thể lực nặng nhọc mang tính lặp đi lặp lại", False),
                ("Các công việc cô lập hoàn toàn không tiếp xúc trao đổi với con người", False),
                ("Chỉ làm việc rập khuôn theo mẫu cũ không cải tiến", False),
            ]
        },
        {
            "question": "Cung hoàng đạo nào được mệnh danh là 'Bậc thầy ngoại giao', luôn hướng tới sự hòa hợp, công bằng và thẩm mỹ tao nhã?",
            "options": [
                ("Thiên Bình (Libra)", True),
                ("Bạch Dương (Aries)", False),
                ("Bọ Cạp (Scorpio)", False),
                ("Ma Kết (Capricorn)", False),
            ]
        },
        {
            "question": "Thách thức lớn nhất trong tình cảm của nhóm cung nguyên tố Lửa (Bạch Dương, Sư Tử, Nhân Mã) là gì?",
            "options": [
                ("Tính hiếu thắng, cái tôi lớn và thiếu kiên nhẫn khi xảy ra bất đồng", True),
                ("Quá khép kín, không bao giờ bày tỏ cảm xúc ra bên ngoài", False),
                ("Luôn luôn do dự phụ thuộc hoàn toàn vào ý kiến của người khác", False),
                ("Không có ngọn lửa nhiệt huyết trong tình yêu", False),
            ]
        },
    ],
    # Module 10 (Khóa 3): Xếp Hạng & Khám Phá Thế Giới Hoàng Đạo
    10: [
        {
            "question": "Cung hoàng đạo nào thường đứng đầu bảng về tính kỷ luật, sự kiên trì và tham vọng xây dựng sự nghiệp bền bỉ?",
            "options": [
                ("Ma Kết (Capricorn)", True),
                ("Nhân Mã (Sagittarius)", False),
                ("Song Ngư (Pisces)", False),
                ("Song Tử (Gemini)", False),
            ]
        },
        {
            "question": "Chòm sao nào nổi tiếng với sự sâu sắc, trực giác tâm lý sắc bén và ý chí kiên cường tự tái sinh sau nghịch cảnh?",
            "options": [
                ("Bọ Cạp (Scorpio / Thiên Yết)", True),
                ("Kim Ngưu (Taurus)", False),
                ("Cự Giải (Cancer)", False),
                ("Sư Tử (Leo)", False),
            ]
        },
        {
            "question": "Đặc điểm nổi trội nhất giúp cung Song Tử (Gemini) thích nghi xuất sắc trong mọi môi trường xã hội là gì?",
            "options": [
                ("Khả năng ngôn ngữ hoạt bát, sự tò mò học hỏi nhanh và tính linh hoạt cao", True),
                ("Tính bảo thủ và trung thành tuyệt đối với một thói quen cố định", False),
                ("Sức chịu đựng thể lực vượt trội không cần giao tiếp", False),
                ("Luôn giữ im lặng tuyệt đối trước mọi cuộc tranh luận", False),
            ]
        },
        {
            "question": "Cung hoàng đạo nào biểu trưng cho sự ấm áp của gia đình, bản năng che chở nuôi dưỡng và trí nhớ tình cảm tuyệt vời?",
            "options": [
                ("Cự Giải (Cancer)", True),
                ("Bảo Bình (Aquarius)", False),
                ("Bạch Dương (Aries)", False),
                ("Nhân Mã (Sagittarius)", False),
            ]
        },
    ],
    # Module 11 (Khóa 3): Giải Mã Chi Tiết Từng Chòm Sao
    11: [
        {
            "question": "Chòm sao Bảo Bình (Aquarius) được cai quản bởi Thiên Vương Tinh (Uranus) mang phẩm chất độc đáo nào?",
            "options": [
                ("Tư duy đột phá, tầm nhìn thời đại, tinh thần nhân đạo và yêu chuộng tự do cá nhân", True),
                ("Thích bắt chước người khác và tuân phục tuyệt đối giáo điều cũ", False),
                ("Đam mê quyền lực vật chất danh vị truyền thống", False),
                ("Luôn phụ thuộc tinh thần vào người xung quanh", False),
            ]
        },
        {
            "question": "Biểu tượng của chòm sao Kim Ngưu (Taurus) gắn liền với hình tượng gì và phản ánh giá trị gì?",
            "options": [
                ("Con Bò Đực kiên định, phản ánh sự vững chãi, kiên nhẫn và thưởng thức giá trị vật chất ổn định", True),
                ("Cán cân công lý cân bằng lý trí", False),
                ("Con Cua với lớp vỏ phòng thủ nhạy cảm", False),
                ("Nhân Mã cầm cung tên bay nhảy tự do", False),
            ]
        },
        {
            "question": "Sư Tử (Leo) được cai quản bởi Mặt Trời rực rỡ, điểm mạnh cốt lõi trong tính cách của họ là gì?",
            "options": [
                ("Sự hào hiệp, tự tin, khả năng truyền cảm hứng và tinh thần lãnh đạo đầy phong thái", True),
                ("Luôn thích lùi vào bóng tối và không dám đứng trước đám đông", False),
                ("Sự hà tiện chi li từng đồng xu lẻ", False),
                ("Hay nghi ngờ đố kỵ với sự thành công của người khác", False),
            ]
        },
        {
            "question": "Chòm sao Song Ngư (Pisces) - cung hoàng đạo cuối cùng trên vòng Hoàng Đạo - kết tinh vẻ đẹp tinh thần nào?",
            "options": [
                ("Lòng từ bi bao dung, trí tưởng tượng phong phú và khả năng kết nối tâm linh sâu sắc", True),
                ("Tính toán lạnh lùng và chỉ tin vào những gì nhìn thấy trước mắt", False),
                ("Tính cạnh tranh gay gắt khốc liệt trong công việc", False),
                ("Sự thực dụng tuyệt đối về tiền bạc", False),
            ]
        },
    ],
    # Module 12 (Khóa 3): Bí Ẩn Tarot & Tương Lai 12 Chòm Sao
    12: [
        {
            "question": "Trong sự kết hợp giữa Chiêm tinh học và bài Tarot, các lá bài Ẩn chính (Major Arcana) đại diện cho điều gì?",
            "options": [
                ("Các nguyên mẫu tâm lý học, những bài học chuyển hóa lớn của cuộc đời và các chòm sao tương ứng", True),
                ("Chỉ là những lá bài bói toán ngẫu nhiên không có tính hệ thống", False),
                ("Những quy định pháp luật xã hội hiện đại", False),
                ("Các chỉ số đo lường tài chính kinh doanh thuần túy", False),
            ]
        },
        {
            "question": "Lá bài Tarot 'The Emperor' (Hoàng Đế) tương ứng với cung hoàng đạo tiên phong nào thể hiện ý chí khai phá và trật tự?",
            "options": [
                ("Bạch Dương (Aries)", True),
                ("Song Ngư (Pisces)", False),
                ("Cự Giải (Cancer)", False),
                ("Thiên Bình (Libra)", False),
            ]
        },
        {
            "question": "Lá bài 'The Star' (Ngôi Sao) mang thông điệp về niềm hy vọng, cảm hứng tương lai và chữa lành kết nối trực tiếp với cung nào?",
            "options": [
                ("Bảo Bình (Aquarius)", True),
                ("Kim Ngưu (Taurus)", False),
                ("Ma Kết (Capricorn)", False),
                ("Bọ Cạp (Scorpio)", False),
            ]
        },
        {
            "question": "Mục tiêu tối hậu của việc nghiên cứu Chiêm Tinh Học và các bộ môn biểu tượng đối với con người hiện đại là gì?",
            "options": [
                ("Tự nhận thức sâu sắc bản thân (Self-awareness), phát huy sở trường, khắc phục khuyết điểm và sống hài hòa", True),
                ("Dự đoán cứng nhắc ngày giờ gặp rủi ro để trốn tránh thực tế cuộc sống", False),
                ("Tin vào định mệnh an bài và buông xuôi không cần cố gắng học tập lao động", False),
                ("Dùng để phán xét và cô lập người khác trong các mối quan hệ xã hội", False),
            ]
        },
    ],
}

sql_lines = []
sql_lines.append("-- =====================================================================")
sql_lines.append("-- Courson LMS - Master Consolidated Seed Data")
sql_lines.append("-- Bao gồm: Categories, 3 Khóa học đầy đủ (118 bài giảng),")
sql_lines.append("-- 12 Quizzes chuẩn hóa, 48 Câu hỏi & 192 Phương án trả lời,")
sql_lines.append("-- Đăng ký học viên, Tiến độ học mẫu & Lịch sử thi thử nghiệm.")
sql_lines.append("-- =====================================================================")
sql_lines.append("BEGIN;")
sql_lines.append("")
sql_lines.append("-- 1. Tạo các danh mục khóa học bổ sung nếu chưa tồn tại")
sql_lines.append("""INSERT INTO settings (type, name, value, priority, status, description) VALUES
    ('COURSE_CATEGORY', 'Nhân tướng học & Nhân trắc học', 'PHYSIOGNOMY', 4, 'ACTIVE', 'Kiến thức nhân tướng học, diện mạo và nhân trắc học ứng dụng'),
    ('COURSE_CATEGORY', 'Tử Vi & Phong Thủy', 'TU_VI', 5, 'ACTIVE', 'Nghiên cứu lá số Tử Vi, âm dương ngũ hành và giải đoán vận hạn'),
    ('COURSE_CATEGORY', 'Chiêm Tinh & Cung Hoàng Đạo', 'ASTROLOGY', 6, 'ACTIVE', 'Khám phá bí mật 12 cung hoàng đạo và chiêm tinh học ứng dụng')
ON CONFLICT (type, name) DO NOTHING;
""")

sql_lines.append("-- 2. Xóa sạch dữ liệu bài thi, tiến độ, đăng ký và khóa học cũ để nạp mới đồng bộ")
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

        # Add a quiz for each module (4 questions x 25 points = 100 points, pass_score = 75, time_limit = 15m)
        qid = quiz_id_counter
        quiz_id_counter += 1
        q_title = f"Kiểm tra trắc nghiệm: {m_title}".replace("'", "''")
        sql_lines.append(f"""INSERT INTO quizzes (id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at)
VALUES ({qid}, {mid}, '{q_title}', 75, 15, {m_idx}, now(), now());""")

        module_questions = QUIZ_DATA.get(mid, [])
        for q_order, q_info in enumerate(module_questions, 1):
            q_id = question_id_counter
            question_id_counter += 1
            q_text = q_info['question'].replace("'", "''")
            
            sql_lines.append(f"""INSERT INTO questions (id, module_id, question_text, question_type, default_points, created_at)
VALUES ({q_id}, {mid}, '{q_text}', 'SINGLE_CHOICE', 25, now());""")

            for opt_order, (opt_text, is_correct) in enumerate(q_info['options'], 1):
                a_id = answer_id_counter
                answer_id_counter += 1
                opt_escaped = opt_text.replace("'", "''")
                corr_str = "true" if is_correct else "false"
                
                sql_lines.append(f"""INSERT INTO answer_options (id, question_id, option_text, is_correct, order_index)
VALUES ({a_id}, {q_id}, '{opt_escaped}', {corr_str}, {opt_order});""")

            qq_id = quiz_q_counter
            quiz_q_counter += 1
            sql_lines.append(f"""INSERT INTO quiz_questions (id, quiz_id, question_id, module_id, order_index, points)
VALUES ({qq_id}, {qid}, {q_id}, {mid}, {q_order}, 25);""")

sql_lines.append("""
-- =====================================================================
-- 3. Đăng ký khóa học mặc định cho tài khoản học viên student1 (id=4)
-- =====================================================================
INSERT INTO registrations (id, user_id, course_id, registration_date, progress_percentage, status, payment_method, payment_code, payment_amount, payment_status, paid_at) VALUES
(1, 4, 1, now() - interval '3 days', 24.00, 'ACTIVE', NULL, NULL, 0, 'FREE', now() - interval '3 days'),
(2, 4, 2, now() - interval '2 days', 0.00, 'ACTIVE', NULL, NULL, 0, 'FREE', now() - interval '2 days'),
(3, 4, 3, now() - interval '1 day',  0.00, 'ACTIVE', NULL, NULL, 0, 'FREE', now() - interval '1 day')
ON CONFLICT (user_id, course_id) DO UPDATE SET status = 'ACTIVE', payment_status = 'FREE';

-- 4. Tiến độ học thử nghiệm (student1 đã học xong 4 bài đầu của Khóa học 1)
INSERT INTO lesson_progress (registration_id, lesson_id, status, completed_at) VALUES
(1, 1, 'COMPLETED', now() - interval '2 days'),
(1, 2, 'COMPLETED', now() - interval '2 days'),
(1, 3, 'COMPLETED', now() - interval '1 day'),
(1, 4, 'COMPLETED', now() - interval '1 day')
ON CONFLICT (registration_id, lesson_id) DO UPDATE SET status = 'COMPLETED', completed_at = now();

-- 5. Lịch sử bài làm kiểm tra mẫu (student1 đã hoàn thành Quiz 1 với điểm số 100/100 tuyệt đối)
INSERT INTO quiz_attempts (id, registration_id, quiz_id, submitted_at, total_score, pass_status) VALUES
(1, 1, 1, now() - interval '1 day', 100.00, true)
ON CONFLICT (registration_id, quiz_id) DO UPDATE SET total_score = 100.00, pass_status = true;

-- Chi tiết đáp án học viên chọn cho Quiz 1 (Các câu hỏi 1, 2, 3, 4 đều chọn đúng phương án 1, 5, 9, 13)
INSERT INTO quiz_answers (quiz_attempt_id, question_id, selected_option_id, is_correct, score) VALUES
(1, 1, 1, true, 25.00),
(1, 2, 5, true, 25.00),
(1, 3, 9, true, 25.00),
(1, 4, 13, true, 25.00)
ON CONFLICT (quiz_attempt_id, question_id) DO UPDATE SET selected_option_id = EXCLUDED.selected_option_id, is_correct = true, score = 25.00;

-- =====================================================================
-- 6. Cập nhật tất cả các sequences của PostgreSQL
-- =====================================================================
SELECT setval('settings_id_seq', (SELECT COALESCE(MAX(id), 1) FROM settings));
SELECT setval('users_id_seq', (SELECT COALESCE(MAX(id), 1) FROM users));
SELECT setval('courses_id_seq', (SELECT COALESCE(MAX(id), 1) FROM courses));
SELECT setval('modules_id_seq', (SELECT COALESCE(MAX(id), 1) FROM modules));
SELECT setval('lessons_id_seq', (SELECT COALESCE(MAX(id), 1) FROM lessons));
SELECT setval('quizzes_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quizzes));
SELECT setval('questions_id_seq', (SELECT COALESCE(MAX(id), 1) FROM questions));
SELECT setval('answer_options_id_seq', (SELECT COALESCE(MAX(id), 1) FROM answer_options));
SELECT setval('quiz_questions_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quiz_questions));
SELECT setval('registrations_id_seq', (SELECT COALESCE(MAX(id), 1) FROM registrations));
SELECT setval('lesson_progress_id_seq', (SELECT COALESCE(MAX(id), 1) FROM lesson_progress));
SELECT setval('quiz_attempts_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quiz_attempts));
SELECT setval('quiz_answers_id_seq', (SELECT COALESCE(MAX(id), 1) FROM quiz_answers));

COMMIT;
""")

sql_content = "\n".join(sql_lines)

# Ghi ra database/seed_full_courses.sql (giữ tương thích)
with open('database/seed_full_courses.sql', 'w', encoding='utf-8') as f:
    f.write(sql_content)

# Ghi ra database/seed.sql (bản chuẩn hóa hợp nhất)
with open('database/seed.sql', 'w', encoding='utf-8') as f:
    f.write(sql_content)

print(f"Generated successfully: {course_id_counter - 1} courses, {module_id_counter - 1} modules, {quiz_id_counter - 1} quizzes ({question_id_counter - 1} questions, {answer_id_counter - 1} options)!")
