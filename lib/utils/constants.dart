final RegExp emailExpression = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp nameExpression = RegExp(r'^[A-Za-z ]+$');
final RegExp passwordExpression = RegExp(r'^(?=.*[0-9])(?=.*[A-Z])(?=.*[@#$%^&+=!])(?=\S+$).{4,}$');
final RegExp phoneExpression = RegExp(r'^\d\d\d\d\d\d\d\d\d\d$');
