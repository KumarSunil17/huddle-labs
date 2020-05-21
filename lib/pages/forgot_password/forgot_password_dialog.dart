import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';
import 'package:huddlelabs/utils/components/huddle_extensions.dart';

class ForgotPasswordDialog extends StatelessWidget {
  static const String routeName = '/forgotPassword';

  @override
  Widget build(BuildContext context) {
    String _email;

    _sendLink() {
      if(_email.isNotEmpty){
   
      fb.auth().sendPasswordResetEmail(_email).then((value) {
        Navigator.pop(context, 'Reset email sent successfully.');
      }).catchError((error) {
        if (error is fb.FirebaseError) {
          Navigator.pop(context, '${error.message}');return;
        }
        print('$error');
        Navigator.pop(context, '$error');
      });
      }
    }

    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      title: Row(
        children: <Widget>[
          Text('Recover password'),
          Expanded(child: Container()),
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            elevation: 0,
            focusElevation: 1.5,
            hoverElevation: 2,
            highlightElevation: 1.5,
            minWidth: 20,
            color: Colors.black87,
            height: 20,
            padding: const EdgeInsets.all(4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Icon(Icons.close, color: Colors.white, size: 15),
          ).showCursorOnHover
        ],
      ),
      children: <Widget>[
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              border: UnderlineInputBorder(),
              prefixIcon: Icon(Icons.email),
              hintText: 'Enter your email',
              labelText: 'Email'),
          onSubmitted: (value) {
            _email = value.trim();
          },
        ),
        SizedBox(height: 20),
        HuddleButton(
          text: 'Send link',
          height: 50,
          width: double.infinity,
          onPressed: _sendLink,
        )
      ],
    );
  }
}
