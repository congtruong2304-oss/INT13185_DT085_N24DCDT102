using Test
include(joinpath(@__DIR__, "..", "src", "DeTai.jl"))
using .DeTai

@testset "BO KIEM THU DE TAI DT085 - DEM NUT, LA VA CHIEU CAO CAY NHI PHAN" begin

    @testset "TC01 - [Ca bien 1] Cay rong (n = 0, goc = 0)" begin
        kq = giai_bai((0, 0, []))
        @test kq.so_nut == 0
        @test kq.so_la == 0
        @test kq.chieu_cao == 0
        @test kq.so_nut_mot_con == 0
    end

    @testset "TC02 - [Ca bien 2] Cay mot nut don (n = 1, goc = 1)" begin
        nut = [(1, "root", 0, 0)]
        kq = giai_bai((1, 1, nut))
        @test kq.so_nut == 1
        @test kq.so_la == 1
        @test kq.chieu_cao == 1
        @test kq.so_nut_mot_con == 0
    end

    @testset "TC03 - [Ca kiem 3] Goc co dung mot con trai (n = 2)" begin
        nut = [(1, "root", 2, 0), (2, "left_leaf", 0, 0)]
        kq = giai_bai((2, 1, nut))
        @test kq.so_nut == 2
        @test kq.so_la == 1
        @test kq.chieu_cao == 2
        @test kq.so_nut_mot_con == 1
    end

    @testset "TC04 - Goc co dung mot con phai (n = 2)" begin
        nut = [(1, "root", 0, 2), (2, "right_leaf", 0, 0)]
        kq = giai_bai((2, 1, nut))
        @test kq.so_nut == 2
        @test kq.so_la == 1
        @test kq.chieu_cao == 2
        @test kq.so_nut_mot_con == 1
    end

    @testset "TC05 - [Vi du 1 Phieu] Cay 3 nut can bang" begin
        # goc=1; nut=[(1,5,2,3),(2,9,0,0),(3,1,0,0)]
        nut = [(1, 5, 2, 3), (2, 9, 0, 0), (3, 1, 0, 0)]
        kq = giai_bai((3, 1, nut))
        @test kq.so_nut == 3
        @test kq.so_la == 2
        @test kq.chieu_cao == 2
        @test kq.so_nut_mot_con == 0
    end

    @testset "TC06 - [Vi du 2 Phieu] Cay day lech phai 3 nut" begin
        # goc=1; nut=[(1,4,0,2),(2,4,0,3),(3,4,0,0)]
        nut = [(1, 4, 0, 2), (2, 4, 0, 3), (3, 4, 0, 0)]
        kq = giai_bai((3, 1, nut))
        @test kq.so_nut == 3
        @test kq.so_la == 1
        @test kq.chieu_cao == 3
        @test kq.so_nut_mot_con == 2
    end

    @testset "TC07 - [Ca kiem 5] Cay day lech trai 4 nut" begin
        nut = [
            (1, 10, 2, 0),
            (2, 20, 3, 0),
            (3, 30, 4, 0),
            (4, 40, 0, 0)
        ]
        kq = giai_bai((4, 1, nut))
        @test kq.so_nut == 4
        @test kq.so_la == 1
        @test kq.chieu_cao == 4
        @test kq.so_nut_mot_con == 3
    end

    @testset "TC08 - [Ca kiem 4] Cay day 7 nut 3 tang" begin
        nut = [
            (1, "A", 2, 3),
            (2, "B", 4, 5),
            (3, "C", 6, 7),
            (4, "D", 0, 0),
            (5, "E", 0, 0),
            (6, "F", 0, 0),
            (7, "G", 0, 0)
        ]
        kq = giai_bai((7, 1, nut))
        @test kq.so_nut == 7
        @test kq.so_la == 4
        @test kq.chieu_cao == 3
        @test kq.so_nut_mot_con == 0
    end

    @testset "TC09 - Cay ziczac 5 nut" begin
        # 1 -> trai 2 -> phai 3 -> trai 4 -> phai 5
        nut = [
            (1, 1, 2, 0),
            (2, 2, 0, 3),
            (3, 3, 4, 0),
            (4, 4, 0, 5),
            (5, 5, 0, 0)
        ]
        kq = giai_bai((5, 1, nut))
        @test kq.so_nut == 5
        @test kq.so_la == 1
        @test kq.chieu_cao == 5
        @test kq.so_nut_mot_con == 4
    end

    @testset "TC10 - Cay bat doi xung 6 nut (kiem tra tinh tong hop ket qua)" begin
        #          1
        #        /   \
        #       2     3
        #      / \
        #     4   5
        #    /
        #   6
        nut = [
            (1, "R", 2, 3),
            (2, "L", 4, 5),
            (3, "R1", 0, 0),
            (4, "L2", 6, 0),
            (5, "R2", 0, 0),
            (6, "L3", 0, 0)
        ]
        kq = giai_bai((6, 1, nut))
        @test kq.so_nut == 6
        @test kq.so_la == 3   # Nut 3, 5, 6
        @test kq.chieu_cao == 4 # Duong 1-2-4-6
        @test kq.so_nut_mot_con == 1 # Nut 4
    end

    @testset "TC11 - [Validator] Tu choi input vuot gioi han hoac trung ID" begin
        # n > 100
        @test_throws ArgumentError kiem_tra_dau_vao(101, 1, [])
        # n < 0
        @test_throws ArgumentError kiem_tra_dau_vao(-1, 0, [])
        # goc ngoai khoang 1..n
        @test_throws ArgumentError kiem_tra_dau_vao(2, 3, [(1, "A", 0, 0), (2, "B", 0, 0)])
        # trung ID
        @test_throws ArgumentError kiem_tra_dau_vao(2, 1, [(1, "A", 0, 0), (1, "B", 0, 0)])
    end

    @testset "TC12 - [Validator] Tu choi chu trinh hoac nut co 2 cha" begin
        # Nut tu tro vao minh
        @test_throws ArgumentError kiem_tra_dau_vao(1, 1, [(1, "A", 1, 0)])
        # Chu trinh 2 nut: 1 -> 2 -> 1
        @test_throws ArgumentError kiem_tra_dau_vao(2, 1, [(1, "A", 2, 0), (2, "B", 1, 0)])
        # Nut co 2 cha tro toi: 1 tro toi 3, 2 tro toi 3
        @test_throws ArgumentError kiem_tra_dau_vao(3, 1, [(1, "A", 2, 3), (2, "B", 3, 0), (3, "C", 0, 0)])
        # Cay khong lien thong (nut 3 tach roi khong toi duoc)
        @test_throws ArgumentError kiem_tra_dau_vao(3, 1, [(1, "A", 2, 0), (2, "B", 0, 0), (3, "C", 0, 0)])
    end

end
