class Comment {
  String dateCreated;
  String location;
  double rating;
  String comment;
  String commentorName;
  String avatar;

  Comment({
    this.dateCreated,
    this.location,
    this.rating,
    this.comment,
    this.commentorName,
    this.avatar,
  });
}

List<Comment> comments = [
  Comment(
      avatar: 'assets/images/portrait_2.jpg',
      comment: 'Anh photograph chụp hình rất đẹp và chuyên nghiệp. ',
      commentorName: 'Xảo Liên',
      dateCreated: '30/09/2020',
      location: 'Đà Lạt',
      rating: 5),
  Comment(
      avatar: 'assets/images/image1.png',
      comment:
      'Thực sự khó có thể nào tìm được một photographer có chuyên môn tốt mà lại tính phí rẻ như thế này',
      commentorName: 'Nguyên Phước Uy Long',
      dateCreated: '25/09/2020',
      location: 'Lâm Đồng',
      rating: 4),
  Comment(
      avatar: 'assets/images/image2.png',
      comment:
      'Tác phong làm việc chuyên nghiệp, chụp đẹp, hỗ trợ nhiệt tình nhưng hơi trễ một chút',
      commentorName: 'Đình Ngọc',
      dateCreated: '23/09/2020',
      location: 'Hồ Chí Minh',
      rating: 4),
];
