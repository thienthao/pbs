class Pending {
  String taskname;
  String package;
  String customer;
  String address;
  String time;
  String status;

  Pending({
    this.taskname,
    this.package,
    this.customer,
    this.address,
    this.time,
    this.status,
  });
}

final List<Pending> pendings = [
  Pending(
      taskname: 'Chụp ảnh',
      package: 'Gói chụp ảnh thời trang cơ bản',
      customer: 'Minh Khoa',
      address: 'Quảng trường Lâm Viên, Thành Phố Đà Lạt, Tỉnh Lâm Đồng',
      time: '15/11/2020 - 8:00 AM',
      status: 'Chờ xác nhận',
  ),
  Pending(
      taskname: 'Chụp ảnh',
      package: 'Gói chụp ảnh sản phẩm cao cấp',
      customer: 'Tống Ngọc An',
      address: ' 517 Đại Lộ Bình Dương, Thuận An, Bình Dương',
      time: '22/11/2020 - 04:00 PM',
      status: 'Chờ xác nhận',
  ),
  Pending(
      taskname: 'Chụp ảnh',
      package: 'Gói chụp ảnh kỷ yếu cơ bản',
      customer: 'Trần Đức Việt',
      address: 'THPT Gò Vấp, Thành Phố Hồ Chí Minh',
      time: '30/11/2020 - 07:00 AM',
      status: 'Chờ xác nhận',
  ),
];
