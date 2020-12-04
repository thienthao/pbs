class UserRegister {
  String username;
  String email;
  String password;
  String role;

  UserRegister({this.username, this.email, this.password});

  Map<String, dynamic> toDatabaseJson() => {
        "username": this.username,
        "password": this.password,
        "email": this.email,
        "role": "ROLE_CUSTOMER"
      };
}
