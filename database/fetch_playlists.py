import urllib.request
import re
import json
import sys

# Ensure UTF-8 output
sys.stdout.reconfigure(encoding='utf-8')

playlists = [
    ('PLgw7NgEtgW9GgLhLHr_4_aTweO43fc1NZ', 'NhanTuongHoc', 1, 'Nhân Tướng Học Ứng Dụng - Thầy Viên Minh', 'PHYSIOGNOMY', 'Khóa học chuyên sâu về Nhân Tướng Học do Thầy Viên Minh giảng dạy. Hướng dẫn toàn diện phương pháp quan sát diện mạo, ngũ quan, thần thái, cốt cách, tam đình lục phủ để thấu hiểu bản thân và đối nhân xử thế hiệu quả trong công việc và cuộc sống.'),
    ('PL2H8iQ3Qjw6aIsdap8IzedBwcGXX5of9E', 'TuVi', 2, '[TVK6] Nhập Môn Tử Vi Đẩu Số & Học Thuyết Ngũ Hành', 'TU_VI', 'Khóa học [TVK6] cung cấp kiến thức nền tảng vững chắc về lá số Tử Vi, cơ cấu 12 cung bản mệnh, quy luật can chi, âm dương ngũ hành và phương pháp giải đoán lá số logic, khoa học.'),
    ('PLCnVxWXLA9GmJ3jao156CNq47jYJOWJPv', 'CungHoangDao', 3, 'Bí Mật Tính Cách 12 Cung Hoàng Đạo', 'ASTROLOGY', 'Khám phá bí mật tính cách thực sự, ưu điểm, nhược điểm, phong cách tư duy, tình cảm và sự tương hợp giữa 12 Cung Hoàng Đạo qua chuỗi bài giảng phân tích sinh động từ Xà Phu Channel.')
]

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept-Language': 'vi-VN,vi;q=0.9,en-US;q=0.8'
}

def extract_videos_from_html(html):
    m = re.search(r'var ytInitialData = ({.*?});</script>', html)
    if not m:
        return []
    data = json.loads(m.group(1))
    
    def extract_lockups(obj):
        if isinstance(obj, dict):
            if 'lockupViewModel' in obj:
                lvm = obj['lockupViewModel']
                title = lvm.get('metadata', {}).get('lockupMetadataViewModel', {}).get('title', {}).get('content')
                watch_cmd = lvm.get('rendererContext', {}).get('commandContext', {}).get('onTap', {}).get('innertubeCommand', {}).get('watchEndpoint', {})
                vid = watch_cmd.get('videoId')
                if not vid:
                    # fallback check
                    vcmd = lvm.get('contentImage', {}).get('thumbnailViewModel', {}).get('overlays', [])
                thumbs = lvm.get('contentImage', {}).get('thumbnailViewModel', {}).get('image', {}).get('sources', [])
                thumb_url = thumbs[-1].get('url') if thumbs else f"https://img.youtube.com/vi/{vid}/hqdefault.jpg"
                if vid and title:
                    yield {'videoId': vid, 'title': title, 'thumbnail': thumb_url}
            for v in obj.values():
                yield from extract_lockups(v)
        elif isinstance(obj, list):
            for it in obj:
                yield from extract_lockups(it)

    raw_items = list(extract_lockups(data))
    seen = set()
    deduped = []
    for it in raw_items:
        if it['videoId'] not in seen:
            seen.add(it['videoId'])
            deduped.append(it)
    return deduped

all_courses = []

for pid, key, cid, title, cat_val, desc in playlists:
    url = f'https://www.youtube.com/playlist?list={pid}'
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as resp:
            html = resp.read().decode('utf-8', errors='ignore')
            videos = extract_videos_from_html(html)
            print(f"=== {title} (Playlist {pid}): Found {len(videos)} videos ===")
            for i, v in enumerate(videos, 1):
                print(f"  {i}. [{v['videoId']}] {v['title']}")
            
            # Course thumbnail is the thumbnail of the 1st video
            c_thumb = f"https://img.youtube.com/vi/{videos[0]['videoId']}/hqdefault.jpg" if videos else ""
            all_courses.append({
                'courseId': cid,
                'title': title,
                'categoryValue': cat_val,
                'description': desc,
                'thumbnail': c_thumb,
                'videos': videos
            })
    except Exception as e:
        print(f"Error fetching {key}: {e}")

with open('database/playlists_data.json', 'w', encoding='utf-8') as f:
    json.dump(all_courses, f, ensure_ascii=False, indent=2)

print("Saved database/playlists_data.json successfully!")
