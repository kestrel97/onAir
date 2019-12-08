import 'package:OnAir/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'services/authentication.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _name = "";
  String _errorMessage;
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  bool _isLoginForm;
  bool _isLoading;
  bool passwordVisible = true;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      // _isLoading = true;
    });
    if (validateAndSave()) {
      setState(() {
        // _errorMessage = "";
        _isLoading = true;
      });
      String userId = "";
      FirebaseUser user;
      try {
        if (_isLoginForm) {
          user = await widget.auth.signIn(_email, _password);
          userId = user.uid;
          await postAuthentication('', userId, user.providerData[0].email);

          print('Signed in: ' + userId);
        } else {
          user = await widget.auth.signUp(_email, _password);
          userId = user.uid;
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          print('Signed up user: ' + userId);
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          if (user.isEmailVerified)
            widget.loginCallback();
          else {
            _showEmailNotVerifiedDialog();
          }
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  // Example code of how to sign in with google.
  void _signInWithGoogle() async {
    if (!await checkGps(context)) return;

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    String userId = user.uid;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(userId == currentUser.uid);

    if (user != null)
      await postAuthentication(
          user.providerData[0].displayName, userId, user.providerData[0].email);

    if (userId.length > 0 && userId != null) {
      setState(() {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => MainScreen()));
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void resetPassword() {
    if(emailController.text.isEmpty) _showEnterEmailDialog();
    else{ widget.auth.resetPassword(emailController.text.trim());
    _showResetPasswordDialog();}
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(_isLoginForm ? 'Sign In' : 'Sign Up'),
          // actions: <Widget>[
          //   Builder(builder: (BuildContext context) {
          //     return FlatButton(
          //       child: const Text('Sign out'),
          //       textColor: Theme.of(context).buttonColor,
          //       onPressed: () async {
          //         final user = await widget.auth.getCurrentUser();
          //         if (user == null) {
          //           Scaffold.of(context).showSnackBar(SnackBar(
          //             content: const Text('No one has signed in.'),
          //           ));
          //           return;
          //         }
          //         widget.auth.signOut();
          //         final String uid = user.uid;
          //         Scaffold.of(context).showSnackBar(SnackBar(
          //           content: Text(uid + ' has successfully signed out.'),
          //         ));
          //       },
          //     );
          //   })
          // ],
        ),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                toggleFormMode();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEmailNotVerifiedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify your email address"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showEnterEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Enter your Email"),
          content: new Text("Please enter your email address"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Reset Password"),
          content: new Text("Please check your email for further instructions"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              if (!_isLoginForm) showNameInput(),
              showEmailInput(),
              showPasswordInput(),
              if (_isLoginForm) showForgetPassowrd(),
              showPrimaryButton(),
              showGoogleSignIn(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/onair.png'),
        ),
      ),
    );
  }

  Widget showNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
      child: new TextFormField(
        controller: nameController,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Username',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }
  Widget showEmailInput() {
    return Padding(
      padding: _isLoginForm? const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0) : const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: emailController,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        keyboardType: TextInputType.text,
        maxLines: 1,
        obscureText: passwordVisible,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Password',
          icon: new Icon(
            Icons.lock,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              passwordVisible ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: _isLoginForm? EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0) : EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showForgetPassowrd() {
    return new FlatButton(
        child: new Text(_isLoginForm ? 'forget Password?' : '',
            style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300)),
        onPressed: resetPassword);
  }

  Widget showGoogleSignIn() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: OutlineButton(
          splashColor: Colors.grey,
          onPressed: _signInWithGoogle,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          borderSide: BorderSide(color: Colors.grey),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage("assets/google_logo.png"), height: 25.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
