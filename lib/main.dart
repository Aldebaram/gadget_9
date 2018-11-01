
import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

void main() => runApp(new MaterialApp(
  title: 'D-MAIL Sender',
  home: new EmailPage(),
));

Dio dio = new Dio();

class EmailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EmailPageState();
}

class _EmailData {
  String senderEmail;
  String senderPassword;
  String targetEmail;
  String subject;
  String emailBody;
}

class _EmailPageState extends State<EmailPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _EmailData _data = new _EmailData();

  String _validateEmail(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String _validateSubject(String value) {
    if (value.length < 8) {
      return 'The Subject must be at least 8 characters.';
    }

    return null;
  }

  String _validateEmailBody(String value) {
    if (value.length < 8) {
      return 'The e-mail Body must be at least 8 characters.';
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 8) {
      return 'The Password must be at least 8 characters.';
    }
    return null;
  }

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      print('Printing the email data.');
      print('Sender Email: ${_data.senderEmail}');
      print('Sender Password: ${_data.senderPassword}');
      print('Target Email: ${_data.targetEmail}');
      print('Subject: ${_data.subject}');
      print('E-mail body: ${_data.emailBody}');
      String json = '{"emailEmissor":"${_data.senderEmail}","senhaEmissor":"${_data.senderPassword}","emailReceptor":"${_data.targetEmail}","mensagem":"${_data.emailBody}","assunto":"${_data.subject}"}';
      print(json);
      sendJson();
    }
  }

  void sendJson() async{
      var dio = new Dio();
      bool error=false;
      // Send FormData
      print("sending json...");
     try {
    await dio.post("http://fetchbooru.ooo/PHP/", data:'{"emailEmissor":"${_data.senderEmail}","senhaEmissor":"${_data.senderPassword}","emailReceptor":"${_data.targetEmail}","mensagem":"${_data.emailBody}","assunto":"${_data.subject}"}');
   } on DioError catch(e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if(e.response==null) {
        error=true;
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request); 
        Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("ERROR SENDING D-MAIL"),
    ));
      } else{
        error=true;
        // Something happened in setting up or sending the request that triggered an Error  
        print(e.response.request);
        print(e.message);
        Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("ERROR SENDING D-MAIL"),
    ));
      }  
  }
  if(error==false){
    _popupAlert();
  }
  }

  Future<Null> _popupAlert() async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('D-MAIL STATUS'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('D-mail sent.'),
              Text('El Psy Kongroo.'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    
    return new Scaffold(
    body: new Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(image: new AssetImage("WP/wallpaper.png"), fit: BoxFit.cover,),
          ),
        ),
        new Center(
          child: 
          Card(
          margin: EdgeInsets.all(0.0),  
          color: Color.fromRGBO(0, 0, 0, 0.5),
          child: new Form(
          key: this._formKey,
          child: new ListView(
            children: <Widget>[
              new TextFormField(
                keyboardType: TextInputType.emailAddress, // Use email input type for emails.
                decoration: new InputDecoration(
                  hintText: 'you@example.com',
                  labelText: 'E-mail Address',
                  helperStyle: TextStyle(
                  color: Colors.white
                ),
                hintStyle: TextStyle(
                  color: Colors.white
                ),
                labelStyle: TextStyle(
                  color: Colors.white
                ),
                ),
                style: TextStyle(
                  color: Colors.white
                ),
                validator: this._validateEmail,
                onSaved: (String value) {
                  this._data.senderEmail = value;
                }
              ),

              new TextFormField( 
                obscureText: true,
                decoration: new InputDecoration(
                  hintText: 'Password',
                  labelText: 'Enter the password',
                  helperStyle: TextStyle(
                  color: Colors.white
                ),
                hintStyle: TextStyle(
                  color: Colors.white
                ),
                labelStyle: TextStyle(
                  color: Colors.white
                ),
                ),
                style: TextStyle(
                  color: Colors.white
                ),
                validator: this._validatePassword,
                onSaved: (String value) {
                  this._data.senderPassword = value;
                }
              ),

              new TextFormField( 
                decoration: new InputDecoration(
                  hintText: 'you@example.com',
                  labelText: 'Enter the Target E-Mail',
                  helperStyle: TextStyle(
                  color: Colors.white
                ),
                hintStyle: TextStyle(
                  color: Colors.white
                ),
                labelStyle: TextStyle(
                  color: Colors.white
                ),
                ),
                style: TextStyle(
                  color: Colors.white
                ),
                validator: this._validateEmail,
                onSaved: (String value) {
                  this._data.targetEmail = value;
                }
              ),

              new TextFormField( 
                decoration: new InputDecoration(
                  hintText: 'Subject',
                  labelText: 'Enter the email Subject',
                  helperStyle: TextStyle(
                  color: Colors.white
                ),
                hintStyle: TextStyle(
                  color: Colors.white
                ),
                labelStyle: TextStyle(
                  color: Colors.white
                ),
                ),
                style: TextStyle(
                  color: Colors.white
                ),
                validator: this._validateSubject,
                onSaved: (String value) {
                  this._data.subject = value;
                }
              ),


              new TextFormField( 
                decoration: new InputDecoration(
                  hintText: 'Email Body',
                  labelText: 'Enter the email Body',
                  helperStyle: TextStyle(
                  color: Colors.white
                ),
                hintStyle: TextStyle(
                  color: Colors.white
                ),
                labelStyle: TextStyle(
                  color: Colors.white
                ),
                ),
                style: TextStyle(
                  color: Colors.white
                ),
                validator: this._validateEmailBody,
                onSaved: (String value) {
                  this._data.emailBody = value;
                }
              ),
              
              new Container(
                width: screenSize.width,
                child: new RaisedButton(
                  child: new Text(
                    'Send',
                    style: new TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onPressed:this.submit,
                  color: Colors.blue,
                ),
                margin: new EdgeInsets.only(
                  top: 20.0
                ),
              )
            ],
          ),
        )
          )
        )
      ],
    )
  );
  }
}

