# DT085 — ĐẾM NÚT, ĐẾM LÁ VÀ TÍNH CHIỀU CAO CÂY NHỊ PHÂN

Đồ án môn học **Cấu trúc dữ liệu và Giải thuật (INT13185 - Nhóm 03)**.  
Chương trình cài đặt và kiểm thử 3 thao tác đệ quy cơ bản trên cây nhị phân bằng ngôn ngữ **Julia** (sử dụng thư viện chuẩn).

---

## Thông tin và căn cứ

- Họ tên, MSSV, lớp: `Nguyễn Công Trường`, `N24DCDT102`, `D24CQDT01-N`.
- Mã và tên đề tài đúng trong danh sách: `DT085 — Đếm nút, đếm lá và tính chiều cao cây nhị phân`.
- Giảng viên hướng dẫn: `Hồ Nhựt Minh`.
- Giáo trình: `Giao-trinh-Cau-truc-du-lieu-va-Giai-thuat-INT1306.pdf`.
- Chương, mục, bài tập, trang in và trang PDF đúng đề: `Chương 7, Mục 7.3.3 *Các thao tác đệ quy khác*; Bài tập 32; trang in 165–166, 174; trang PDF 177–178, 186`.
- URL GitHub thật: `https://github.com/congtruong2304-oss/INT13185_DT085_N24DCDT102`.
- Phiên bản Julia: `julia version 1.12.7`.

---

## Cấu trúc thư mục dự án

```text
Khung_ma_nguon_ca_nhan/
├── src/
│   └── DeTai.jl              # Định nghĩa cây, bộ validator kiểm tra hợp lệ, và các hàm đệ quy
├── demo.jl                   # Chương trình chạy thử 8 kịch bản (A01–A08) và nhập từ bàn phím
├── test/
│   └── runtests.jl           # Bộ kiểm thử tự động với 12 test cases (48 phép assert)
├── docs/
│   └── anh_ket_qua/          # 11 ảnh chụp màn hình minh chứng thực nghiệm (A01–A11)
└── README.md                 # Tài liệu hướng dẫn và thông tin đồ án
```

---

## Hướng dẫn cài đặt và chạy

Mở Terminal (PowerShell) tại thư mục chứa mã nguồn:

```powershell
# 1. Kiểm tra môi trường Julia
julia --version

# 2. Chạy chương trình minh họa (in cây ASCII và bảng ghép từ dưới lên)
julia --startup-file=no demo.jl

# 3. Chạy toàn bộ bộ kiểm thử tự động
julia --startup-file=no test/runtests.jl
```

---

## Tóm tắt thuật toán và kết quả kiểm thử

### 1. Thuật toán cốt lõi
Cả 3 hàm đều được thiết kế theo khuôn mẫu **đệ quy chia để trị (Divide and Conquer)**:
* **`dem_nut(u)`**: Đếm tổng số nút của cây ($1 + \text{trái} + \text{phải}$).
* **`dem_la(u)`**: Đếm nút lá (nút có $\text{trái} = 0 \text{ và } \text{phải} = 0$).
* **`chieu_cao(u)`**: Chiều cao theo giáo trình ($1 + \max(\text{trái}, \text{phải})$; cây rỗng = 0, lá = 1).
* **`dem_nut_mot_con(u)`**: Hàm mở rộng theo Bài tập 32 trong giáo trình.

*Độ phức tạp thuật toán:*
* **Thời gian:** $O(n)$ do mỗi nút được thăm đúng 1 lần.
* **Bộ nhớ (Stack đệ quy):** $O(h)$ với $h$ là chiều cao cây ($O(\log n)$ khi cân bằng, $O(n)$ khi là cây dây).

### 2. Kết quả kiểm thử tự động (`runtests.jl`)
* **Tổng số ca kiểm thử:** 12 ca kiểm thử độc lập (TC01 $\rightarrow$ TC12) bao gồm ca biên (cây rỗng, cây 1 nút), các ví dụ trong đề, cây cân bằng, cây lệch và các ca từ chối input sai (chu trình, nút có 2 cha).
* **Kết quả:** **Pass 48 / 48 assert (100% Đạt)**, thời gian thực thi: **~0.7s**.

---

## Kiểm tra bản clone từ GitHub

Để kiểm chứng tính độc lập của mã nguồn, có thể clone về một thư mục sạch và chạy lại:

```powershell
git clone https://github.com/congtruong2304-oss/INT13185_DT085_N24DCDT102.git kiem_tra_ban_nop
cd kiem_tra_ban_nop
git rev-parse HEAD
julia --startup-file=no demo.jl
julia --startup-file=no test/runtests.jl
```

---

## Hồ sơ nộp đồ án

Bộ sản phẩm nộp cuối kỳ gồm 4 tệp:
1. `BaoCao_N24DCDT102_NguyenCongTruong.docx` — Báo cáo Word hoàn chỉnh 5 chương.
2. `BaoCao_N24DCDT102_NguyenCongTruong.pdf` — Báo cáo xuất sang PDF.
3. `MaNguon_N24DCDT102_NguyenCongTruong.zip` — Mã nguồn chương trình nén lại.
4. `ThongTinNop_N24DCDT102_NguyenCongTruong.txt` — Tệp thông tin nộp bài và commit SHA.
