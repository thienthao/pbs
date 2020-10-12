class Picture {
  String imageUrl;
  String picname;
  String avatarUrl;
  String ptgname;
  int rating;
  String type;

  Picture({
    this.imageUrl,
    this.picname,
    this.type,
    this.avatarUrl,
    this.ptgname,
    this.rating,
  });
}

List<Picture> pictures = [
  Picture(
    imageUrl: 'assets/albums/illusion.jpg',
    picname: 'Ảo tưởng',
    type: 'Nội thất',
    avatarUrl: 'assets/avatars/mie.jpeg',
    ptgname: 'Ly Phạm',
    rating: 3,
  ),
  Picture(
    imageUrl: 'assets/albums/image_of_album_3.jpg',
    picname: 'Thiếu nữ',
    type: 'Kỷ Yếu',
    avatarUrl: 'assets/avatars/canon.jpg',
    ptgname: 'Ngọc Mỹ',
    rating: 3,
  ),
  Picture(
    imageUrl: 'assets/albums/portrait_1.jpg',
    picname: 'Anh và Em',
    type: 'Ảnh cưới',
    avatarUrl: 'assets/avatars/jvna.jpeg',
    ptgname: 'Anh Thư',
    rating: 3,
  ),
];