import 'dart:convert';

import 'package:crud_api/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';
import 'main.dart';

class RegisterPg extends StatefulWidget {
  const RegisterPg({super.key});

  @override
  State<RegisterPg> createState() => _RegisterPgState();
}

class _RegisterPgState extends State<RegisterPg> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameRegisterController = TextEditingController();
  TextEditingController emailRegisterController = TextEditingController();
  TextEditingController passwordRegisterController = TextEditingController();
  TextEditingController confirmPasswordRegisterController =
      TextEditingController();
  bool isVisible = true;
  bool visible = true;

  bool isLoading = false;
  String? token;
  var name;

  Registerfun() async {
    try {
      var res = await http.post(
          Uri.parse(
              "https://web-production-090f.up.railway.app/api/v1/auth/register"),
          body: jsonEncode({
            "name": nameRegisterController.text,
            "email": emailRegisterController.text,
            "password": passwordRegisterController.text
          }),
          headers: {'accept': '*/*', 'Content-Type': 'application/json'});

      var data = jsonDecode(res.body);
      setState(() {});
      await sharedPreferences!.setString("token", data["token"].toString());
      token = sharedPreferences!.getString("token");
      debugPrint("---->>>---Register Token = $token");
      await sharedPreferences?.setString("name", data["user"]["name"]);
      name = sharedPreferences?.getString("name");
      debugPrint("---->>>---UserName = $name");

      if (res.statusCode == 200 || res.statusCode == 201) {
        setState(() {
          isLoading = false;
        });

        FocusScope.of(context).unfocus();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardPg(),), (route) => false);
        Fluttertoast.showToast(
          msg: 'Register Succesful',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.deepPurple.shade400,
        );
        nameRegisterController.clear();
        emailRegisterController.clear();
        passwordRegisterController.clear();
        confirmPasswordRegisterController.clear();
      } else {
        Fluttertoast.showToast(
            msg: '${data["msg"]}',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.deepPurple.shade400);
        debugPrint("---->>>--- ${data["msg"]}");
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
            height: MediaQuery.of(context).size.height / 1.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/register.png"),
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Cheers to new beginnings!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 70, left: 40, right: 40),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: ListView(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Name!";
                            }
                            return null;
                          },
                          controller: nameRegisterController,
                          keyboardType: TextInputType.name,
                          obscureText: false,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          style: TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                              label: Text("Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple)),
                              hintText: "Enter Your Name",
                              hintStyle: TextStyle(
                                  color:
                                      Colors.deepPurpleAccent.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white70,
                              prefixIcon: Icon(Icons.drive_file_rename_outline,
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
                        SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Email!";
                            } else if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          controller: emailRegisterController,
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
                        SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Password!";
                            }
                            return null;
                          },
                          controller: passwordRegisterController,
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
                        SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Re-Enter Your Password!";
                            } else if (value !=
                                passwordRegisterController.text) {
                              return "Password Doesnt Match";
                            }
                            return null;
                          },
                          controller: confirmPasswordRegisterController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: visible,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          style: TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                              label: Text("Password",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple)),
                              hintText: "Re-Enter Your Password",
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
                                      visible = !visible;
                                    });
                                  },
                                  child: (visible)
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
                              left: 40, right: 40, top: 30),
                          child: InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                await Registerfun();
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
                                            "Register",
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
              padding: EdgeInsets.only(top: 30),
              child: Text(
                "Already have an account ?",
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
                        builder: (context) => LoginPg(),
                      ),
                      (route) => false);
                },
                child: Text(
                  "Login Here!",
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
