import 'dart:html';
import 'dart:async';

import 'package:mysql1/mysql1.dart';

Future<void> main() async {
  if (window.location.pathname!.endsWith('login.html')) {
    setupLoginForm();
  } else if (window.location.pathname!.endsWith('register.html')) {
    setupRegistrationForm();
  }
}

Future<dynamic> dbConn() async {
  var settings = ConnectionSettings(
      host: 'localhost', port: 3306, user: 'root', db: 'jaribu');
  var connection = await MySqlConnection.connect(settings);
  return connection;
}
  Future<dynamic> handleRegistration() async {
    var newUsername = (querySelector('#newUsername') as InputElement).value;
    var newPassword = (querySelector('#newPassword') as InputElement).value;
    var confPassword = (querySelector('#confPassword') as InputElement).value;
    var lName = (querySelector('#lName') as InputElement).value;
    var fName = (querySelector('#fName') as InputElement).value;

    if (newPassword != confPassword) {
      querySelector('#finalSms')!.text = "Password Mismatch"; //
    } else {
      var settings = new ConnectionSettings(
          host: 'localhost', port: 3306, user: 'root', db: 'jaribu');
      var connection = await MySqlConnection.connect(settings);
// hash code ni kwaajili ya kubadilisha normal text to simple cypher
      var put_Data = await connection.query(
          "INSERT INTO users values(?,?,?,?),[$fName,$lName,$newUsername,${confPassword.hashCode}]");

      connection.close();
    }
  }

void setupLoginForm() {
  querySelector('#loginForm')!.onSubmit.listen((event) {
    event.preventDefault();
    handleLogin();
  });
}

void setupRegistrationForm() {
  querySelector('#registrationForm')!.onSubmit.listen((event) {
    event.preventDefault();
    handleRegistration();
  });
}

void handleLogin() async {
  var settings = new ConnectionSettings(
      host: 'localhost', port: 3306, user: 'root', db: 'jaribu');
  var connection = await MySqlConnection.connect(settings);

  var username = (querySelector('#username') as InputElement).value;
  var password = (querySelector('#password') as InputElement).value;

  var values = await connection.query("select * from users");
  for (var user in values.toList()) {
    var u = user[2].toString();

    if (u == username) {
      var dbpassword = await connection
          .query("select Password from users where username = ?", [username]);
      var dbusername = await connection
          .query("select Username from users where username = ?", [username]);
      var npassword = dbpassword.toList()[0][0].toString();
      var n_username = dbusername.toList()[0][0].toString();

      if (username == n_username) {
        if (password.hashCode.toString() == npassword.toString()) {
        } else if (password != npassword) {}
      } else if (username != n_username) {}
      connection.close();
    }
  }


}
