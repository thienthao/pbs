import 'package:equatable/equatable.dart';

class NotificationBlocModel extends Equatable {
  final int id;
  final String title;
  final String content;
  final String notificationType;
  final String createdAt;
  final int receiverId;
  final bool isRead;
  final int bookingId;

  NotificationBlocModel(
      {this.id,
      this.title,
      this.content,
      this.notificationType,
      this.createdAt,
      this.receiverId,
      this.isRead,
      this.bookingId});
  @override
  List<Object> get props => [
        id,
        title,
        content,
        notificationType,
        createdAt,
        receiverId,
        isRead,
        bookingId
      ];
}
