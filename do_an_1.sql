create database do_an
use do_an


drop database do_an


--------------------TẠO BẢNG----------------------------------------------
create table phong_may(
	ma_phong int identity primary key,
	so_may_trong int,
	gia_1_gio_tren_phong float
)

create table may_tinh(
	ma_may int identity primary key,
	ma_phong int,
	hieu_suat int
	foreign key(ma_phong) references phong_may(ma_phong)
)

create table ca_lam(
	ma_ca int identity primary key,
	ten_ca nvarchar(50) ,
	luong float
)

create table nhan_vien(
	ma_nhan_vien int identity primary key,
	ten_nhan_vien nvarchar(50),
	ngay_sinh date,
	cccd nvarchar(50),
	so_dien_thoai nvarchar(50),
	ma_ca int
)
alter table nhan_vien 
add foreign key(ma_ca) references ca_lam(ma_ca)

create table tai_khoan(
	ma_tai_khoan int identity primary key,
	ma_khach_hang int,
	ten_dang_nhap nvarchar(50) not null,
	mat_khau nvarchar(50) not null,
	so_du int,
	ngay_lap date,
	foreign key (ma_khach_hang) references khach_hang(ma_khach_hang),
	constraint ck_mat_khau check (len(mat_khau) >= 6)
)

create table khach_hang(
	ma_khach_hang int identity primary key,
	ten_khach_hang nvarchar(50),
	ma_may int,
	ma_phong int,
	foreign key (ma_may) references may_tinh(ma_may),
	foreign key (ma_phong) references phong_may(ma_phong),
)

create table cham_cong(
	ma_cham_cong int identity primary key,
	ma_nhan_vien int,
	ten_ca nvarchar(50),
	ma_ca int,
	foreign key (ma_nhan_vien) references nhan_vien(ma_nhan_vien),
	foreign key (ma_ca) references ca_lam(ma_ca)
)

create table dich_vu(
	ma_dich_vu int identity primary key,
	ten_dich_vu nvarchar(50),
	gia_niem_yet float,
)

--create table hoa_don(
--	so_hoa_don int identity primary key,
--	ma_tai_khoan int,
--	nguoi_so_huu nvarchar(50),
--	ngay_lap_hoa_don date,
--	tien_net float,
--	tien_dich_vu float,
--	foreign key (ma_tai_khoan) references tai_khoan(ma_tai_khoan)
--)
--drop table hoa_don
create table quan_li(
	ma_may int,
	ma_nhan_vien int,
	ngay_kiem_tra date,
	primary key(ma_may,ma_nhan_vien),
	foreign key (ma_may) references may_tinh(ma_may),
	foreign key (ma_nhan_vien) references nhan_vien(ma_nhan_vien),
	
)

create table su_dung(
	ma_may int,
	ma_tai_khoan int,
	thoi_gian_bat_dau date,
	thoi_gian_ket_thuc date,
	ma_phong int,
	primary key(ma_may,ma_tai_khoan,ma_phong),
	foreign key (ma_may) references may_tinh(ma_may),
	foreign key (ma_tai_khoan) references tai_khoan(ma_tai_khoan),
	foreign key (ma_phong) references phong_may(ma_phong)
)

ALTER TABLE su_dung  ALTER COLUMN thoi_gian_bat_dau datetime
ALTER TABLE su_dung  ALTER COLUMN thoi_gian_ket_thuc datetime

create table thuc_hien(
	ma_nhan_vien int,
	ma_dich_vu int,
	primary key(ma_nhan_vien,ma_dich_vu),
	foreign key (ma_dich_vu) references dich_vu(ma_dich_vu),
	foreign key (ma_nhan_vien) references nhan_vien(ma_nhan_vien)
)
create table hoa_don_chi_tiet(
	so_hoa_don int primary key identity,
	ma_tai_khoan int ,
	tien_net_1 float,
	tien_dich_vu_1 float,
	tien_nap_vao_tai_khoan float,
	foreign key (ma_tai_khoan) references tai_khoan(ma_tai_khoan)
)
create table lap(
	ma_nhan_vien int,
	so_hoa_don int,
	primary key(ma_nhan_vien,so_hoa_don),
	foreign key (so_hoa_don) references hoa_don_chi_tiet(so_hoa_don),
	foreign key (ma_nhan_vien) references nhan_vien(ma_nhan_vien)
)

