class Album {
  String imageUrl;
  String title;
  String categories;
  String dateCreated;
  String location;
  String description;
  int ratingNum;
  String avatarUrl;
  String ptgname;
  List<String> images;

  Album({
    this.imageUrl,
    this.title,
    this.categories,
    this.dateCreated,
    this.location,
    this.description,
    this.ratingNum,
    this.ptgname,
    this.avatarUrl,
    this.images,
  });
}

List<Album> albums = [
  Album(
    imageUrl: 'assets/albums/cosplay/cosplay05.jpg',
    title: 'Evergarden',
    categories: 'Cosplay',
    dateCreated: '28/06/2016',
    location: 'Đà Lạt',
    description: '',
    ratingNum: 182,
    avatarUrl: 'assets/avatars/man06.jpg',
    ptgname: 'Quang Huy',
    images: [
      'assets/albums/cosplay/cosplay05.jpg',
      'assets/albums/cosplay/cosplay01.jpg',
      'assets/albums/cosplay/cosplay02.jpg',
      'assets/albums/cosplay/cosplay03.jpg',
      'assets/albums/cosplay/cosplay04.jpg',
      'assets/albums/cosplay/cosplay06.jpg',
      'assets/albums/cosplay/cosplay07.jpg',
      'assets/albums/cosplay/cosplay08.jpg',
      'assets/albums/cosplay/cosplay09.jpg',
    ],
  ),
  Album(
    imageUrl: 'assets/albums/wedding/wedding01.jpg',
    title: 'Anh và Em',
    categories: 'Ảnh cưới',
    dateCreated: '15/02/2019',
    location: 'Hà Nội',
    description:
    '',
    ratingNum: 981,
    avatarUrl: 'assets/avatars/man05.jpg',
    ptgname: 'Nhật Thiên',
    images: [
      'assets/albums/wedding/wedding01.jpg',
      'assets/albums/wedding/wedding02.jpg',
      'assets/albums/wedding/wedding03.jpg',
      'assets/albums/wedding/wedding04.jpg',
      'assets/albums/wedding/wedding05.jpg',
      'assets/albums/wedding/wedding06.jpg',
      'assets/albums/wedding/wedding07.jpg',
    ],
  ),
  Album(
    imageUrl: 'assets/albums/kyyeu/kyyeu01.jpg',
    title: '12A3 Gia Định',
    categories: 'Kỷ yếu',
    dateCreated: '20/03/2020',
    location: 'Hồ Chí Minh',
    description: '',
    ratingNum: 842,
    avatarUrl: 'assets/avatars/man04.jpeg',
    ptgname: 'Đại Thành',
    images: [
      'assets/albums/kyyeu/kyyeu01.jpg',
      'assets/albums/kyyeu/kyyeu02.jpg',
      'assets/albums/kyyeu/kyyeu03.jpg',
      'assets/albums/kyyeu/kyyeu04.jpg',
      'assets/albums/kyyeu/kyyeu05.jpg',
      'assets/albums/kyyeu/kyyeu06.jpg',
      'assets/albums/kyyeu/kyyeu07.jpg',
      'assets/albums/kyyeu/kyyeu08.jpg',
    ],
  ),
  Album(
    imageUrl: 'assets/albums/kientruc/kientruc01.jpg',
    title: 'Bel-Air',
    categories: 'Kiến trúc',
    dateCreated: '04/09/2017',
    location: 'Đà Nẵng',
    description: '',
    ratingNum: 2408,
    avatarUrl: 'assets/avatars/man03.jpg',
    ptgname: 'Minh Khoa',
    images: [
      'assets/albums/kientruc/kientruc01.jpg',
      'assets/albums/kientruc/kientruc02.jpg',
      'assets/albums/kientruc/kientruc03.jpg',
      'assets/albums/kientruc/kientruc04.jpg',
      'assets/albums/kientruc/kientruc05.jpg',
      'assets/albums/kientruc/kientruc06.jpg',
      'assets/albums/kientruc/kientruc07.jpg',
      'assets/albums/kientruc/kientruc08.jpg',
      'assets/albums/kientruc/kientruc09.jpg',
    ],
  ),
  Album(
    imageUrl: 'assets/albums/sanpham01/sanpham01_01.jpg',
    title: 'Beosound 1',
    categories: 'Sản phẩm',
    dateCreated: '30/12/2018',
    location: 'Hồ Chí Minh',
    description: '',
    ratingNum: 1023,
    avatarUrl: 'assets/avatars/man02.jpg',
    ptgname: 'Lê Bình',
    images: [
      'assets/albums/sanpham01/sanpham01_01.jpg',
      'assets/albums/sanpham01/sanpham01_02.jpg',
      'assets/albums/sanpham01/sanpham01_03.jpg',
      'assets/albums/sanpham01/sanpham01_04.jpg',
    ],
  ),
  Album(
    imageUrl: 'assets/albums/sanpham02/sanpham02_01.jpg',
    title: 'Bang & Oluffson',
    categories: 'Sản phẩm',
    dateCreated: '30/12/2018',
    location: 'Hồ Chí Minh',
    description: '',
    ratingNum: 1023,
    avatarUrl: 'assets/avatars/man02.jpg',
    ptgname: 'Lê Bình',
    images: [
      'assets/albums/sanpham02/sanpham02_01.jpg',
      'assets/albums/sanpham02/sanpham02_02.jpg',
      'assets/albums/sanpham02/sanpham02_03.jpg',
      'assets/albums/sanpham02/sanpham02_04.jpg',
    ],
  ),
];
