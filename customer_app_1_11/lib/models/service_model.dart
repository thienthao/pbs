class Service {
  String name;
  int time;
  int price;
  String description;
  List<String> tasks;

  Service({
    this.name,
    this.time,
    this.price,
    this.tasks,
    this.description,
  });
}

List<Service> services = [
  Service(
    name: 'GÓI CHỤP 1 NGƯỜI',
    time: 1,
    price: 1490000,
    description:
        'Chụp ảnh cổ trang có rất nhiều dịch vụ chụp ảnh khác nhau, do đó bạn có thể chọn gói chụp theo nhu cầu hoặc mức kinh phí có sẵn',
    tasks: [
      'Khách được chụp 3 trang phục/người',
      'Khách nhận toàn bộ ảnh gốc (khoảng 100-200 ảnh) và 30 ảnh chỉnh sửa'
    ],
  ),
  Service(
    name: 'GÓI CHỤP NHÓM (Giá / người)',
    time: 1,
    price: 800000,
    tasks: [
      'Giá in kỷ yếu photobook rẻ nhất TPHCM',
      'Free hoa đội đầu và hoa cầm tay cho các bạn nữ trong lớp.',
      'Free caravat cho các bạn nam.',
      'Chụp không giới hạn số lượng ảnh'
    ],
  ),
  Service(
    name: 'Gói chụp ảnh thời trang cao cấp',
    time: 2,
    price: 3500000,
    tasks: [
      'Free 01 áo dài hoặc trang phục tùy chọn',
      'Free Makeup, làm tóc',
      'Được chụp từ 200-500 file',
      'Photoshop 50 ảnh',
      'Tặng 20 ảnh ép lụa',
      'Tặng 1 ảnh để bàn pha lê',
      'Tặng 1 ảnh ép gỗ',
      'Tặng 1 album chất liệu Hàn Quốc'
    ],
  )
];

List<Service> servicesbU = [
  Service(
    name: 'Gói chụp ảnh thời trang cơ bản',
    time: 1,
    price: 800000,
    tasks: [
      'Free 01 áo dài hoặc trang phục tùy chọn',
      'Free Makeup, làm tóc',
      'Được chụp từ 150-200 file',
      'Photoshop 25 ảnh',
      'Tặng 10 ảnh ép lụa'
    ],
  ),
  Service(
    name: 'Gói chụp ảnh thời trang nâng cao',
    time: 1,
    price: 1200000,
    tasks: [
      'Free 01 áo dài hoặc trang phục tùy chọn',
      'Free Makeup, làm tóc',
      'Được chụp từ 200-400 file',
      'Photoshop 40 ảnh',
      'Tặng 20 ảnh ép lụa',
      'Tặng 1 ảnh để bàn pha lê'
    ],
  ),
  Service(
    name: 'Gói chụp ảnh thời trang cao cấp',
    time: 2,
    price: 3500000,
    tasks: [
      'Free 01 áo dài hoặc trang phục tùy chọn',
      'Free Makeup, làm tóc',
      'Được chụp từ 200-500 file',
      'Photoshop 50 ảnh',
      'Tặng 20 ảnh ép lụa',
      'Tặng 1 ảnh để bàn pha lê',
      'Tặng 1 ảnh ép gỗ',
      'Tặng 1 album chất liệu Hàn Quốc'
    ],
  )
];
