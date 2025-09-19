import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/screens/dashboard_screen.dart';
import 'package:task_manager_app/screens/signup_screen.dart';
import 'package:task_manager_app/utils/validators.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../shared_prefs/storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late final TextEditingController numEmail;
  late final TextEditingController pass;

  @override
  void initState() {
    super.initState();
    numEmail = TextEditingController();
    pass = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    numEmail.clear();
    pass.clear();
  }


  Future<void> _login() async {
    if (_formkey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      String emailOrPhone = numEmail.text.trim();

      // Get all users
      final users = await Storage.getUser();
      final user = users.where((u) => u.emailOrPhone == emailOrPhone).toList();

      if (user.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid credentials")),
        );
        return;
      }

      // Login successful
      await prefs.setBool('loggedIn', true);
      await prefs.setString('emailOrPhone', emailOrPhone);

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      await taskProvider.loadUserTasks(emailOrPhone);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_3_sharp,color: Colors.white,size: 100,),
               Container(
                width: 350,
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(20),
                    color: Colors.white,

                ),
                 child: Form(
                   key: _formkey,
                   child: Padding(
                     padding: const EdgeInsets.only(top: 30,right: 20,left: 20),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 30,
                        children: [
                          Text("Login",style: TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w800,letterSpacing: 3,
                              fontSize: 40,),),

                            TextFormField(
                              controller: numEmail,
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                              decoration: InputDecoration(
                                hintText: "Email or Phone number",
                                border: OutlineInputBorder(borderSide: BorderSide
                                  (color: Colors.indigoAccent),borderRadius:
                                BorderRadius.all(Radius.circular(30)))
                              ),
                              validator: (value) {
                                if(value==null || value.trim().isEmpty){
                                  return "Please enter Email or Phone number";
                                }
                                if(!value.trim().isValidEmailOrPhone()){
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
                              border: OutlineInputBorder(borderSide: BorderSide
                                (color: Colors.indigoAccent),borderRadius:
                              BorderRadius.all(Radius.circular(30))),
                            ),
                            validator: (value) {
                              if(value==null || value.trim().isEmpty){
                                return "Please enter Password";
                              }
                              if(!value.trim().isValidPassword()){
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigoAccent,
                              ), child: Text("Login",style: TextStyle(fontSize:
                            20,fontWeight: FontWeight.bold,color: Colors.white),
                            )
                            ),
                          ),
                        RichText(text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account ? ",style:
                        TextStyle(color: Colors
                            .black,fontSize: 15, fontWeight:
                            FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'Signup',style:
                            TextStyle(color: Colors
                                .indigoAccent,fontSize: 15, fontWeight:
                                FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                ..onTap = (){
                                  Navigator.pushReplacement(context, MaterialPageRoute
                                    (builder: (context) => SignupScreen(),));
                                }
                            )
                          ]
                        ))
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
