abstract class AppStates{}

class InitialState extends AppStates{}

class ChangeCurrentIndex extends AppStates{}

class ChangeBannerIndex extends AppStates{}

class ChangeSlider extends AppStates{}

class ChangeFavoriteState extends AppStates{}

class SuccessSearchDrink extends AppStates{}

class ActiveSearch extends AppStates{}
class DeactivatedSearch extends AppStates{}


class IncreaseTheNumberOfDrinks extends AppStates{}
class ReduceTheNumberOfDrinks extends AppStates{}



class LoadingGetCoffeeMenu extends AppStates{}
class SuccessGetCoffeeMenu extends AppStates{}
class ErrorGetCoffeeMenu extends AppStates{}

class LoadingGetChocolateMenu extends AppStates{}
class SuccessGetChocolateMenu extends AppStates{}
class ErrorGetChocolateMenu extends AppStates{}

class LoadingGetOthersMenu extends AppStates{}
class SuccessGetOthersMenu extends AppStates{}
class ErrorGetOthersMenu extends AppStates{}

class LoadingOrderRequest extends AppStates{}
class SuccessOrderRequest extends AppStates{}
class ErrorOrderRequest extends AppStates{}


class SuccessAfterSendingTheOrder extends AppStates{}
class ErrorAfterSendingTheOrder extends AppStates{}

class SuccessGetPastOrders extends AppStates{}
class ErrorGetPastOrders extends AppStates{}


class SuccessIncreaseTheNumberOfDrinkSales extends AppStates{}
class ErrorIncreaseTheNumberOfDrinkSales extends AppStates{}