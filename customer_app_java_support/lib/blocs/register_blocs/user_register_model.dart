class UserRegister {
  String username;
  String email;
  String password;
  String role;
  String fullname;
  String phone;

  UserRegister(
      {this.username, this.email, this.password, this.fullname, this.phone});

  Map<String, dynamic> toDatabaseJson() => {
        "username": this.username,
        "password": this.password,
        "email": this.email,
        "fullname": this.fullname,
        "phone": this.phone,
        "role": "ROLE_CUSTOMER"
      };
}
