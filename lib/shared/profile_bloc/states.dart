abstract class ProfileStates{}

class InitialState extends ProfileStates{}

class ChangeCurrentIndex extends ProfileStates{}
class ChangeRateText extends ProfileStates{}

class SetNewAddress extends ProfileStates{}
class RemoveAddress extends ProfileStates{}
class UpdateAddress extends ProfileStates{}


class LoadingGetUserData extends ProfileStates{}
class SuccessGetUserData extends ProfileStates{}
class ErrorGetUserData extends ProfileStates{}


class LoadingGetUserRating extends ProfileStates{}
class SuccessGetUserRating extends ProfileStates{}
class ErrorGetUserRating extends ProfileStates{}

class LoadingUpdateUserData extends ProfileStates{}
class SuccessUpdateUserData extends ProfileStates{}
class ErrorUpdateUserData extends ProfileStates{}


class LoadingSentUserRating extends ProfileStates{}
class SuccessSentUserRating extends ProfileStates{}
class ErrorSentUserRating extends ProfileStates{}


class LoadingSendAddressesToFirebase extends ProfileStates{}
class SuccessSendAddressesToFirebase extends ProfileStates{}
class ErrorSendAddressesToFirebase extends ProfileStates{}

class LoadingSetFavoriteDrink extends ProfileStates{}
class SuccessSetFavoriteDrink extends ProfileStates{}
class ErrorSetFavoriteDrink extends ProfileStates{}

class SuccessGetFavoriteDrink extends ProfileStates{}

class SuccessRemoveFavoriteDrink extends ProfileStates{}


class SuccessSendMessage extends ProfileStates{}
class ErrorSendMessage extends ProfileStates{}


class SuccessGetMessages extends ProfileStates{}