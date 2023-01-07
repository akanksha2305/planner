import 'package:planner/constants/constants.dart';
import 'package:planner/helper/helperFunctions.dart';
import 'package:planner/pages/login.dart';
// import 'package:planner/pages/profile.dart';
import 'package:planner/pages/register.dart';
// import 'package:planner/pages/settings.dart';
import 'package:planner/services/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:planner/services/authServices.dart';
import 'package:planner/models/buildRow.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentIndex = 0;

  String userName = "";
  String email = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNamefromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Welcome!",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                onPressed: () {
                  logOut();
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //SearchMethod();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(20),

                      // ),
                      child: Expanded(
                        child: TextField(
                          //controller: searchController,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w300,
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Groups...",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: "Lexend",
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(161, 117, 97, 2).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () {
                          _eventURL();
                        },
                        icon: Icon(Icons.add),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // isLoading
            //     ? Center(
            //         child: CircularProgressIndicator(
            //           color: Theme.of(context).primaryColor,
            //         ),
            //       )
            //     : groupList(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(15),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 55, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.home,
                      color: Constants.activeColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.calendar_month,
                      size: 30,
                      color: Constants.inactiveColor,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),
                  IconButton(
                    onPressed: () {
                      // nextScreen(
                      //   context,
                      //   Profile(userName: userName, email: email),
                      // );
                    },
                    icon: Icon(
                      Icons.person,
                      color: Constants.inactiveColor,
                      size: 30,
                    ),
                  ),
                ],
              )),
        ));
  }

  logOut() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 238, 182, 157),
            title: const Text(
              "LogOut",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Lexend",
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Are you sure you want to logout?",
              style: TextStyle(color: Colors.black, fontFamily: "Lexend"),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await authService.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false);
                },
                icon: const Icon(
                  Icons.done,
                  color: Color.fromARGB(255, 2, 128, 54),
                ),
              ),
            ],
          );
        });
  }

  _eventURL() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 20,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                  child: Text(
                'Your Events',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Lexend",
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              )),
              SizedBox(height: 20),
              _buildRow('assets/images/event1.png', 'Event 1',
                  'Description of the event'),
              _buildRow('assets/images/event2.png', 'Event 2',
                  'Description of the event'),
              _buildRow('assets/images/event3.png', 'Event 3',
                  'Description of the event'),
              _buildRow('assets/images/general.png', 'General',
                  'Just all unfiltered ideas'),
              SizedBox(
                height: 10,
                width: 10,
              ),
              Container(
                padding: EdgeInsets.all(5),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              "Add to Tags",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: "Lexend",
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.35,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              "Add to Events",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Lexend",
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(String imageAsset, String name, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Container(height: 2, color: Colors.grey[100]),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  // For adding into the events
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white10,
                  backgroundImage: AssetImage(imageAsset),
                ),
              ),
              SizedBox(width: 20),
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )),
              Spacer(),
              GestureDetector(
                onTap: () {
                  // calls the function to edit the event
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Image.asset(
                    'assets/icons/edit.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
