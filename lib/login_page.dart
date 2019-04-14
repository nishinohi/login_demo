import 'package:flutter/material.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  FormType _formType = FormType.login;

  bool validateAndSave() {
    FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId;
        if (_formType == FormType.login) {
          userId = await widget.auth.signedInWithMailAndPassword(_email, _password);
        } else if (_formType == FormType.register) {
          userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
        }
        print('signed in: $userId');
        widget.onSignedIn();
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Login Demo'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildInputForms() + _buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInputForms() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t empty' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'PassWord'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> _buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 13.0)),
          onPressed: validateAndSubmit,
        ),
        new RaisedButton(
          child: new Text(
            'Create an account',
            style: new TextStyle(fontSize: 13.0),
          ),
          onPressed: moveToRegister,
        )
      ];
    }
    return [
      new RaisedButton(
        child: new Text('Create an account', style: new TextStyle(fontSize: 13.0)),
        onPressed: validateAndSubmit,
      ),
      new RaisedButton(
        child: new Text(
          'Have an account?',
          style: new TextStyle(fontSize: 13.0),
        ),
        onPressed: moveToLogin,
      )
    ];
  }
}
