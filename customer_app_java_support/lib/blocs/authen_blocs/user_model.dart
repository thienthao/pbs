class User {
  final id;
  final String username;
  final String email;
  final String accessToken;

  User({this.id, this.username, this.email, this.accessToken});

  factory User.fromDatabaseJson(Map<String, dynamic> data) => User(
    id: data['id'],
    username: data['username'],
    email: data['email'],
    accessToken: data['accessToken']
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": this.id,
    "username": this.username,
    "email": this.email,
    "accessToken": this.accessToken,
  };
}