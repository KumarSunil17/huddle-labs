import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

final RegExp emailExpression = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp nameExpression = RegExp(r'^[A-Za-z ]+$');
final RegExp passwordExpression = RegExp(r'^(?=.*[0-9])(?=.*[A-Z])(?=.*[@#$%^&+=!])(?=\S+$).{4,}$');
final RegExp phoneExpression = RegExp(r'^\d\d\d\d\d\d\d\d\d\d$');
const String MALE_PLACEHOLDER='https://img.icons8.com/color/200/000000/circled-user-male-skin-type-5.png';
const String FEMALE_PLACEHOLDER='https://img.icons8.com/color/200/000000/user-female-circle.png';

final CollectionReference usersCollection = fb.firestore().collection('user');
final CollectionReference projectCollection = fb.firestore().collection('project');
final CollectionReference notificationCollection = fb.firestore().collection('notification');
final CollectionReference taskCollection = fb.firestore().collection('task');
final CollectionReference chatCollection = fb.firestore().collection('chat');
final CollectionReference transactionCollection = fb.firestore().collection('transaction');