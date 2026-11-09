module DeTai

using Printf

export Nut, CayNhiPhan, kiem_tra_dau_vao, tao_cay, dem_nut, dem_la, chieu_cao, dem_nut_mot_con, giai_bai, in_cay, in_chi_tiet_ghep

"""
Cấu trúc biểu diễn một nút trong cây nhị phân:
- `id`: Định danh của nút (1..n)
- `gia_tri`: Giá trị dữ liệu lưu tại nút (không ảnh hưởng đến thống kê số nút, lá, chiều cao)
- `trai`: ID nút con bên trái (0 nếu không có)
- `phai`: ID nút con bên phải (0 nếu không có)
"""
struct Nut
    id::Int
    gia_tri::Any
    trai::Int
    phai::Int
end

"""
Cấu trúc biểu diễn cây nhị phân:
- `n`: Số lượng nút (0 <= n <= 100)
- `goc`: ID nút gốc (0 nếu cây rỗng)
- `cac_nut`: Bảng ánh xạ từ id -> Nut
"""
struct CayNhiPhan
    n::Int
    goc::Int
    cac_nut::Dict{Int, Nut}
end

"""
    kiem_tra_dau_vao(n, goc, danh_sach_nut)

Kiểm tra tính hợp lệ của dữ liệu đầu vào theo đúng hợp đồng của đề tài DT085:
1. Số lượng nút n phải nằm trong [0, 100].
2. Nếu n == 0 thì goc phải bằng 0 và danh_sach_nut phải rỗng.
3. Nếu n > 0 thì goc phải nằm trong 1..n.
4. Danh sách các nút phải có đúng n phần tử.
5. Mỗi nút có id nằm trong 1..n, không được trùng lặp id.
6. Chỉ số con trái và con phải phải nằm trong 0..n.
7. Không có nút dùng chung: mỗi nút (trừ gốc) có đúng 1 cha trỏ đến.
8. Gốc không có cha trỏ vào (bậc vào = 0).
9. Không có chu trình và toàn bộ n nút đều liên thông (đạt tới được từ gốc).
"""
function kiem_tra_dau_vao(n::Integer, goc::Integer, danh_sach_nut)
    # 1. Kiểm tra miền giá trị của n
    0 <= n <= 100 || throw(ArgumentError("So luong nut n phai nam trong khoang 0..100 (nhan n = $n)"))

    # 2. Trường hợp cây rỗng
    if n == 0
        goc == 0 || throw(ArgumentError("Cay rong (n = 0) thi goc phai bang 0 (nhan goc = $goc)"))
        isempty(danh_sach_nut) || throw(ArgumentError("Cay rong (n = 0) thi danh sach nut phai rong"))
        return true
    end

    # 3. Trường hợp cây có nút
    1 <= goc <= n || throw(ArgumentError("Goc phai nam trong khoang 1..$n (nhan goc = $goc)"))
    length(danh_sach_nut) == n || throw(ArgumentError("So luong nut trong danh sach ($(length(danh_sach_nut))) khong khop voi n = $n"))

    id_da_co = Set{Int}()
    so_cha = Dict{Int, Int}()
    for i in 1:n
        so_cha[i] = 0
    end

    danh_sach_chuan = Nut[]
    for item in danh_sach_nut
        length(item) == 4 || throw(ArgumentError("Moi nut phai la bo 4 (id, gia_tri, trai, phai)"))
        id, val, trai, phai = item
        (id isa Integer && trai isa Integer && phai isa Integer) || throw(ArgumentError("id, trai, phai phai la so nguyen"))
        
        1 <= id <= n || throw(ArgumentError("id nut ($id) nam ngoai pham vi 1..$n"))
        id in id_da_co && throw(ArgumentError("Bi trung lap id nut: $id"))
        push!(id_da_co, id)

        0 <= trai <= n || throw(ArgumentError("Chi so con trai ($trai) nam ngoai pham vi 0..$n"))
        0 <= phai <= n || throw(ArgumentError("Chi so con phai ($phai) nam ngoai pham vi 0..$n"))
        (trai != id && phai != id) || throw(ArgumentError("Nut $id khong the tu tro vao chinh minh"))
        (trai == 0 || phai == 0 || trai != phai) || throw(ArgumentError("Con trai va con phai cua nut $id khong duoc trung nhau"))

        if trai != 0
            so_cha[trai] += 1
        end
        if phai != 0
            so_cha[phai] += 1
        end

        push!(danh_sach_chuan, Nut(id, val, trai, phai))
    end

    # Kiểm tra bậc vào (số cha của mỗi nút)
    so_cha[goc] == 0 || throw(ArgumentError("Nut goc $goc khong duoc co nut cha tro toi"))
    for i in 1:n
        if i != goc
            so_cha[i] == 1 || throw(ArgumentError("Nut $i co $(so_cha[i]) cha tro toi (moi nut con phai co dung 1 cha duy nhat)"))
        end
    end

    # Kiểm tra liên thông từ gốc và không có chu trình bằng duyệt BFS
    da_tham = Set{Int}()
    hang_doi = [goc]
    push!(da_tham, goc)

    tra_cuu = Dict(nut.id => nut for nut in danh_sach_chuan)
    while !isempty(hang_doi)
        u = popfirst!(hang_doi)
        nut_u = tra_cuu[u]
        for v in (nut_u.trai, nut_u.phai)
            if v != 0
                v in da_tham && throw(ArgumentError("Phat hien chu trinh hoac nut dung chung tai nut $v"))
                push!(da_tham, v)
                push!(hang_doi, v)
            end
        end
    end

    length(da_tham) == n || throw(ArgumentError("Cay khong lien thong: chi co $(length(da_tham))/$n nut duoc ket noi tu goc $goc"))

    return true
