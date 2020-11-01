class Service {
  String name;
  int time;
  int price;
  List<String> tasks;

  Service({
    this.name,
    this.time,
    this.price,
    this.tasks,
  });
}
List<Service> services = [
  Service(
    name: 'Gói chụp ảnh thời trang cơ bản',
    time: 3,
    price: 800000,
    tasks: ['Free 01 áo dài hoặc trang phục tùy chọn', 'Free Makeup, làm tóc', 'Được chụp từ 150-200 file', 'Photoshop 25 ảnh', 'Tặng 10 ảnh ép lụa'],
  ),
  Service(
    name: 'Gói chụp ảnh thời trang nâng cao',
    time: 5,
    price: 1200000,
    tasks: [
      'Free 01 áo dài hoặc trang phục tùy chọn', 'Free Makeup, làm tóc', 'Được chụp từ 200-400 file', 'Photoshop 40 ảnh', 'Tặng 20 ảnh ép lụa', 'Tặng 1 ảnh để bàn pha lê'
    ],
  ),
  Service(
    name: 'Gói chụp ảnh thời trang cao cấp',
    time: 6,
    price: 3500000,
    tasks: [
      'Free 01 áo dài hoặc trang phục tùy chọn', 'Free Makeup, làm tóc', 'Được chụp từ 200-500 file', 'Photoshop 50 ảnh', 'Tặng 20 ảnh ép lụa', 'Tặng 1 ảnh để bàn pha lê', 'Tặng 1 ảnh ép gỗ', 'Tặng 1 album chất liệu Hàn Quốc'
    ],
  )
];
