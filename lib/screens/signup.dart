import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yms/colours.dart';
import 'package:yms/models/user_model.dart';
import 'package:yms/screens/home.dart';
import 'package:yms/screens/phone.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup-screen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final empIdController = TextEditingController();
  final yardNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userNameField = TextFormField(
      autofocus: false,
      controller: userNameController,
      validator: (value) {
        RegExp regex = RegExp(r'.{6,}$');

        if (value!.isEmpty) {
          return ("Please enter your Name!");
        }

        if (!regex.hasMatch(value)) {
          return ('Please enter a valid Username! Min. 6 characters!');
        }
        return null;
      },
      keyboardType: TextInputType.name,
      onSaved: (val) {
        userNameController.text = val!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Full Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email!");
        }
        // if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
        //   return ("Please enter a valid email!");
        // }
        return null;
      },
      onSaved: (val) {
        emailController.text = val!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email Address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final yardNameField = TextFormField(
      autofocus: false,
      controller: yardNameController,
      validator: (value) {
        RegExp regex = RegExp(r'.{6,}$');

        if (value!.isEmpty) {
          return ("Please enter the Yard name!");
        }

        if (!regex.hasMatch(value)) {
          return ('Please enter a valid Yarrd Name! Min. 6 characters!');
        }
        return null;
      },
      keyboardType: TextInputType.name,
      onSaved: (val) {
        yardNameController.text = val!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Yard Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final empIdField = TextFormField(
      autofocus: false,
      controller: empIdController,
      validator: (value) {
        RegExp regex = RegExp(r'.{6,}$');

        if (value!.isEmpty) {
          return ("Please enter your Employee ID!");
        }

        if (!regex.hasMatch(value)) {
          return ('Please enter a valid ID! Min. 6 characters!');
        }
        return null;
      },
      keyboardType: TextInputType.name,
      onSaved: (val) {
        empIdController.text = val!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Employee ID",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final signUpButton = Material(
      elevation: 5,
      color: darkColor,
      borderRadius: BorderRadius.circular(15),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width - 150,
        onPressed: () {
          fillUp();
        },
        child: const Text(
          'Setup Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "assets/profile.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Setup your Profile details'),
                    const SizedBox(
                      height: 25,
                    ),
                    userNameField,
                    const SizedBox(
                      height: 15,
                    ),
                    emailField,
                    const SizedBox(
                      height: 15,
                    ),
                    empIdField,
                    const SizedBox(
                      height: 15,
                    ),
                    yardNameField,
                    const SizedBox(
                      height: 25,
                    ),
                    signUpButton,
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fillUp() async {
    if (_formKey.currentState!.validate()) {
      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;

      User? user = auth.currentUser;

      UserModel userModel = UserModel(
        name: userNameController.text,
        email: emailController.text,
        empId: empIdController.text,
        uid: user!.uid,
        yardName: yardNameController.text,
        phone: MyPhone.phone,
      );

      await fireStore.collection('users').doc(user.uid).set(userModel.toJson());
      Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
    }
  }
}