create table dich_vu_su_dung(
	so_hoa_don int,
	ma_dich_vu int,
	so_luong int,
	primary key(so_hoa_don,ma_dich_vu),
	foreign key (so_hoa_don) references hoa_don_chi_tiet(so_hoa_don),
	foreign key (ma_dich_vu) references dich_vu(ma_dich_vu)
)




------------ INSERT DỮ LIỆU--------------------------------------------

insert into phong_may
values (3,15000),(3,20000),(3,25000)
select*from phong_may



--------------------------------------INSERT MAY TINH------------------------------------------------------
--insert into may_tinh
--values (1,65),(1,70),(1,50),(1,65),(1,65),(1,65),(1,65),(1,65),(1,65),(1,65)
--		,(2,0),(2,3),(2,4),(2,0),(2,0),(2,0),(2,0),(2,0),(2,0),(2,0)
--		,(3,0),(3,5),(3,10),(3,0),(3,0),(3,0),(3,0),(3,0),(3,0),(3,0)

insert into may_tinh
values (1,65),(1,70),(1,50)
		,(2,0),(2,3),(2,4)
		,(3,0),(3,5),(3,10)
select * from may_tinh
--------------------------------------INSERT CA LAM
insert into ca_lam
values (N'Sáng',15000),(N'chiều',15000),(N'tối',15000),(N'đêm',20000)
select * from ca_lam


----------------khi them khach hang vao dung trigger de tinh so may con hay het-----------------------------------------



create or alter trigger them_khach_hang
on khach_hang
instead of insert 
as 
begin
	declare @ma_phong int =(select ma_phong from inserted)
	declare @so_may_trong_cu int =(select so_may_trong from phong_may where ma_phong=@ma_phong)
	if(@so_may_trong_cu=0)
		begin 
			print(N'hết máy')
		end
	else 
		begin
			print(N'Thêm thành công')
			update phong_may
			set so_may_trong = so_may_trong - 1
			where ma_phong=@ma_phong
			declare @ten nvarchar(50) = (select ten_khach_hang from inserted)
			declare @ma_may int = (select ma_may from inserted)
			insert into khach_hang
			values(@ten,@ma_may,@ma_phong)
		end
end

--(1,'nguyen_van_a','nguyenvana',100000,'03/12/2022'),
--(2,'tran_ngoc_han','tranngochan',200000,'06/22/2022'),
--(3,'tran_ngoc_linh','tranngoclinh',1000,'04/03/2021'),
--(4,'le_nhat_minh','lenhatminh',100000,'03/12/2022'),
--(5,'le_hoai_thuong','lehoaithuong',0,'12/12/2019'),
--(6,'nguyen_van_tam','nguyenvantam',1200,'07/12/2021')

insert into khach_hang
values('Nguyen Van Tam',9,3)

--('Tran Ngoc Han',2,1),('Tran Ngoc Linh',3,1),('Tran Minh Long',4,1)
		--('Le Nhat Minh',5,2),('Le Hoai Thuong',8,3),('Nguyen Van Tam',9,3)

create or alter procedure hien_danh_sach_khach_hang
	
as 
begin
	select * from khach_hang
	
end

exec hien_danh_sach_khach_hang
select * from khach_hang
select*from phong_may
----------------------------------------------------XOA 1 BAN RA ----------------------------------------------
create or alter trigger xoa_khach_hang_vao
on khach_hang
instead of delete
as 
begin
	declare @ma_phong_chen_vao int =(select ma_phong from deleted)
	declare @ma_kh int =(select ma_khach_hang from deleted)
	update phong_may
	set so_may_trong=so_may_trong+1
	where ma_phong=@ma_phong_chen_vao
	delete from khach_hang where ma_khach_hang=@ma_kh
	select * from khach_hang
	select*from phong_may
