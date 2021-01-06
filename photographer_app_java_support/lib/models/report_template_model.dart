class ReportTemplateModel{
  int id;
  String title;

  ReportTemplateModel({this.id, this.title});
}

List<ReportTemplateModel> reports = [
  ReportTemplateModel(
    id: 01,
    title: 'Khách hàng không đến.',
  ),
  ReportTemplateModel(
    id: 02,
    title: 'Khách hàng đến muộn.',
  ),
  ReportTemplateModel(
    id: 03,
    title: 'Thái độ tiêu cực.',
  ),
  ReportTemplateModel(
    id: 04,
    title: 'Phỉ báng và lăng mạ.',
  ),
  ReportTemplateModel(
    id: 05,
    title: 'Khác.',
  ),
];