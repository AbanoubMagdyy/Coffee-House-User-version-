abstract class LoginAndSignUpStates{}

class InitialState extends LoginAndSignUpStates{}

class ChangeSlider extends LoginAndSignUpStates{}
class ChangeVisibility extends LoginAndSignUpStates{}
class ChangeTheme extends LoginAndSignUpStates{}

class LoadingLogin extends LoginAndSignUpStates{}
class SuccessLogin extends LoginAndSignUpStates{}
class ErrorLogin extends LoginAndSignUpStates{}

class LoadingSignUp extends LoginAndSignUpStates{}
class SuccessSignUp extends LoginAndSignUpStates{}
class ErrorSignUP extends LoginAndSignUpStates{
   String error;
  ErrorSignUP(this.error);
}

class LoadingForgotPassword extends LoginAndSignUpStates{}
class SuccessForgotPassword extends LoginAndSignUpStates{}
class ErrorForgotPassword extends LoginAndSignUpStates{}

class SuccessGetImageFromGallery extends LoginAndSignUpStates{}
class ErrorGetImageFromGallery extends LoginAndSignUpStates{}

class LoadingUploadProfileImage extends LoginAndSignUpStates{}
class SuccessUploadProfileImage  extends LoginAndSignUpStates{}
class ErrorUploadProfileImage  extends LoginAndSignUpStates{}

class LoadingCreateAccount extends LoginAndSignUpStates{}
class SuccessCreateAccount  extends LoginAndSignUpStates{}
class ErrorCreateAccount  extends LoginAndSignUpStates{}