end
delete from khach_hang where ma_khach_hang=1




-----------------------------------------------INSERT NHAN VIEN--------------------------------------------------
insert into nhan_vien
values('Nguyen Nhu Nhut','04/04/2006','927345678','0123',1),
		('Le Thi Phi Yen','12/04/2006','987567390','1234',2),
		('Nguyen Van B','03/12/2006','997047382','554654',3),
		('Ngo Thanh Tuan','03/06/2006','913758498','2434324234',4),
		('Nguyen Thi Truc Thanh','04/06/2006','913758498','12323',1)
select*from nhan_vien

-------them nhan vien------------------------------
create or alter procedure them_vao_danh_sach_nhan_vien
	@ten nvarchar(50),
	@ngay_sinh date,
	@cccd nvarchar(50),
	@sdt nvarchar(50),
	@ma_ca int
as 
begin
	insert into nhan_vien
	values (@ten,@ngay_sinh,@cccd,@sdt,@ma_ca)
	
end

exec them_vao_danh_sach_nhan_vien @ten='nguyen huyen ngoc',@ngay_sinh='02/02/2002',@cccd='2312334234',@sdt='23434',@ma_ca=2

-----hien danh sach nhan vien
create or alter procedure hien_danh_sach_nhan_vien
	
as 
begin
	select * from nhan_vien
end

exec hien_danh_sach_nhan_vien


-------------------------------INSERT TAI KHOAN----------------------------------------------------------------------


insert into tai_khoan
values
(1,'nguyen_van_a','nguyenvana',100000,'03/12/2022'),
(2,'tran_ngoc_han','tranngochan',200000,'06/22/2022'),
(3,'tran_ngoc_linh','tranngoclinh',1000,'04/03/2021'),
(4,'le_nhat_minh','lenhatminh',100000,'03/12/2022'),
(5,'le_hoai_thuong','lehoaithuong',0,'12/12/2019'),
(6,'nguyen_van_tam','nguyenvantam',1200,'07/12/2021')
select*from tai_khoan
--------CHECK TAI KHOAN 1 KHACH HANG 1 TAI KHOAN

create or alter trigger trig_tai_khoan
on tai_khoan
instead of insert
as 
begin
	declare @ma_khach_hang int=(select ma_khach_hang from inserted)
	if(@ma_khach_hang in (select ma_khach_hang from tai_khoan))
		begin
			print(N'khách hàng này đã có tài khoản')
		end
	else 
		begin
			declare @ten_dang_nhap nvarchar(50)=(select ten_dang_nhap from inserted)
			declare @mat_khau nvarchar(50)=(select mat_khau from inserted)
			declare @so_du int=(select so_du from inserted)
			declare @ngay_lap date=(select ngay_lap from inserted)
			insert into tai_khoan
			values(@ma_khach_hang,@ten_dang_nhap,@mat_khau,@so_du,@ngay_lap)
		end
end

insert into dich_vu
values
('coca',10000),
('pepsi',12000),
('sting',20000),
(N'nước lọc',5000),
(N'mì tôm',10000),
(N'xúc xích',7000),
(N'thẻ điện thoại 10000',10000),
(N'thẻ điện thoại 20000',20000),
(N'thẻ điện thoại 30000',30000),
(N'thẻ điện thoại 40000',40000),
(N'thẻ điện thoại 50000',50000),
(N'thẻ điện thoại 100000',100000)
select * from dich_vu


--select * from dich_vu 
--where ten_dich_vu like N'%thẻ điện thoại%'

--insert into hoa_don
--values (4,'nguyen van a','07/01/2022'),
--		(2,'tran ngoc linh','05/01/2022')
--select * from hoa_don
--delete from hoa_don

--insert into quan_li
--values (4,4,'01/07/2022',N'Bình thường'),
--		(5,3,'06/01/2022',N'Hỏng màn hình')

--select * from quan_li

--insert into su_dung
--values(1,'01/07/2022 02:17:00','01/07/2022 03:17:00')
--select*from su_dung

