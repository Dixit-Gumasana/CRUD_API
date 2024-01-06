import 'dart:convert';

import 'package:crud_api/registerscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';
import 'main.dart';

class LoginPg extends StatefulWidget {
  const LoginPg({super.key});

  @override
  State<LoginPg> createState() => _LoginPgState();
}

class _LoginPgState extends State<LoginPg> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  bool isVisible = true;
  bool isLoading = false;
  String? token;
  var name;

  LoginFun() async {
    try {
      var res = await http.post(
          Uri.parse(
              "https://web-production-090f.up.railway.app/api/v1/auth/login"),
          body: jsonEncode({
            "email": emailLoginController.text,
            "password": passwordLoginController.text
          }),
          headers: {'accept': '*/*', 'Content-Type': 'application/json'});

      var data = jsonDecode(res.body);
      setState(() {});
      await sharedPreferences!.setString("token", data["token"].toString());
      token = sharedPreferences!.getString("token");
      debugPrint("---->>>---Login Token = $token");

      await sharedPreferences?.setString("name", data["user"]["name"]);
      name = sharedPreferences?.getString("name");
      debugPrint("---->>>---UseName = $name");

      if (res.statusCode == 200 || res.statusCode == 201) {
        setState(() {
          isLoading = false;
        });
         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardPg(),), (route) => false);
        debugPrint("Api called Successfully");
        FocusScope.of(context).unfocus();
        setState(() {});
        Fluttertoast.showToast(
          msg: 'Login Successful',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.deepPurple.shade400,
        );
        emailLoginController.clear();
        passwordLoginController.clear();
      } else {
        Fluttertoast.showToast(
            msg: '${data["msg"]}',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.deepPurple.shade400);
        debugPrint("${data["msg"]}");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/login.png"), fit: BoxFit.cover)),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Good to see you back!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 120, left: 40, right: 40),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: ListView(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Email!";
                            }
                            return null;
                          },
                          controller: emailLoginController,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          style: TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                              label: Text("Email Id",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple)),
                              hintText: "Enter Your Email",
                              hintStyle: TextStyle(
                                  color:
                                      Colors.deepPurpleAccent.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white70,
                              prefixIcon: Icon(Icons.email_outlined,
                                  size: 21, color: Colors.deepPurple),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 1.5, color: Colors.white54)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color:
                                          Colors.blueAccent.withOpacity(0.5)))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Password!";
                            }
                            return null;
                          },
                          controller: passwordLoginController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isVisible,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          style: TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                              label: Text("Password",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple)),
                              hintText: "Enter Your Password",
                              hintStyle: TextStyle(
                                  color:
                                      Colors.deepPurpleAccent.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white70,
                              prefixIcon: Icon(Icons.key_outlined,
                                  size: 21, color: Colors.deepPurple),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  child: (isVisible)
                                      ? Icon(
                                          Icons.visibility,
                                          size: 21,
                                          color: Colors.deepPurple,
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          size: 21,
                                          color: Colors.deepPurple,
                                        )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 1.5, color: Colors.white54)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color:
                                          Colors.blueAccent.withOpacity(0.5)))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40, right: 40, top: 40),
                          child: InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                await LoginFun();
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please Enter Valid Detail',
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor:
                                        Colors.deepPurple.shade200);
                                debugPrint("Invalid Credential");
                              }
                            },
                            child: Card(
                              elevation: 45,
                              color: Colors.blueAccent.withOpacity(0.6),
                              child: Container(
                                height: 50,
                                width: 150,
                                child: Center(
                                    child: (isLoading == true)
                                        ? CircularProgressIndicator()
                                        : Text(
                                            "Login",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white70),
                                          )),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 70),
              child: Text(
                "Doesnt have an account ?",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 20, right: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPg(),
                      ),
                      (route) => false);
                },
                child: Text(
                  "Register Here!",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.blueAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
