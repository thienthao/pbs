import 'package:equatable/equatable.dart';

class ReportBlocModel extends Equatable {
  final int id;
  final String title;
  final String reason;
  final int reporterId;
  final int reportedId;
  final String createdAt;

  const ReportBlocModel({
    this.id,
    this.title,
    this.reason,
    this.reporterId,
    this.reportedId,
    this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        title,
        reason,
        reporterId,
        reportedId,
        createdAt,
      ];
}
