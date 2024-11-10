import 'package:flutter/material.dart';
import 'package:hive_db_crud/login_page.dart';
import 'package:hive_flutter/adapters.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void registerUser(BuildContext context) {
    final box = Hive.box("show_box");
    final username = usernameController.text;
    final password = passwordController.text;

    if (box.containsKey(username)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Username already exists!")));
    } else {
      box.put(username, password);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User registered!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SignUp Page")),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => registerUser(context),
                  child: Text("Sign Up")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have a account"),
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                  }, child: Text('Login')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
