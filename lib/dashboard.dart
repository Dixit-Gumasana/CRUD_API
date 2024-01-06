import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'loginscreen.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

class DashboardPg extends StatefulWidget {
  const DashboardPg({super.key});

  @override
  State<DashboardPg> createState() => _DashboardPgState();
}

class _DashboardPgState extends State<DashboardPg> {

  List jobList = [];
  var name = sharedPreferences?.getString("name");
  TextEditingController addCompanyController = TextEditingController();
  TextEditingController addPositionController = TextEditingController();

  TextEditingController companyUpdateController = TextEditingController();
  TextEditingController positionUpdateController = TextEditingController();
  TextEditingController statusUpdateController = TextEditingController();


  creatjob() async {
    setState(() {

    });
    try {
      var res = await http.post(
          Uri.parse('https://web-production-090f.up.railway.app/api/v1/jobs'),
          body: jsonEncode(
              {"company": addCompanyController.text,
                "position": addPositionController.text}),
          headers: {
            'accept': '*/*',
            'Authorization': ' Bearer ${sharedPreferences?.getString("token")}',
            'Content-Type': 'application/json'
          });

      var data = jsonDecode(res.body);
      // debugPrint("-->>>data---$data");
      setState(() {
      });

      if(res.statusCode==200 || res.statusCode==201){
        setState(() {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardPg(),), (route) => false);

        });
        FocusScope.of(context).unfocus();
        Fluttertoast.showToast(msg: "Job Created Succesfully", toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.deepPurple.shade400);
      }
      else{
        Fluttertoast.showToast(msg: "${data["msg"]}", toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.deepPurple.shade400 );
      }


    } catch (e) {
      debugPrint("Error $e");
    }
  }

  dashboard() async {
    try {
      setState(() {});
      var res = await http.get(
          Uri.parse('https://web-production-090f.up.railway.app/api/v1/jobs'),
          headers: {
            'accept': ' */*',
            'Authorization': ' Bearer ${sharedPreferences?.getString("token")}'
          });

      if(res.statusCode==200 || res.statusCode==201){
        var data = jsonDecode(res.body);

        jobList = data["jobs"];
        setState(() {});
      }else{
        Fluttertoast.showToast(msg: "Please try again!", toastLength: Toast.LENGTH_LONG,backgroundColor:
        Colors.deepPurple.shade400);
      }

    } catch (e) {
      Fluttertoast.showToast(msg: "Please Try Again",backgroundColor: Colors.deepPurple.shade400);
      debugPrint("Error $e");
    }
  }

  delete(id) async {
    try {
      setState(() {});
      var res2 = await http.delete(
          Uri.parse(
              'https://web-production-090f.up.railway.app/api/v1/jobs/$id'),
          headers: {
            'accept': ' */*',
            'Authorization': ' Bearer ${sharedPreferences?.getString("token")}'
          });
      // var data2 = jsonDecode(res2.body);

      if (res2.statusCode == 200 || res2.statusCode == 201) {
        setState(() {
          dashboard();
          Fluttertoast.showToast(
              msg: "Job Deleted Succesfully", toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.deepPurple.shade400);
        });
      }else{
        Fluttertoast.showToast(msg: "Please try again!", toastLength: Toast.LENGTH_LONG,backgroundColor:
        Colors.deepPurple.shade400);
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  update({id}) async {
    try {
      var res3 = await http.patch(
        Uri.parse(
            "https://web-production-090f.up.railway.app/api/v1/jobs/$id"),
        headers: {
          'accept': '*/*',
          'Authorization': ' Bearer ${sharedPreferences?.getString("token")}',
          'Content-Type': 'application/json'
        },body: jsonEncode(
          {
            "company": companyUpdateController.text.toString(),
            "position": positionUpdateController.text.toString(),
          }
      ),);
      // debugPrint("---Before If");

      if(res3.statusCode==200 || res3.statusCode==201){
        companyUpdateController.clear();
        positionUpdateController.clear();
        statusUpdateController.clear();
        Navigator.of(context).pop();
        setState(() async {
          Fluttertoast.showToast(msg: "Job Updated Succesfully", toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.deepPurple.shade400);
          await dashboard();
        });
        FocusScope.of(context).unfocus();
      }
      else{
        Fluttertoast.showToast(msg: "Please try again!", toastLength: Toast.LENGTH_LONG,backgroundColor:
        Colors.deepPurple.shade400);
      }

    } catch (e) {

      debugPrint("Error $e");
    }
  }

  @override
  void initState() {
    dashboard();
    debugPrint("---TOKEN--->>> ${sharedPreferences?.getString("token")}");
    super.initState();
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        elevation: 30,
        title: Text("Dashboard",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    elevation: 35,
                    backgroundColor: Colors.deepPurple.shade100,
                    title: Center(
                      child: Text("Are you want to logout?",
                          style: TextStyle(fontSize: 20)),
                    ),
                    actions: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPg(),
                                  ),
                                  (route) => false);
                              setState(() {
                                sharedPreferences?.clear();
                              });
                            },
                            child: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white38,
                              ),
                              child: Center(child: Text("Yes",
                              style: TextStyle(
                                fontWeight: FontWeight.w400
                              ),)),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white38,
                              ),
                              child: Center(child: Text("No",
                              style: TextStyle(
                                fontWeight: FontWeight.w400
                              ),)),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout_outlined),
            color: Colors.white,
          )
        ],
        leading: Column(
          children: [
            CircleAvatar(
              radius: 17,
              child: Icon(Icons.person_2_outlined,size: 20),
            ),
            Spacer(),
            Text("$name",style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12
            ),)
          ],
        ),
      ),

      body: ListView(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: jobList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return (index%2==0)?Container(
                margin: EdgeInsetsDirectional.symmetric(vertical: 35,horizontal: 20),
                height: 140,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.shade400,

                    borderRadius: BorderRadius.all(
                        Radius.circular(10)
                    ),
                    border: Border(
                      left: BorderSide(
                          color: Colors.black45,
                          width: 3
                      ),


                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black45,
                          spreadRadius: 1,
                          offset: Offset(0, 5),
                          blurRadius: 10
                      )
                    ]
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5,top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Company ==",style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18
                                  )
                                  ),
                                  TextSpan(
                                      text: "   ${jobList[index]["company"]}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400
                                      )
                                  )
                                ]
                            )),
                            SizedBox(height: 10),
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Position ==",style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18
                                  )
                                  ),
                                  TextSpan(
                                      text: "   ${jobList[index]["position"]}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400
                                      )
                                  )
                                ]
                            )),
                            SizedBox(height: 10),
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Status ==",style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18
                                  )
                                  ),
                                  TextSpan(
                                      text: "   ${jobList[index]["status"]}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400
                                      )
                                  )
                                ]
                            )),
                            SizedBox(height: 10),
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "_id ==",style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18
                                  )
                                  ),
                                  TextSpan(
                                      text: "   ${jobList[index]["_id"]}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400
                                      )
                                  )
                                ]
                            )),
                            SizedBox(height: 10),



                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8,top: 5),
                        child: InkWell(
                          onTap: () {
                            showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 35,
                                backgroundColor: Colors.deepPurple.shade100,
                                title: Center(child: Text("Are you sure to want delete?",style: TextStyle(
                                    fontSize: 17
                                )),),
                                actions: [
                                  Row(children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          delete(jobList[index]["_id"]);
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white38,

                                        ),
                                        child: Center(child: Text("Yes")),
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white38,

                                        ),
                                        child: Center(child: Text("No")),
                                      ),
                                    ),
                                  ],)
                                ],
                              );
                            },);


                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Icon(Icons.delete,color: Colors.black.withOpacity(0.6),
                                size: 18),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8,top: 40),
                        child: InkWell(
                          onTap: () {
                            companyUpdateController.text=jobList[index]["company"].toString();
                            positionUpdateController.text=jobList[index]["position"].toString();
                            statusUpdateController.text=jobList[index]["status"].toString();
                            setState(() {
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  elevation: 35,
                                  backgroundColor: Colors.deepPurple.shade100,
                                  title: Text("Enter Updated Detail !"),
                                  actions: [
                                    TextFormField(
                                      controller: companyUpdateController,
                                      style: TextStyle(
                                          color: Colors.black87
                                      ),
                                      decoration: InputDecoration(
                                          label: Text(
                                            "Enter Updated Company ",
                                            style: TextStyle(
                                                color: Colors.black87
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(color: Colors.black45)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black45,
                                                  width: 2
                                              )
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      controller: positionUpdateController,
                                      style: TextStyle(
                                          color: Colors.black87
                                      ),
                                      decoration: InputDecoration(
                                          label: Text(
                                            "Enter Updated Position",
                                            style: TextStyle(
                                                color: Colors.black87
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(color: Colors.black45)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black45,
                                                  width: 2
                                              )
                                          )
                                      ),
                                    ),

                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await update(id: jobList[index]["_id"]);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white38,

                                            ),
                                            child: Center(child: Text("Update")),
                                          ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            companyUpdateController.clear();
                                            positionUpdateController.clear();
                                            statusUpdateController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white38,

                                            ),
                                            child: Center(child: Text("Cancle")),
                                          ),
                                        ),
                                      ],
                                    )

                                  ],

                                );
                              },);


                            });


                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Icon(Icons.edit,color: Colors.black.withOpacity(0.5),
                                size: 18),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ):Container(
                margin: EdgeInsetsDirectional.symmetric(vertical: 15,horizontal: 25),
                height: 140,
                width: 100,
                decoration: BoxDecoration(
                     color: Colors.lightBlue.shade200,

                    borderRadius: BorderRadius.all(
                        Radius.circular(10)
                    ),
                    border: Border(
                      right: BorderSide(
                          color: Colors.black45,
                          width: 3
                      ),

                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black45,
                          spreadRadius: 1,
                          offset: Offset(0, 5),
                          blurRadius: 10
                      )
                    ]
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5,top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Company ==",style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18
                                  )
                                  ),
                                  TextSpan(
                                      text: "   ${jobList[index]["company"]}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400
                                      )
                                  )
                                ]
                            )),
                            SizedBox(height: 10),
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Position ==",style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18
                                  )
                                  ),
                                  TextSpan(
                                      text: "   ${jobList[index]["position"]}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400
                                      )
                                  )
                                ]
                            )),
                            SizedBox(height: 10),
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Status ==",style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18
                                  )
                                  ),
                                  TextSpan(
                                      text: "   ${jobList[index]["status"]}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400
                                      )
                                  )
                                ]
                            )),
                            SizedBox(height: 10),
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "_id ==",style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18
                                  )
                                  ),
                                  TextSpan(
                                      text: "   ${jobList[index]["_id"]}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400
                                      )
                                  )
                                ]
                            )),
                            SizedBox(height: 10),



                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8,top: 5),
                        child: InkWell(
                          onTap: () {
                            showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 35,
                                backgroundColor: Colors.deepPurple.shade100,
                                title: Center(child: Text("Are you sure to want delete?",style: TextStyle(
                                    fontSize: 17
                                )),),
                                actions: [
                                  Row(children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          delete(jobList[index]["_id"]);
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white38,

                                        ),
                                        child: Center(child: Text("Yes")),
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white38,

                                        ),
                                        child: Center(child: Text("No")),
                                      ),
                                    ),
                                  ],)
                                ],
                              );
                            },);

                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Icon(Icons.delete,color: Colors.black.withOpacity(0.6),
                                size: 18),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8,top: 40),
                        child: InkWell(
                          onTap: () {
                            companyUpdateController.text=jobList[index]["company"].toString();
                            positionUpdateController.text=jobList[index]["position"].toString();
                            statusUpdateController.text=jobList[index]["status"].toString();
                            setState(() {
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  elevation: 35,
                                  backgroundColor: Colors.deepPurple.shade100,
                                  title: Text("Enter Updated Detail !"),
                                  actions: [
                                    TextFormField(
                                      controller: companyUpdateController,
                                      style: TextStyle(
                                          color: Colors.black87
                                      ),
                                      decoration: InputDecoration(
                                          label: Text(
                                            "Enter Updated Company ",
                                            style: TextStyle(
                                                color: Colors.black87
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(color: Colors.black45)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black45,
                                                  width: 2
                                              )
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      controller: positionUpdateController,
                                      style: TextStyle(
                                          color: Colors.black87
                                      ),
                                      decoration: InputDecoration(
                                          label: Text(
                                            "Enter Updated Position",
                                            style: TextStyle(
                                                color: Colors.black87
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(color: Colors.black45)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black45,
                                                  width: 2
                                              )
                                          )
                                      ),
                                    ),

                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await update(id: jobList[index]["_id"]);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white38,

                                            ),
                                            child: Center(child: Text("Update")),
                                          ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            companyUpdateController.clear();
                                            positionUpdateController.clear();
                                            statusUpdateController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white38,

                                            ),
                                            child: Center(child: Text("Cancle")),
                                          ),
                                        ),
                                      ],
                                    )

                                  ],

                                );
                              },);


                            });

                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Icon(Icons.edit,color: Colors.black.withOpacity(0.5),
                                size: 18),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              );

            },)
        ],
      ),






      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            elevation: 35,
            backgroundColor: Colors.deepPurple.shade100,
            title: Center(child: Text("Create New Job Here!!",style:
            TextStyle(
                fontSize: 18,
            ),)),
            actions: [
              TextFormField(
                cursorColor: Colors.black45,
                controller:
                addCompanyController,
                style: TextStyle(
                ),
                decoration: InputDecoration(
                    label: Text(
                      "Enter Company",
                      style: TextStyle(
                          color: Colors.black87
                      ),

                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black45)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black45)
                    )
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                cursorColor: Colors.black45,
                controller: addPositionController,
                style: TextStyle(
                ),
                decoration: InputDecoration(
                    label: Text(
                      "Enter Position",
                      style: TextStyle(
                          color: Colors.black87
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black45),),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black45)
                    )
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        creatjob() ;

                      });

                    },
                    child: Container(
                      height: 30,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white38,

                      ),
                      child: Center(child: Text("Create")),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      addCompanyController.clear();
                      addPositionController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 30,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white38,

                      ),
                      child: Center(child: Text("Cancle")),
                    ),
                  ),
                ],
              )


            ],
          );
        },);


      },
        child: Icon(Icons.post_add_outlined,),
        backgroundColor: Colors.deepPurple.withOpacity(0.7),
        tooltip: "Create Job",
      ),
    );
  }
}
