class LoginModel {
  final String username;
  final String password;
  final String platform;
  final String version;

  LoginModel({required this.username, required this.password, required this.platform, required this.version});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'platform': platform,
      'version': version,
    };
  }
}