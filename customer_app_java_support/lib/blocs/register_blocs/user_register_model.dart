class UserRegister {
  String username;
  String password;
  String email;
  String role;

  UserRegister({this.username, this.password, this.email});

  Map<String, dynamic> toDatabaseJson() => {
    "username": this.username,
    "password": this.password,
    "email": this.email,
    "role": "ROLE_CUSTOMER",
  };
}