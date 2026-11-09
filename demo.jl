include(joinpath(@__DIR__, "src", "DeTai.jl"))
using .DeTai
using Printf

function chay_minh_hoa(tieu_de, n, goc, danh_sach_nut)
    println("\n" * "="^70)
    println(">>> $tieu_de")
    println("="^70)
    println("Input:")
    println("  - So luong nut n: $n")
    println("  - Nut goc: $goc")
    println("  - Danh sach nut (id, gia_tri, trai, phai):")
    for nut in danh_sach_nut
        println("      $nut")
    end

    kq = giai_bai((n, goc, danh_sach_nut))

    if n > 0
        println("\nCau truc cay truc quan (ASCII Tree):")
        in_cay(goc, kq.cay)
        println()
        in_chi_tiet_ghep(kq)
    else
        println("\nKet qua: Cay rong => so_nut = 0, so_la = 0, chieu_cao = 0")
    end

    return kq
end

function chay_cac_vi_du_chuan()
    println("="^70)
    println("DO AN CSDL & GIAI THUAT (INT13185 - NHOM 03)")
    println("DE TAI DT085: DEM NUT, DEM LA VA TINH CHIEU CAO CAY NHI PHAN")
    println("Sinh vien: Nguyen Cong Truong - MSSV: N24DCDT102 - Lop: D24CQDT01-N")
    println("="^70)

    # 1. Ví dụ 1 (Phiếu đề tài)
    n1 = 3
    goc1 = 1
    nut1 = [(1, 5, 2, 3), (2, 9, 0, 0), (3, 1, 0, 0)]
    chay_minh_hoa("A01 / HINH 4.1: VI DU 1 TRONG PHIEU DE TAI (3 nut can bang)", n1, goc1, nut1)

    # 2. Ví dụ 2 (Phiếu đề tài)
    n2 = 3
    goc2 = 1
    nut2 = [(1, 4, 0, 2), (2, 4, 0, 3), (3, 4, 0, 0)]
    chay_minh_hoa("A02 / HINH 4.2: VI DU 2 TRONG PHIEU DE TAI (Cay day lech phai 3 nut)", n2, goc2, nut2)

    # 3. Ca biên 1: Cây rỗng (A05)
    chay_minh_hoa("A05 / HINH 4.5: CA BIEN 1 - CAY RONG (n = 0)", 0, 0, Tuple{Int,Any,Int,Int}[])

    # 4. Ca biên 2: Cây 1 nút đơn (A06)
    chay_minh_hoa("A06 / HINH 4.6: CA BIEN 2 - CAY 1 NUT DON (n = 1)", 1, 1, [(1, 10, 0, 0)])

    # 4b. Ca biên 3: Gốc có đúng một con lá (A07)
    chay_minh_hoa("A07 / HINH 4.7: CA BIEN 3 - GOC CO DUNG MOT CON LA (n = 2)", 2, 1, [(1, "root", 2, 0), (2, "leaf", 0, 0)])

    # 5. Ca tự thiết kế 1: Cây đầy 7 nút 3 tầng (A03 / Ca kiểm 4)
    n7 = 7
    goc7 = 1
    nut7 = [
        (1, "A", 2, 3),
        (2, "B", 4, 5),
        (3, "C", 6, 7),
        (4, "D", 0, 0),
        (5, "E", 0, 0),
        (6, "F", 0, 0),
        (7, "G", 0, 0)
    ]
    chay_minh_hoa("A03 / HINH 4.3: CA TU THIET KE 1 - CAY DAY 7 NUT 3 TANG", n7, goc7, nut7)

    # 6. Ca tự thiết kế 2: Cây dây lệch trái 4 nút (A04 / Ca kiểm 5)
    n4 = 4
    goc4 = 1
    nut4 = [
        (1, 10, 2, 0),
        (2, 20, 3, 0),
        (3, 30, 4, 0),
        (4, 40, 0, 0)
    ]
    chay_minh_hoa("A04 / HINH 4.4: CA TU THIET KE 2 - CAY DAY LECH TRAI 4 NUT", n4, goc4, nut4)

    # 7. Minh họa kiểm tra Input không hợp lệ (A08)
    println("\n" * "="^70)
    println(">>> A08 / HINH 4.8: KIEM TRA PHAN HOI TU CHOI INPUT KHONG HOP LE")
    println("="^70)
    println("Thu nghiem 1: Phat hien chu trinh (Nut 2 tro nguoc ve goc 1)")
    try
        nut_loi = [(1, "A", 2, 0), (2, "B", 1, 0)]
        kiem_tra_dau_vao(2, 1, nut_loi)
    catch e
        println("  => Validator bat loi thanh cong: ", sprint(showerror, e))
    end

    println("\nThu nghiem 2: Phat hien nut co 2 cha tro vao (Nut 3 la con cua ca 1 va 2)")
    try
        nut_loi2 = [(1, "A", 2, 3), (2, "B", 3, 0), (3, "C", 0, 0)]
        kiem_tra_dau_vao(3, 1, nut_loi2)
    catch e
        println("  => Validator bat loi thanh cong: ", sprint(showerror, e))
    end
    println("="^70)
end

function nhap_tu_ban_phim()
    println("\n--- CHE DO NHAP CAY TU BAN PHIM ---")
    print("Nhap so luong nut n (0..100): ")
    n = parse(Int, readline())
    if n == 0
        kq = giai_bai((0, 0, []))
        println("Cay rong: so_nut = 0, so_la = 0, chieu_cao = 0")
        return
    end

    print("Nhap ID nut goc (1..$n): ")
    goc = parse(Int, readline())

    println("Nhap $n dong, moi dong gom: id gia_tri trai phai (vi du: 1 5 2 3):")
    danh_sach_nut = []
    for i in 1:n
        print("Nut $i: ")
        line = readline()
        parts = split(line)
        id = parse(Int, parts[1])
        val = parts[2]
        trai = parse(Int, parts[3])
        phai = parse(Int, parts[4])
        push!(danh_sach_nut, (id, val, trai, phai))
    end

    chay_minh_hoa("KET QUA CAY NHAP TU BAN PHIM", n, goc, danh_sach_nut)
end

# Main entry point
if abspath(PROGRAM_FILE) == @__FILE__
    chay_cac_vi_du_chuan()
end
