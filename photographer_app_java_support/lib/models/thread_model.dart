import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Thread extends Equatable {
  int id;
  String title;
  String content;
  String createdAt;
  String updatedAt;
  Owner owner;
  Topic topic;
  List<ThreadComment> comments;

  Thread(
      {this.id,
      this.title,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.owner,
      this.topic,
      this.comments});

  @override
  List<Object> get props => throw UnimplementedError();

  Thread.fromJson(json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    topic = json['topic'] != null ? new Topic.fromJson(json['topic']) : null;
    if (json['comments'] != null) {
      comments = new List<ThreadComment>();
      json['comments'].forEach((v) {
        comments.add(new ThreadComment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    if (this.topic != null) {
      data['topic'] = this.topic.toJson();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Owner {
  int id;
  String username;
  String fullname;
  String description;
  String avatar;
  String cover;
  int booked;
  String phone;
  String email;
  double ratingCount;
  String deviceToken;

  Owner(
      {this.id,
      this.username,
      this.fullname,
      this.description,
      this.avatar,
      this.cover,
      this.booked,
      this.phone,
      this.email,
      this.ratingCount,
      this.deviceToken});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullname = json['fullname'];
    description = json['description'];
    avatar = json['avatar'];
    cover = json['cover'];
    booked = json['booked'];
    phone = json['phone'];
    email = json['email'];
    ratingCount = json['ratingCount'];
    deviceToken = json['deviceToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['fullname'] = this.fullname;
    data['description'] = this.description;
    data['avatar'] = this.avatar;
    data['cover'] = this.cover;
    data['booked'] = this.booked;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['ratingCount'] = this.ratingCount;
    data['deviceToken'] = this.deviceToken;
    return data;
  }
}

class Topic {
  int id;
  String topic;
  String createdBy;
  String createdAt;
  String updatedAt;

  Topic({this.id, this.topic, this.createdBy, this.createdAt, this.updatedAt});

  Topic.fromJson(json) {
    id = json['id'];
    topic = json['topic'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic'] = this.topic;
    data['createdBy'] = this.createdBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class ThreadComment {
  int id;
  String comment;
  String createdAt;
  String updatedAt;
  Owner owner;
  Thread thread;

  ThreadComment(
      {this.id,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.owner,
      this.thread});

  ThreadComment.fromJson(json) {
    id = json['id'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    thread =
        json['thread'] != null ? new Thread.fromJson(json['thread']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    if (this.thread != null) {
      data['thread'] = this.thread.toJson();
    }
    return data;
  }
}
