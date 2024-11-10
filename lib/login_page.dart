import 'package:flutter/material.dart';
import 'package:hive_db_crud/home_page.dart';
import 'package:hive_db_crud/signup_page.dart';
import 'package:hive_flutter/adapters.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginUser(BuildContext context) {
    final box = Hive.box("show_box");
    final username = usernameController.text;
    final password = passwordController.text;

    if (box.containsKey(username)) {
      final storedPassword = box.get(username);

      if (storedPassword == password) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login Successful")));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Failed: Incorrect Password")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: Username not found")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
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
                onPressed: () => loginUser(context),
                child: const Text("Login"),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SignupPage()));
                    },
                    child: const Text("SignUp"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