end

"""
    tao_cay(n, goc, danh_sach_nut)

Xây dựng đối tượng `CayNhiPhan` sau khi đã kiểm tra hợp lệ.
"""
function tao_cay(n::Integer, goc::Integer, danh_sach_nut)
    kiem_tra_dau_vao(n, goc, danh_sach_nut)
    cac_nut = Dict{Int, Nut}()
    for item in danh_sach_nut
        nut = Nut(item[1], item[2], item[3], item[4])
        cac_nut[nut.id] = nut
    end
    return CayNhiPhan(n, goc, cac_nut)
end

"""
    dem_nut(u, cay)

Đếm tổng số nút của cây con gốc u theo khuôn đệ quy:
- Nếu u == 0 (cây rỗng): trả về 0.
- Ngược lại: trả về 1 + dem_nut(trai) + dem_nut(phai).
"""
function dem_nut(u::Integer, cay::CayNhiPhan)
    u == 0 && return 0
    nut = cay.cac_nut[u]
    return 1 + dem_nut(nut.trai, cay) + dem_nut(nut.phai, cay)
end

"""
    dem_la(u, cay)

Đếm số lượng nút lá của cây con gốc u theo khuôn đệ quy:
- Nếu u == 0 (cây rỗng): trả về 0.
- Nếu nút u không có con trái và không có con phải: trả về 1 (nút lá).
- Ngược lại: trả về dem_la(trai) + dem_la(phai).
"""
function dem_la(u::Integer, cay::CayNhiPhan)
    u == 0 && return 0
    nut = cay.cac_nut[u]
    if nut.trai == 0 && nut.phai == 0
        return 1
    end
    return dem_la(nut.trai, cay) + dem_la(nut.phai, cay)
end

"""
    chieu_cao(u, cay)

Tính chiều cao của cây con gốc u theo quy ước giáo trình:
- Cây rỗng (u == 0): chiều cao = 0.
- Cây 1 nút (nút lá): chiều cao = 1.
- Tổng quát: chiều cao = 1 + max(chieu_cao(trai), chieu_cao(phai)).
"""
function chieu_cao(u::Integer, cay::CayNhiPhan)
    u == 0 && return 0
    nut = cay.cac_nut[u]
    cao_trai = chieu_cao(nut.trai, cay)
    cao_phai = chieu_cao(nut.phai, cay)
    return 1 + max(cao_trai, cao_phai)
end

"""
    dem_nut_mot_con(u, cay)

(Yêu cầu mở rộng theo Bài tập 32 giáo trình):
Đếm số lượng nút chỉ có đúng một nút con (con trái hoặc con phải).
- Nếu u == 0: trả về 0.
- Kiểm tra xem u có đúng 1 con hay không.
- Cộng với kết quả đệ quy của hai cây con.
"""
function dem_nut_mot_con(u::Integer, cay::CayNhiPhan)
    u == 0 && return 0
    nut = cay.cac_nut[u]
    co_mot_con = (nut.trai == 0 && nut.phai != 0) || (nut.trai != 0 && nut.phai == 0)
    la_mot_con = co_mot_con ? 1 : 0
    return la_mot_con + dem_nut_mot_con(nut.trai, cay) + dem_nut_mot_con(nut.phai, cay)
end

