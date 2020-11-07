class Booking {
  String ptgname;
  String status;
  String address;
  String time;
  String package;

  Booking({this.ptgname, this.status, this.address, this.time, this.package});
}

final List<Booking> bookings = [
  Booking(
      ptgname: 'Cao Tiến',
      status: 'Chờ xác nhận',
      address: 'Quảng trường Lâm Viên, Thành Phố Đà Lạt, Tỉnh Lâm Đồng',
      time: '12:00 - 30/10/2020 ',
      package: 'GÓI CHỤP 1 NGƯỜI'),
  Booking(
      ptgname: 'Quang Huy',
      status: 'Sắp diễn ra',
      address: 'Vườn Hoa Đà Lạt, Thành Phố Đà Lạt, Tỉnh Lâm Đồng',
      time: '16/11/2020 - 11:00 AM',
      package: 'Gói chụp ảnh cosplay cơ bản'),
  Booking(
      ptgname: 'Trần Thịnh',
      status: 'Bị từ chối',
      address: 'THPT Phú Nhuận, Thành Phố Hồ Chí Minh',
      time: '18/11/2020 - 2:00 PM',
      package: 'Gói chụp ảnh kỷ yếu nâng cao'),
  Booking(
      ptgname: 'Huy Hoàng',
      status: 'Hoàn thành',
      address: '1000 Quang Trung, Gò Vấp, Thành Phố Hồ Chí Minh',
      time: '21/11/2020 - 5:00 PM',
      package: 'Gói chụp ảnh nội thất cao cấp'),
];