--insert into thuc_hien
--values (4,1),(4,2),(5,5),(5,6),(5,1)
--select * from thuc_hien
--delete from thuc_hien

--insert into lap
--values (4,3),(4,2)

--select * from lap
--delete from lap

--insert into dich_vu_su_dung
--values(2,1,1),(3,2,2)
--select*from dich_vu_su_dung
--delete from dich_vu_su_dung


insert into cham_cong
values (1,N'sáng',1),(2,N'chiều',2),(3,N'tối',3),(4,N'đêm',4),(5,N'sáng',1)

select * from cham_cong


------------xử lí-----------------------------------------------------
select * from 
nhan_vien join ca_lam on nhan_vien.ma_ca = ca_lam.ma_ca


-----HIEN TAI KHOAN THEO MA-----------------------
create or alter procedure hien_danh_sach_tai_khoan_theo_ma_kh
	@ma_khach_hang int
	
as 
begin
	select * from tai_khoan
	where @ma_khach_hang=tai_khoan.ma_khach_hang
	
end

exec hien_danh_sach_tai_khoan_theo_ma_kh @ma_khach_hang=1
--------------------------------------THAY ĐỔI MẬT KHẨU--------------------------
create or alter proc sua_thong_tin_tai_khoan
	@ma_tai_khoan int,
	@mat_khau nvarchar(50)
as
begin
	update tai_khoan
	set tai_khoan.mat_khau=@mat_khau
	where tai_khoan.ma_tai_khoan=@ma_tai_khoan
	select * from tai_khoan
end

exec sua_thong_tin_tai_khoan @ma_tai_khoan=1, @mat_khau='tran_duc_manhjjjj'


---------------------------TINH LUONG CHO NHAN VIEN--------------------------------------------------------

create table chi_tiet_bang_cong(
	ma_nhan_vien int,
	ngay_1 int,ngay_2 int,ngay_3 int,ngay_4 int,ngay_5 int,ngay_6 int,ngay_7 int,ngay_8 int,ngay_9 int,ngay_10 int,ngay_11 int,ngay_12 int,ngay_13 int,
	ngay_14 int,ngay_15 int,ngay_16 int,ngay_17 int,ngay_18 int,ngay_19 int,ngay_20 int,ngay_21 int,ngay_22 int,ngay_23 int,ngay_24 int,ngay_25 int,ngay_26 int,
	ngay_27 int,ngay_28 int,ngay_29 int,ngay_30 int,ngay_31 int
	foreign key(ma_nhan_vien) references nhan_vien(ma_nhan_vien)
)
drop table chi_tiet_bang_cong



select*from chi_tiet_bang_cong

