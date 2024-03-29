import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huddlelabs/pages/dashboard/dashboard_page.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';
import 'package:huddlelabs/utils/components/huddle_route_animation.dart';
import 'package:huddlelabs/utils/components/responsive_widget.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:huddlelabs/utils/enums.dart';

class SignupPage extends StatelessWidget {
  static const String routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final largeWidget = Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Huddle labs',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  fontFamily: 'PoorRich', letterSpacing: 1.3),
                        )),
                  ),
                  Expanded(
                      flex: 15,
                      child: Row(
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                              flex: 3,
                              child:
                                  SingleChildScrollView(child: SignUpForm())),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      )),
                ],
              )),
        ),
        Expanded(
          flex: 5,
          child: LoginWebBanner(),
        ),
      ],
    );

    final smallWidget = Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: size.height / 2.1,
          child: Container(color: Theme.of(context).primaryColor),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          top: size.height / 2,
          child: Container(
            color: Colors.white,
          ),
        ),
        Positioned(
          left: 20,
          top: 20,
          child: Text(
            'Huddle labs',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                fontFamily: 'PoorRich',
                color: Colors.white,
                letterSpacing: 1.3),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: SimpleDialog(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              children: [SignUpForm()],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: ResponsiveWidget(
          largeScreen: largeWidget,
          mediumScreen: largeWidget,
          smallScreen: smallWidget),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<HuddleButtonState> _buttonKey =
      GlobalKey<HuddleButtonState>();
  String? _email, _password, _name, _phone;
  Gender? _gender;
  bool _autovalidate = false;
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Sign up',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.black87)),
            ),
            SizedBox(height: 15),
            //name
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                hintText: 'James Bond',
                labelText: 'Name',
              ),
              onSaved: (String? value) {
                _name = value;
              },
              validator: (String? value) {
                if (value!.trim().isEmpty) return 'Name is required.';
                if (!nameExpression.hasMatch(value))
                  return 'Please enter valid name.';
                return null;
              },
            ),
            SizedBox(height: 5),
            // email
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                hintText: 'your@example.com',
                labelText: 'Email',
              ),
              onSaved: (String? value) {
                _email = value;
              },
              validator: (String? value) {
                if (value!.trim().isEmpty) return 'Email is required.';
                if (!emailExpression.hasMatch(value))
                  return 'Please enter valid email address.';
                return null;
              },
            ),
            SizedBox(height: 5),
            // phone
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.phone_android),
                hintText: '1234567890',
                labelText: 'Phone',
              ),
              onSaved: (value) {
                _phone = value;
              },
              validator: (String? value) {
                if (value!.trim().isEmpty) return 'Phone is required.';
                if (!phoneExpression.hasMatch(value))
                  return 'Please enter valid phone number.';
                return null;
              },
            ),
            SizedBox(height: 15),
            //gender
            DropdownButtonFormField<Gender>(
              elevation: 2,
              items: Gender.values
                  .map((e) => DropdownMenuItem(
                        child: Text(e.toGenderString),
                        value: e,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _gender = value;
                });
              },
              isDense: true,
              validator: (value) {
                if (value == null) return 'Gender is required.';
                return null;
              },
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  border: OutlineInputBorder(),
                  labelText: 'Gender'),
            ),
            SizedBox(height: 5),
            // password text field
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              obscureText: _visible,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                hintText: '*******',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _visible = !_visible;
                    });
                  },
                  icon: _visible
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
                labelText: 'Password',
              ),
              onChanged: (value) {
                _password = value;
              },
              onSaved: (String? value) {
                _password = value;
              },
              validator: (String? value) {
                if (value!.trim().isEmpty) return 'Password is required.';
                //  if (!passwordExpression.hasMatch(value))
                //   return 'Please enter valid email address.';
                return null;
              },
            ),
            SizedBox(height: 5),
            //confirm pass
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              obscureText: _visible,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                hintText: '*******',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _visible = !_visible;
                    });
                  },
                  icon: _visible
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
                labelText: 'Confirm Password',
              ),
              validator: (String? value) {
                if (_password!.trim() == value!.trim()) return null;
                return 'Password did not match.';
              },
            ),
            SizedBox(height: 30),
            HuddleButton(
              key: _buttonKey,
              width: MediaQuery.of(context).size.width,
              text: 'Sign Up',
              onPressed: () {
                final FormState? form = _formKey.currentState;
                if (!form!.validate()) {
                  _autovalidate = true;
                } else {
                  form.save();
                  _doSignUp();
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Already have an account? '),
                InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text('Sign in',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)))
              ],
            ),
          ],
        ));
  }

  _doSignUp() {
    _buttonKey.currentState?.showLoader();
    Map<String, dynamic> data = {
      'name': _name?.trim(),
      'email': _email?.trim(),
      'phone': _phone?.trim(),
      'gender': _gender?.toInt,
      'createdAt': DateTime.now()
    };
    fb
        .auth()
        .createUserWithEmailAndPassword(_email!.trim(), _password!.trim())
        .then((fb.UserCredential result) {
      usersCollection.doc(result.user!.uid).set(data).then((value) {
        showSnackbar('Sign up successful.', context);
        Navigator.pushAndRemoveUntil(
            context, FadeRoute(page: DashboardPage()), (route) => false);
        _buttonKey.currentState?.hideLoader();
      }).catchError((error) {
        if (error is fb.FirebaseError) {
          fb.auth().signOut();
          showSnackbar('${error.message}', context);
          _buttonKey.currentState?.hideLoader();
        } else {
          print(error);
        }
      }).whenComplete(() {
        _buttonKey.currentState?.hideLoader();
      });
    }).catchError((error) {
      if (error is fb.FirebaseError) {
        showSnackbar('${error.message}', context);
        _buttonKey.currentState?.hideLoader();
      } else {
        print(error);
      }
    });
  }
}

class LoginWebBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 400,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xFF4ACBF9), Color(0xff8931FD)],
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'A solution to the development exceptions.',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white),
          ),
          Image.asset(
            'assets/signup_banner.png',
            height: 400,
            width: 400,
          )
        ],
      ),
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase() ?? "",
      selection: newValue.selection,
    );
  }
}
