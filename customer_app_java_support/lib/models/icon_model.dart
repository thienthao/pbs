class IconCateg {
  String iconUrl;
  String name;

  IconCateg({
    this.iconUrl,
    this.name,
  });
}

final List<IconCateg> iconCategs = [
  IconCateg(
    iconUrl: 'assets/icons/camera-portrait-mode.svg',
    name: 'Chân dung',
  ),
  IconCateg(
    iconUrl: 'assets/icons/cosplayer.svg',
    name: 'Cosplay',
  ),
  IconCateg(
    iconUrl: 'assets/icons/furnitures.svg',
    name: 'Nội thất',
  ),
  IconCateg(
    iconUrl: 'assets/icons/photo.svg',
    name: 'Kỷ yếu',
  ),
  IconCateg(
    iconUrl: 'assets/icons/wedding-ring.svg',
    name: 'Ảnh cưới',
  ),
];