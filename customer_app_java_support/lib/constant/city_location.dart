import 'package:google_maps_flutter/google_maps_flutter.dart';

class CityLocation {
  int id;
  String name;
  LatLng latLng;
  String image;
  CityLocation({
    this.id,
    this.name,
    this.latLng,
    this.image,
  });
}

List<CityLocation> listCityLocations = [
  CityLocation(
      id: 1,
      name: 'Thành phố Hồ Chí Minh',
      latLng: LatLng(10.762622, 106.660172),
      image:
          'https://dulichkhampha24.com/wp-content/uploads/2020/01/cho-ben-thanh-sai-gon-10.jpg'),
  CityLocation(
      id: 2,
      name: 'Hà Nội',
      latLng: LatLng(21.027763, 105.834160),
      image:
          'https://www.35express.org/wp-content/uploads/2020/01/Hinh-anh-Thap-Rua-o-Ha-Noi-dep-ngat-ngay-1.jpg'),
  CityLocation(
      id: 3,
      name: 'Hải Phòng',
      latLng: LatLng(20.865139, 106.683830),
      image:
          'https://camnanghaiphong.vn/upload/camnanghaiphong/images/hvt.jpg'),
  CityLocation(
      id: 4,
      name: 'Đà Nẵng',
      latLng: LatLng(16.047079, 108.206230),
      image:
          'https://img3.thuthuatphanmem.vn/uploads/2019/07/13/anh-dep-cau-rong-da-nang-phun-nuoc_085826155.jpg'),
  CityLocation(
      id: 5,
      name: 'Cần Thơ',
      latLng: LatLng(10.045162, 105.746857),
      image:
          'https://lh3.googleusercontent.com/proxy/v7CKAqaowuZDINX1y2EyLV6ySWnGO4fC5qSUKmuA_PxxnhSeKPkn9PmOX7RzU7PoOR195SaPqEJn7GyWqdCzpq0GRE4Y-8xP7p-sPxapDnXQflU'),
  CityLocation(
      id: 6,
      name: 'Phú Yên',
      latLng: LatLng(13.16667, 109.08333),
      image:
          'https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/08/thap-nhan-2.jpg'),
  CityLocation(
      id: 7,
      name: 'Yên Bái',
      latLng: LatLng(21.716768, 104.898590),
      image:
          'https://lh3.googleusercontent.com/proxy/-LsZGqVO-qq3lWRi7zqVP2aOLGkpSBdOsIbRC7utv45kx9tZMPuJZ_YDt-Map0ZlJDQ6suGMjtJPwwuo9ZhT8MDbl1Cux89ldDhSrQwkkashBOSU2ed2yisQ4QY5aoTw1yZjEJtE2cF3vxDAhk9FjnhuCq2cgJV9a1X5JkA'),
  CityLocation(
      id: 8,
      name: 'Vĩnh Phúc',
      latLng: LatLng(21.33333, 105.56667),
      image:
          'https://thuenhadulich.vn/wp-content/uploads/2019/06/du-lich-tam-dao-vinh-phuc-cho-cap-doi.jpg'),
  CityLocation(
      id: 9,
      name: 'Vĩnh Long',
      latLng: LatLng(10.25369, 105.9722),
      image:
          'https://toplist.vn/images/800px/dia-diem-du-lich-o-vinh-long-309359.jpg'),
  CityLocation(
      id: 10,
      name: 'Tuyên Quang',
      latLng: LatLng(21.8166634, 105.2166658),
      image:
          'https://images.baodantoc.vn/uploads/2019/Ngay09thang11/Aaaaaaaa1.jpg'),
  CityLocation(
      id: 11,
      name: 'Trà Vinh',
      latLng: LatLng(9.94719, 106.34225),
      image:
          'https://imagesfb.tintuc.vn/upload/images/travinh/20170905/bo5.jpg'),
  CityLocation(
      id: 12,
      name: 'Tiền Giang',
      latLng: LatLng(10.484436, 106.362572),
      image:
          'https://dulichtoday.vn/wp-content/uploads/2019/04/du-lich-tien-giang-9.png'),
  CityLocation(
      id: 13,
      name: 'Thừa Thiên Huế',
      latLng: LatLng(16.463713, 107.590866),
      image: 'https://i.ytimg.com/vi/xNFtlkYdUUI/hqdefault.jpg'),
  CityLocation(
      id: 14,
      name: 'Thanh Hóa',
      latLng: LatLng(19.8, 105.76667),
      image:
          'https://dulichchaovietnam.com/public/fileupload/source/sanpham/thanh-hoa/sam-son-4.jpg'),
  CityLocation(
      id: 15,
      name: 'Thái Nguyên',
      latLng: LatLng(21.59422, 105.84817),
      image:
          'https://cungphuot.info/wp-content/uploads/2017/07/cac-dia-diem-du-lich-o-thai-nguyen.jpg'),
  CityLocation(
      id: 16,
      name: 'Thái Bình',
      latLng: LatLng(20.45, 106.34002),
      image:
          'https://lendang.vn/uploads/articles/articles_1453796452_d9b854dfdefa82ce39a40c85d2a374e1.jpg'),
  CityLocation(
      id: 17,
      name: 'Tây Ninh',
      latLng: LatLng(11.31004, 106.09828),
      image:
          'https://timchuyenbay.com/assets/uploads/2019/09/%C4%90i%CC%A3a-%C4%91ie%CC%82%CC%89m-du-li%CC%A3ch-Ta%CC%82y-Ninh-1.jpg'),
  CityLocation(
      id: 18,
      name: 'Sơn La',
      latLng: LatLng(21.3256, 103.91882),
      image:
          'https://tptravel.com.vn/mediacenter/media/images/1850/news/ava/s900_0/du-lich-moc-chau-tptravel-mua-hoa-cai-1539857152.png'),
  CityLocation(
      id: 19,
      name: 'Sóc Trăng',
      latLng: LatLng(9.59995, 105.97193),
      image:
          'https://travelgear.vn/blog/wp-content/uploads/2019/05/soc-trang-co-gi-choi-8-min.jpg'),
  CityLocation(
      id: 20,
      name: 'Quảng Trị',
      latLng: LatLng(16.75, 107.0),
      image:
          'https://bizweb.dktcdn.net/100/027/217/files/thanh-co-quang-tri-cda1d936-f7d7-4853-8cfd-d6cbeeb6ad1d.jpg?v=1470452425055'),
  CityLocation(
      id: 21,
      name: 'Quảng Ninh',
      latLng: LatLng(20.959902, 107.042542),
      image:
          'https://vnn-imgs-f.vgcloud.vn/2018/11/29/14/nam-du-lich-quoc-gia-quang-ninh-hut-khach-suot-nam.jpg'),
  CityLocation(
      id: 22,
      name: 'Quảng Ngãi',
      latLng: LatLng(15.12047, 108.79232),
      image:
          'https://dulichvietnam.com.vn/vnt_upload/news/08_2019/khung-canh-xanh-muot-cua-quang-ngai-nhin-tu-tren-cao-9.jpg2.jpg'),
  CityLocation(
      id: 23,
      name: 'Quảng Nam',
      latLng: LatLng(15.901141, 108.079628),
      image: '_image'),
  CityLocation(
      id: 24,
      name: 'Quảng Bình',
      latLng: LatLng(17.5, 106.33333),
      image: '_image'),
  CityLocation(
      id: 25,
      name: 'Phú Thọ',
      latLng: LatLng(21.33333, 105.13333),
      image: '_image'),
  CityLocation(
      id: 26,
      name: 'Ninh Thuận',
      latLng: LatLng(11.75, 108.83333),
      image: '_image'),
  CityLocation(
      id: 27,
      name: 'Ninh Bình',
      latLng: LatLng(20.25809, 105.97965),
      image: '_image'),
  CityLocation(
      id: 28,
      name: 'Nghệ An',
      latLng: LatLng(18.787203, 105.605202),
      image: '_image'),
  CityLocation(
      id: 29,
      name: 'Nam Định',
      latLng: LatLng(20.43389, 106.17729),
      image: '_image'),
  CityLocation(
      id: 30,
      name: 'Long An',
      latLng: LatLng(10.695572, 106.243121),
      image: '_image'),
  CityLocation(
      id: 31,
      name: 'Lào Cai',
      latLng: LatLng(22.48556, 103.97066),
      image: '_image'),
  CityLocation(
      id: 32,
      name: 'Lạng Sơn',
      latLng: LatLng(21.85264, 106.76101),
      image: '_image'),
  CityLocation(
      id: 33,
      name: 'Lâm Đồng',
      latLng: LatLng(11.94646, 108.44193),
      image:
          'https://d13jio720g7qcs.cloudfront.net/images/destinations/origin/5ccac30400a47.png'),
  CityLocation(
      id: 34,
      name: 'Lai Châu',
      latLng: LatLng(22.39644, 103.45824),
      image: '_image'),
  CityLocation(
      id: 35,
      name: 'Kon Tum',
      latLng: LatLng(14.35451, 108.00759),
      image: '_image'),
  CityLocation(
      id: 36,
      name: 'Kiên Giang',
      latLng: LatLng(9.824959, 105.125893),
      image: '_image'),
  CityLocation(
      id: 37,
      name: 'Khánh Hòa',
      latLng: LatLng(0012.33333, 109.00000000),
      image: '_image'),
  CityLocation(
      id: 38,
      name: 'Hưng Yên',
      latLng: LatLng(20.64637, 106.05112),
      image: '_image'),
  CityLocation(
      id: 39,
      name: 'Hòa Bình',
      latLng: LatLng(20.81717, 105.33759),
      image: '_image'),
  CityLocation(
      id: 40,
      name: 'Hậu Giang',
      latLng: LatLng(9.77605, 105.46412),
      image: '_image'),
  CityLocation(
      id: 41,
      name: 'Hải Dương',
      latLng: LatLng(20.94099, 106.33302),
      image: '_image'),
  CityLocation(
      id: 42,
      name: 'Hà Tĩnh',
      latLng: LatLng(18.34282, 105.90569),
      image: '_image'),
  CityLocation(
      id: 43,
      name: 'Hà Nam',
      latLng: LatLng(20.53333, 105.96667),
      image: '_image'),
  CityLocation(
      id: 44,
      name: 'Hà Giang',
      latLng: LatLng(22.82333, 104.98357),
      image: '_image'),
  CityLocation(
      id: 45,
      name: 'Gia Lai',
      latLng: LatLng(13.7964067, 108.2608263),
      image: '_image'),
  CityLocation(
      id: 46,
      name: 'Đồng Tháp',
      latLng: LatLng(10.493799, 105.688179),
      image: '_image'),
  CityLocation(
      id: 47,
      name: 'Đồng Nai',
      latLng: LatLng(10.964112, 106.856461),
      image: '_image'),
  CityLocation(
      id: 48,
      name: 'Điện Biên',
      latLng: LatLng(21.626793, 103.158875),
      image: '_image'),
  CityLocation(
      id: 49,
      name: 'Đắk Nông',
      latLng: LatLng(12.264648, 107.609806),
      image: '_image'),
  CityLocation(
      id: 50,
      name: 'Đắk Lắk',
      latLng: LatLng(12.710012, 108.237752),
      image: '_image'),
  CityLocation(
      id: 51,
      name: 'Cao Bằng',
      latLng: LatLng(22.679281, 106.260452),
      image: '_image'),
  CityLocation(
      id: 52,
      name: 'Cà Mau',
      latLng: LatLng(9.17682, 105.15242),
      image: '_image'),
  CityLocation(
      id: 53,
      name: 'Bình Thuận',
      latLng: LatLng(11.317883, 108.657959),
      image: '_image'),
  CityLocation(
      id: 54,
      name: 'Bình Phước',
      latLng: LatLng(11.751189, 106.723464),
      image: '_image'),
  CityLocation(
      id: 55,
      name: 'Bình Dương',
      latLng: LatLng(11.16667, 106.66667),
      image: '_image'),
  CityLocation(
      id: 56,
      name: 'Bình Định',
      latLng: LatLng(13.782967, 109.219663),
      image: '_image'),
  CityLocation(
      id: 57,
      name: 'Bến Tre',
      latLng: LatLng(10.24147, 106.37585),
      image: '_image'),
  CityLocation(
      id: 58,
      name: 'Bắc Ninh',
      latLng: LatLng(21.18608, 106.07631),
      image: '_image'),
  CityLocation(
      id: 59,
      name: 'Bạc Liêu',
      latLng: LatLng(9.29414, 105.72776),
      image: '_image'),
  CityLocation(
      id: 60,
      name: 'Bắc Kạn',
      latLng: LatLng(22.14701, 105.83481),
      image: '_image'),
  CityLocation(
      id: 61,
      name: 'Bắc Giang',
      latLng: LatLng(21.27307, 106.1946),
      image: '_image'),
  CityLocation(
      id: 62,
      name: 'Bà Rịa - Vũng Tàu',
      latLng: LatLng(10.499998, 107.166666),
      image:
          'https://image.vietnamnews.vn/uploadvnnews/Article/2020/2/5/66146_VTAU.jpg'),
  CityLocation(
      id: 63,
      name: 'An Giang',
      latLng: LatLng(10.521584, 105.125896),
      image: '_image'),
];
