abstract class AuthEvents {}

class LoginEvent extends AuthEvents {
  String email;
  String password;
  bool isRemember;
  LoginEvent(this.email, this.password,this.isRemember );
}

class RegisterEvent extends AuthEvents {
  String email;
  String password;
  RegisterEvent(this.email, this.password);
}

class LogoutEvent extends AuthEvents {}
