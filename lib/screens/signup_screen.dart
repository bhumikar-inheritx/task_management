import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/screens/login_screen.dart';
import 'package:task_manager_app/utils/validators.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/task_provider.dart';
import '../shared_prefs/storage.dart';
import 'dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late final TextEditingController name;
  late final TextEditingController numEmail;
  late final TextEditingController pass;



  Future<void> _signup() async {
    if (_formkey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      String emailOrPhone = numEmail.text.trim();

     
      final users = await Storage.getUser(); 
      bool alreadyExists = users.any((u) => u.emailOrPhone == emailOrPhone);

      if (alreadyExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Already have an account from this Email/Phone")),
        );
        return;
      }

   
      users.add(User(emailOrPhone: emailOrPhone, task: []));
      await Storage.saveUser(users);

      await prefs.setString('emailOrPhone', emailOrPhone);
      await prefs.setBool('loggedIn', true);


      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      await taskProvider.loadUserTasks(emailOrPhone);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    numEmail = TextEditingController();
    pass = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    name.clear();
    numEmail.clear();
    pass.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_3_sharp, color: Colors.white, size: 100),
            Container(
              width: 350,
              height: 600,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.circular(20),
                color: Colors.white,
              ),
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 30,
                    children: [
                      Text(
                        "Signup",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                          fontSize: 40,
                        ),
                      ),
                      TextFormField(
                        controller: name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: "Enter your Name",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigoAccent),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter Name";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: numEmail,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: "Email or Phone number",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigoAccent),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter Email or Phone number";
                          }
                          if (!value.trim().isValidEmailOrPhone()) {
                            return "Enter valid Email or 10-digit phone number";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: pass,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigoAccent),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter Password";
                          }
                          if (!value.trim().isValidPassword()) {
                            return "Password must be 8+ chars, include "
                                "upper,\n lower, digit, special char";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                          ),
                          child: Text(
                            "Signup",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account ?  ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Colors.indigoAccent,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
