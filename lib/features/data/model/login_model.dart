class LoginModel {
  final String phone_number;
  final String password;

  LoginModel({required this.phone_number, required this.password});
  
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phone_number,
      'password': password
    };
  }
}