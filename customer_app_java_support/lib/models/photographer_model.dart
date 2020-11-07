class Photographer {
  String avatarUrl;
  String ptgname;
  String coverUrl;
  String description;
  int bookingNumber;
  String email;
  String phone;
  double rating;

  Photographer({
    this.avatarUrl,
    this.ptgname,
    this.coverUrl,
    this.description,
    this.bookingNumber,
    this.rating,
    this.email,
    this.phone,
  });
}

List<Photographer> photographers = [
  Photographer(
    avatarUrl: 'assets/avatars/man02.jpg',
    ptgname: 'Quang Huy',
    coverUrl: 'assets/images/venice.jpg',
    bookingNumber: 100,
    description: 'Tôi chuyên sản xuất dịch vụ hình ảnh cho các doanh nghiệp nhỏ, vừa và kể cả quy mô lớn.',
    email: 'abc@xyz.com',
    phone: '012345678',
    rating: 4.9,
  ),
  Photographer(
    avatarUrl: 'assets/avatars/man06.jpg',
    ptgname: 'Lê Bình',
    coverUrl: 'assets/images/venice.jpg',
    bookingNumber: 200,
    description: 'Linh chuyên thực hiện và quản lý hình ảnh của các đơn vị là tổ chức và doanh nghiệp, các cá nhân là nghệ sỹ cũng như các bạn yêu thích nghệ thuật.',
    email: 'abc@xyz.com',
    phone: '012345678',
    rating: 4.5,
  ),
  Photographer(
    avatarUrl: 'assets/avatars/man03.jpg',
    ptgname: 'Minh Khoa',
    coverUrl: 'assets/images/venice.jpg',
    bookingNumber: 300,
    description: 'Chụp ảnh chân dung cá nhân theo style màu sáng hoặc đậm màu kiểu Âu',
    email: 'abc@xyz.com',
    phone: '012345678',
    rating: 4.5,
  ),
  Photographer(
    avatarUrl: 'assets/avatars/man04.jpeg',
    ptgname: 'Đại Thành',
    coverUrl: 'assets/images/venice.jpg',
    bookingNumber: 300,
    description: 'Sử dụng ngôn ngữ là hình ảnh, công cụ là máy móc và cảm hứng là chính khách hàng, tôi đem đến những tấm hình chân thực và đẹp đẽ nhất.',
    email: 'abc@xyz.com',
    phone: '012345678',
    rating: 4.5,
  ),
  Photographer(
    avatarUrl: 'assets/avatars/man05.jpg',
    ptgname: 'Nhật Thiên',
    coverUrl: 'assets/images/newyork.jpg',
    bookingNumber: 300,
    description: 'Thiên đã chụp chân dung nghề nghiệp cho hàng nghìn người, tham gia xây dựng hàng chục thư viện hình ảnh cho doanh nghiệp cũng như ghi lại những khoảnh khắc quan trọng nhất của hàng trăm sự kiện.',
    email: 'abc@xyz.com',
    phone: '012345678',
    rating: 4.4,
  ),
  Photographer(
    avatarUrl: 'assets/avatars/man01.jpg',
    ptgname: 'Huy Thức',
    coverUrl: 'assets/images/gondola.jpg',
    bookingNumber: 300,
    description: 'Nắm bắt được tâm lý của khách hàng, hiểu được tầm quan trọng để lưu giữ lại những khoảnh khắc đẹp trong tình yêu.',
    email: 'abc@xyz.com',
    phone: '012345678',
    rating: 4.3,
  ),
];