create or alter trigger trig_cham_cong
on chi_tiet_bang_cong
instead of insert
as
begin
	
	declare @ma_nv int = (select ma_nhan_vien from inserted)
	declare @ngay_1 int = (select ngay_1 from inserted)
	declare @ngay_2 int = (select ngay_2 from inserted)
	declare @ngay_3 int = (select ngay_3 from inserted)
	declare @ngay_4 int = (select ngay_4 from inserted)
	declare @ngay_5 int = (select ngay_5 from inserted)
	declare @ngay_6 int = (select ngay_6 from inserted)
	declare @ngay_7 int = (select ngay_7 from inserted)
	declare @ngay_8 int = (select ngay_8 from inserted)
	declare @ngay_9 int = (select ngay_9 from inserted)
	declare @ngay_10 int = (select ngay_10 from inserted)
	declare @ngay_11 int = (select ngay_11 from inserted)
	declare @ngay_12 int = (select ngay_12 from inserted)
	declare @ngay_13 int = (select ngay_13 from inserted)
	declare @ngay_14 int = (select ngay_14 from inserted)
	declare @ngay_15 int = (select ngay_15 from inserted)
	declare @ngay_16 int = (select ngay_16 from inserted)
	declare @ngay_17 int = (select ngay_17 from inserted)
	declare @ngay_18 int = (select ngay_18 from inserted)
	declare @ngay_19 int = (select ngay_19 from inserted)
	declare @ngay_20 int = (select ngay_20 from inserted)
	declare @ngay_21 int = (select ngay_21 from inserted)
	declare @ngay_22 int = (select ngay_22 from inserted)
	declare @ngay_23 int = (select ngay_23 from inserted)
	declare @ngay_24 int = (select ngay_24 from inserted)
	declare @ngay_25 int = (select ngay_25 from inserted)
	declare @ngay_26 int = (select ngay_26 from inserted)
	declare @ngay_27 int = (select ngay_27 from inserted)
	declare @ngay_28 int = (select ngay_28 from inserted)
	declare @ngay_29 int = (select ngay_29 from inserted)
	declare @ngay_30 int = (select ngay_30 from inserted)
	declare @ngay_31 int = (select ngay_31 from inserted)
	
	insert into chi_tiet_bang_cong
	values (@ma_nv,@ngay_1,@ngay_2,@ngay_3,@ngay_4,@ngay_5,@ngay_6,@ngay_7,@ngay_8,@ngay_9,@ngay_10,@ngay_11,@ngay_12,@ngay_13,@ngay_14,@ngay_15,@ngay_16,@ngay_17,@ngay_18,@ngay_19,@ngay_20,
	@ngay_21,@ngay_22,@ngay_23,@ngay_24,@ngay_25,@ngay_26,@ngay_27,@ngay_28,@ngay_29,@ngay_30,@ngay_31)

	select chi_tiet_bang_cong.ma_nhan_vien,(@ngay_1+@ngay_2+@ngay_3+@ngay_4+@ngay_5+@ngay_6+@ngay_7+@ngay_8+@ngay_9+@ngay_10+@ngay_11+@ngay_12+@ngay_13+@ngay_14+@ngay_15+@ngay_16+@ngay_17+@ngay_18+@ngay_19+@ngay_20+
	@ngay_21+@ngay_22+@ngay_23+@ngay_24+@ngay_25+@ngay_26+@ngay_27+@ngay_28+@ngay_29+@ngay_30+@ngay_31) as tong_so_ngay,ten_nhan_vien,(@ngay_1+@ngay_2+@ngay_3+@ngay_4+@ngay_5+@ngay_6+@ngay_7+@ngay_8+@ngay_9+@ngay_10+@ngay_11+@ngay_12+@ngay_13+@ngay_14+@ngay_15+@ngay_16+@ngay_17+@ngay_18+@ngay_19+@ngay_20+
	@ngay_21+@ngay_22+@ngay_23+@ngay_24+@ngay_25+@ngay_26+@ngay_27+@ngay_28+@ngay_29+@ngay_30+@ngay_31)*luong as luong

	from (chi_tiet_bang_cong join nhan_vien on chi_tiet_bang_cong.ma_nhan_vien = nhan_vien.ma_nhan_vien)
			join ca_lam on nhan_vien.ma_ca=ca_lam.ma_ca
end

insert into chi_tiet_bang_cong
values (4,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1)
select * from chi_tiet_bang_cong


----------------------TIM KIEM KHACH HANG THEO TEN--------------------
create or alter proc tim_kiem
@ten nvarchar(50)
as
begin 
	select * from 
	khach_hang join tai_khoan on khach_hang.ma_khach_hang=tai_khoan.ma_khach_hang
	where khach_hang.ten_khach_hang=@ten
end

exec tim_kiem @ten='nguyen van a'




-----------------HOA DON------------------

---tính tiền net


drop table hoa_don_chi_tiet


