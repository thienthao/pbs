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
      latLng: LatLng(0.0, 0.0),
      image:
          'https://dulichkhampha24.com/wp-content/uploads/2020/01/cho-ben-thanh-sai-gon-10.jpg'),
  CityLocation(
      id: 2,
      name: 'Hà Nội',
      latLng: LatLng(0.0, 0.0),
      image:
          'https://www.35express.org/wp-content/uploads/2020/01/Hinh-anh-Thap-Rua-o-Ha-Noi-dep-ngat-ngay-1.jpg'),
  CityLocation(
      id: 3,
      name: 'Hải Phòng',
      latLng: LatLng(0.0, 0.0),
      image:
          'https://camnanghaiphong.vn/upload/camnanghaiphong/images/hvt.jpg'),
  CityLocation(
      id: 4,
      name: 'Đà Nẵng',
      latLng: LatLng(0.0, 0.0),
      image:
          'https://img3.thuthuatphanmem.vn/uploads/2019/07/13/anh-dep-cau-rong-da-nang-phun-nuoc_085826155.jpg'),
  CityLocation(
      id: 5, name: 'Cần Thơ', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 6, name: 'Phú Yên', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 7, name: 'Yên Bái', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 8, name: 'Vĩnh Phúc', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 9, name: 'Vĩnh Long', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 10, name: 'Tuyên Quang', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 11, name: 'Trà Vinh', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 12, name: 'Tiền Giang', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 13,
      name: 'Thừa Thiên Huế',
      latLng: LatLng(0.0, 0.0),
      image: '_image'),
  CityLocation(
      id: 14, name: 'Thanh Hóa', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 15, name: 'Thái Nguyên', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 16, name: 'Thái Bình', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 17, name: 'Tây Ninh', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 18, name: 'Sơn La', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 19, name: 'Sóc Trăng', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 20, name: 'Quảng Trị', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 21, name: 'Quảng Ninh', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 22, name: 'Quảng Ngãi', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 23, name: 'Quảng Nam', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 24, name: 'Quảng Bình', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 25, name: 'Phú Thọ', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 26, name: 'Ninh Thuận', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 27, name: 'Ninh Bình', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 28, name: 'Nghệ An', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 29, name: 'Nam Định', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 30, name: 'Long An', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 31, name: 'Lào Cai', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 32, name: 'Lạng Sơn', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 33, name: 'Lâm Đồng', latLng: LatLng(0.0, 0.0), image: '_image'),
  CityLocation(
      id: 34, name: 'Lai Châu', latLng: LatLng(0.0, 0.0), image: '_image'),
];
