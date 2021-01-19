class UserRegister {
  String username;
  String email;
  String password;
  String role;
  String fullname;
  String phone;

  UserRegister({this.username, this.email, this.password, this.phone, this.fullname});

  Map<String, dynamic> toDatabaseJson() => {
        "username": this.username,
        "password": this.password,
        "email": this.email,
        "phone": this.phone,
        "fullname":this.fullname,
        "role": "ROLE_PHOTOGRAPHER"
      };
}