create or alter trigger trig_tinh_tien_net
on su_dung
instead of insert 
as
begin
	declare @st datetime = (select thoi_gian_bat_dau from inserted)
	declare @end datetime = (select thoi_gian_ket_thuc from inserted)
	declare @ma_phong int = (select ma_phong from inserted)
	declare @ma_may int = (select ma_may from inserted)
	declare @ma_tai_khoan int=(select ma_tai_khoan from inserted) 

	insert into su_dung
	values(@ma_may,@ma_tai_khoan,@st,@end,@ma_phong)
	
	
	
	declare @so_tien_choi float = (select
		ceiling(datediff(minute,@st,@end)/60.0) * gia_1_gio_tren_phong
	from ((su_dung join phong_may on su_dung.ma_phong=phong_may.ma_phong)
			join tai_khoan on tai_khoan.ma_tai_khoan=su_dung.ma_tai_khoan
			join khach_hang on su_dung.ma_may=khach_hang.ma_may)
	where tai_khoan.ma_tai_khoan = @ma_tai_khoan)
	insert into hoa_don_chi_tiet
	values(@ma_tai_khoan,@so_tien_choi,0,0)
	
end


insert into su_dung
values(1,1,'09/01/2023 09:00:00','09/01/2023 09:15:00',1)

insert into su_dung
values(9,6,'09/01/2023 09:00:00','09/01/2023 09:15:00',3)


select * from khach_hang
select * from phong_may
select * from su_dung
select * from hoa_don_chi_tiet
delete from hoa_don_chi_tiet
delete from su_dung


---------tính tiền dịch vụ----

create or alter trigger trig_tinh_dich_vu
on dich_vu_su_dung
instead of insert 
as
begin
	declare @so_hoa_don int = (select so_hoa_don from inserted)
	declare @ma_dich_vu int = (select ma_dich_vu from inserted)
	declare @so_luong int = (select so_luong from inserted)

	insert into dich_vu_su_dung
	values(@so_hoa_don,@ma_dich_vu,@so_luong)
	
	select *,(gia_niem_yet*so_luong) as tong_tien
	from dich_vu_su_dung join dich_vu on dich_vu_su_dung.ma_dich_vu=dich_vu.ma_dich_vu
		where dich_vu_su_dung.so_hoa_don=@so_hoa_don

end

insert into dich_vu_su_dung
values (2,3,3)
---------lấy ra các dịch vụ đã mua------------------------------------------------------------------------------------------------------------------------
select *,dich_vu.gia_niem_yet*dich_vu_su_dung.so_luong as tong_tien_dich_vu from dich_vu_su_dung join dich_vu on dich_vu_su_dung.ma_dich_vu=dich_vu.ma_dich_vu
where so_hoa_don=2
--------update tien dich vu-------------------------------------------------------------------------------------------------------------------------------

--select sum(dich_vu.gia_niem_yet*dich_vu_su_dung.so_luong) as tong_tien_dich_vu from dich_vu_su_dung join dich_vu on dich_vu_su_dung.ma_dich_vu=dich_vu.ma_dich_vu
--where so_hoa_don=2
--group by dich_vu_su_dung.so_hoa_don




select * from hoa_don_chi_tiet

create or alter proc up_tien_dich_vu
@so_hoa_don int
as
begin
	update hoa_don_chi_tiet
	set
	tien_dich_vu_1=(select sum(dich_vu.gia_niem_yet*dich_vu_su_dung.so_luong) as tong_tien_dich_vu 
	from (dich_vu_su_dung join dich_vu on dich_vu_su_dung.ma_dich_vu=dich_vu.ma_dich_vu)
		join hoa_don_chi_tiet on hoa_don_chi_tiet.so_hoa_don=dich_vu_su_dung.so_hoa_don
	where dich_vu_su_dung.so_hoa_don = @so_hoa_don
	group by dich_vu_su_dung.so_hoa_don
	)
	where so_hoa_don=@so_hoa_don
end

exec up_tien_dich_vu @so_hoa_don = 2

insert into dich_vu_su_dung
values (2,1,1)

----------------------------------------TINH TONG HOA DON-----------------------------------------

create or alter proc tinh_tong_hoa_don

as 
begin
	select*,(hoa_don_chi_tiet.tien_net_1+hoa_don_chi_tiet.tien_dich_vu_1+hoa_don_chi_tiet.tien_nap_vao_tai_khoan) as tong_tien_hoa_don from hoa_don_chi_tiet

end

exec tinh_tong_hoa_don