"""
Thu thập thông tin thống kê của từng cây con phục vụ in ấn minh chứng ghép từ dưới lên.
"""
function thong_ke_cac_nut(u::Integer, cay::CayNhiPhan, ds_kq=Dict{Int, NamedTuple}())
    u == 0 && return ds_kq
    nut = cay.cac_nut[u]
    thong_ke_cac_nut(nut.trai, cay, ds_kq)
    thong_ke_cac_nut(nut.phai, cay, ds_kq)
    sn = dem_nut(u, cay)
    sl = dem_la(u, cay)
    h = chieu_cao(u, cay)
    smc = dem_nut_mot_con(u, cay)
    ds_kq[u] = (; id=u, gia_tri=nut.gia_tri, trai=nut.trai, phai=nut.phai, so_nut=sn, so_la=sl, chieu_cao=h, nut_mot_con=smc)
    return ds_kq
end

"""
    giai_bai(du_lieu)

Hàm thực thi chính nhận dữ liệu đầu vào (n, goc, danh_sach_nut) hoặc một đối tượng `CayNhiPhan`.
Trả về NamedTuple chứa các kết quả thống kê tổng thể và chi tiết từng nút.
"""
function giai_bai(du_lieu)
    local cay::CayNhiPhan
    if du_lieu isa CayNhiPhan
        cay = du_lieu
    elseif du_lieu isa NamedTuple || du_lieu isa Tuple
        n, goc, danh_sach_nut = du_lieu
        cay = tao_cay(n, goc, danh_sach_nut)
    else
        throw(ArgumentError("Kieu du lieu dau vao khong hop le"))
    end

    if cay.n == 0
        return (;
            cay = cay,
            so_nut = 0,
            so_la = 0,
            chieu_cao = 0,
            so_nut_mot_con = 0,
            chi_tiet = Dict{Int, NamedTuple}()
        )
    end

    sn = dem_nut(cay.goc, cay)
    sl = dem_la(cay.goc, cay)
    h = chieu_cao(cay.goc, cay)
    smc = dem_nut_mot_con(cay.goc, cay)
    chi_tiet = thong_ke_cac_nut(cay.goc, cay)

    return (;
        cay = cay,
        so_nut = sn,
        so_la = sl,
        chieu_cao = h,
        so_nut_mot_con = smc,
        chi_tiet = chi_tiet
    )
end

"""
In biểu diễn trực quan dạng cây thụt đầu dòng (ASCII tree).
"""
function in_cay(u::Integer, cay::CayNhiPhan, prefix="", la_nhanh_phai=true)
    u == 0 && return
    nut = cay.cac_nut[u]
    nhanh = la_nhanh_phai ? "└── " : "├── "
    println(prefix, nhanh, "Nut ", nut.id, " [val=", nut.gia_tri, "]")
    tien_to_moi = prefix * (la_nhanh_phai ? "    " : "│   ")
    
    # In con trái và con phải
    if nut.trai != 0 || nut.phai != 0
        if nut.trai != 0
            in_cay(nut.trai, cay, tien_to_moi, nut.phai == 0)
        else
            println(tien_to_moi, "├── (trai: rong)")
        end

        if nut.phai != 0
            in_cay(nut.phai, cay, tien_to_moi, true)
        else
            println(tien_to_moi, "└── (phai: rong)")
        end
    end
end

"""
In chi tiết quá trình ghép từ dưới lên để thấy rõ hoạt động của khuôn đệ quy.
"""
function in_chi_tiet_ghep(kq)
    if kq.cay.n == 0
        println("Cay rong: so_nut = 0, so_la = 0, chieu_cao = 0")
        return
    end

    println("CHI TIET GHEP KET QUA TU DUOI LEN:")
    println("-"^70)
    println("Nut ID | Gia tri | Con trai | Con phai | So nut | So la | Chieu cao | 1 Con")
    println("-"^70)
    # Sắp xếp theo ID hoặc theo thứ tự duyệt sau
    cac_id = sort(collect(keys(kq.chi_tiet)))
    for id in cac_id
        ct = kq.chi_tiet[id]
        @printf("%6d | %7s | %8d | %8d | %6d | %5d | %9d | %5d\n",
            ct.id, string(ct.gia_tri), ct.trai, ct.phai, ct.so_nut, ct.so_la, ct.chieu_cao, ct.nut_mot_con)
    end
    println("-"^70)
    println("KET QUA TAI GOC ($(kq.cay.goc)):")
    println("  => Tong so nut:  $(kq.so_nut)")
    println("  => Tong so la:   $(kq.so_la)")
    println("  => Chieu cao:    $(kq.chieu_cao)")
    println("  => Nut dung 1 con: $(kq.so_nut_mot_con)")
    println("-"^70)
end

end # module DeTai
