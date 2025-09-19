
extension StringValidation on String{
  bool isValidEmail(){
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool isValidPhone(){
    return RegExp(r'^[0-9]{10}$').hasMatch(this);
  }
  bool isValidEmailOrPhone(){
    return isValidEmail() || isValidPhone();
  }
  bool isValidPassword() {
    return RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'
    ).hasMatch(this);
  }
}