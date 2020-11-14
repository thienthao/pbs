class Task {
  String taskname;
  String package;
  String customer;
  String address;
  String time;

  Task({
    this.taskname,
    this.package,
    this.customer,
    this.address,
    this.time,
  });
}

final List<Task> tasks = [
  Task(
      taskname: 'Chụp ảnh',
      package: 'Gói chụp ảnh thời trang cơ bản',
      customer: 'Linh Nguyễn',
      address: 'Phố đi bộ Nguyễn Huệ, Bến Nghé, Quận 1, Thành Phố Hồ Chí Minh',
      time: '08:00'),
  Task(
      taskname: 'Chụp ảnh',
      package: 'Gói chụp ảnh sản phẩm cao cấp',
      customer: 'Phú Quý',
      address: '420 Ngô Thời Nhiệm, Phường 7, Quận 3, Thành Phố Hồ Chí Minh',
      time: '16:00'),
  Task(
      taskname: 'Trả ảnh',
      package: 'Gói chụp ảnh kỷ yếu cơ bản',
      customer: 'Lan Anh',
      address: 'THPT Phú Nhuận, Thành phố Hồ Chí Minh',
      time: '18:00'),
];