--------------------------------------in hoa don theo ma hoa don----------------------
create or alter proc hien_hoa_don
@so_hoa_don int
as 
begin
	select hoa_don_chi_tiet.so_hoa_don,tai_khoan.ma_tai_khoan,khach_hang.ma_khach_hang,ten_khach_hang,ma_may,ma_phong,
	hoa_don_chi_tiet.tien_net_1,hoa_don_chi_tiet.tien_dich_vu_1,hoa_don_chi_tiet.tien_nap_vao_tai_khoan,(hoa_don_chi_tiet.tien_net_1+hoa_don_chi_tiet.tien_dich_vu_1) as tong_tien_khach_hang_tra 
	from hoa_don_chi_tiet join tai_khoan on hoa_don_chi_tiet.ma_tai_khoan=tai_khoan.ma_tai_khoan
						join khach_hang on tai_khoan.ma_khach_hang =khach_hang.ma_khach_hang
	where hoa_don_chi_tiet.so_hoa_don=@so_hoa_don

	select *,dich_vu.gia_niem_yet*dich_vu_su_dung.so_luong as tong_tien_dich_vu 
	from dich_vu_su_dung join dich_vu on dich_vu_su_dung.ma_dich_vu=dich_vu.ma_dich_vu
						
	select hoa_don_chi_tiet.so_hoa_don,nap_the.ma_tai_khoan,nap_the.so_tien_nap
	from nap_the join hoa_don_chi_tiet on nap_the.ma_tai_khoan=hoa_don_chi_tiet.ma_tai_khoan
	where so_hoa_don=@so_hoa_don
end

exec hien_hoa_don @so_hoa_don = 2


----------------------------------------SO DU TAI KHOAN-------------------------------------------
---------------nap the-----
create table nap_the(
	ma_tai_khoan int,
	so_tien_nap float,
	ngay_nap date,
	foreign key (ma_tai_khoan) references tai_khoan(ma_tai_khoan)
)
drop table nap_the
create or alter trigger nap_tien_vao_tai_khoan
on nap_the
instead of insert 
as
begin 
	declare @nap_vao float =(select so_tien_nap from inserted)
	declare @ma_tai_khoan int =(select ma_tai_khoan from inserted)
	declare @ngay_nap date =(select ngay_nap from inserted)
	insert into nap_the
	values(@ma_tai_khoan,@nap_vao,@ngay_nap)
	update tai_khoan
	set 
	so_du = so_du + @nap_vao
	where ma_tai_khoan=@ma_tai_khoan
	update hoa_don_chi_tiet
	set
	tien_nap_vao_tai_khoan=@nap_vao
	where ma_tai_khoan=@ma_tai_khoan
	
end

select*from tai_khoan
select * from nap_the
insert into nap_the
values(6,10000000,'01/10/2023')


--------------tra tien cho cái tiền net và tiền dịch vụ---------
select * from hoa_don_chi_tiet
select * from tai_khoan
create or alter proc tra_tien
@so_hoa_don int
as
begin
	declare @so_du_tai_khoan float = (select so_du from tai_khoan join hoa_don_chi_tiet on tai_khoan.ma_tai_khoan=hoa_don_chi_tiet.ma_tai_khoan where  hoa_don_chi_tiet.so_hoa_don=@so_hoa_don)
	declare @so_tien_tra float =(select (tien_net_1+tien_dich_vu_1) from hoa_don_chi_tiet where hoa_don_chi_tiet.so_hoa_don=@so_hoa_don)
	declare @ma_tai_khoan int = (select ma_tai_khoan from hoa_don_chi_tiet where hoa_don_chi_tiet.so_hoa_don=@so_hoa_don)
	if (@so_du_tai_khoan>=@so_tien_tra)
		begin
			update tai_khoan
			set 
			so_du=so_du-@so_tien_tra
			where tai_khoan.ma_tai_khoan = @ma_tai_khoan
		end
	else 
		begin
			print('so du  tai khoan ko du de tra phi')
		end

end

exec tra_tien @so_hoa_don = 2
