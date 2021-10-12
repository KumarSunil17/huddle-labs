import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/pages/dashboard/dashboard_page.dart';
import 'package:huddlelabs/pages/forgot_password/forgot_password_dialog.dart';
import 'package:huddlelabs/pages/signup/signup_page.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';
import 'package:huddlelabs/utils/components/huddle_route_animation.dart';
import 'package:huddlelabs/utils/components/responsive_widget.dart';
import 'package:huddlelabs/utils/constants.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = '/login';

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
                    flex: 2,
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
                      flex: 8,
                      child: Row(
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(flex: 3, child: LoginForm()),
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
              children: [LoginForm()],
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

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<HuddleButtonState> _buttonKey =
      GlobalKey<HuddleButtonState>();
  String? _email, _password;
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
              child: Text('Log in',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.black87)),
            ),
            SizedBox(height: 30),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
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
                if (value!.isEmpty) return 'Email is required.';
                if (!emailExpression.hasMatch(value))
                  return 'Please enter valid email address.';
                return null;
              },
            ),
            SizedBox(height: 20),
            // password text field
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              obscureText: _visible,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                hintText: '*******',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _visible = !_visible;
                    });
                  },
                  child: _visible
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
                labelText: 'Password',
              ),
              onSaved: (String? value) {
                _password = value;
              },
              validator: (String? value) {
                if (value!.isEmpty) return 'Password is required.';
                return null;
              },
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: '',
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionBuilder: (context, a1, a2, widget) {
                        return Transform.scale(
                          scale: a1.value,
                          child: Opacity(opacity: a1.value, child: widget),
                        );
                      },
                      transitionDuration: Duration(milliseconds: 300),
                      context: context,
                      pageBuilder: (context, animation1, animation2) {
                        return ForgotPasswordDialog();
                      }).then((value) {
                    if (value != null && value is String) {
                      showSnackbar(value, context);
                    }
                  });
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            SizedBox(height: 30),
            HuddleButton(
              key: _buttonKey,
              width: MediaQuery.of(context).size.width,
              text: 'Log In',
              onPressed: () {
                final FormState? form = _formKey.currentState;
                if (!form!.validate()) {
                  _autovalidate = true;
                } else {
                  form.save();
                  _doLogin();
                }
              },
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Don\'t have an account? '),
                InkWell(
                    onTap: () {
                      Navigator.push(context, FadeRoute(page: SignupPage()));
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Text('Sign up',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)))
              ],
            ),
          ],
        ));
  }

  _doLogin() {
    _buttonKey.currentState?.showLoader();
    auth()
        .signInWithEmailAndPassword(_email!, _password!)
        .then((UserCredential result) {
      showSnackbar('Sign in successful.', context);

      Navigator.pushAndRemoveUntil(
          context, FadeRoute(page: DashboardPage()), (route) => false);
    }).catchError((error) {
      if (error is FirebaseError) {
        showSnackbar('${error.message}', context);
      } else {
        print(error);
      }
    }).whenComplete(() {
      _buttonKey.currentState?.hideLoader();
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
            'assets/login_banner.png',
            height: 400,
            width: 400,
          )
        ],
      ),
    );
  }
}
