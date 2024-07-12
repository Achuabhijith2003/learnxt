import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(child: Text("LearnXT")),
      // ),
      body: SafeArea(
        child: Container(
          //  height: 250,
        // width: double.maxFinite,
        //  margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const  DecorationImage(
            image:  AssetImage("assets/download (2).jpeg"),
            fit: BoxFit.cover,
          ),
        ),
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Image.asset("assets/backgrondimage.jpg"),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  //  const   Text("EmailID"),
                const  Padding(
                    padding:  EdgeInsets.only(top: 10, left: 20, right: 20),
                    child:  TextField(
                      decoration: InputDecoration(
                          hintText: "Enter your EmailID",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)))),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  // const  Text("Password"),
                  const Padding(
                     padding:  EdgeInsets.only(top: 10, left: 20, right: 20),
                     child: TextField(
                      decoration: InputDecoration(
                          hintText: "Enter your Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)))),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      style: TextStyle(fontSize: 20),
                                 ),
                   ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: () {}, child: const Text("Login")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() {}
}
