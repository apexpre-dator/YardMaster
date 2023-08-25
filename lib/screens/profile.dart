import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
        RegExp regex = new RegExp(r'.{6,}$');

        if (value!.isEmpty) {
          return ("Please enter your Name!");
        }

        if (!regex.hasMatch(value)) {
          return ('Please enter a valid Username! Min. 6 characters!');
        }
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
        RegExp regex = new RegExp(r'.{6,}$');

        if (value!.isEmpty) {
          return ("Please enter the Yard name!");
        }

        if (!regex.hasMatch(value)) {
          return ('Please enter a valid Yarrd Name! Min. 6 characters!');
        }
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
        RegExp regex = new RegExp(r'.{6,}$');

        if (value!.isEmpty) {
          return ("Please enter your Employee ID!");
        }

        if (!regex.hasMatch(value)) {
          return ('Please enter a valid ID! Min. 6 characters!');
        }
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
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {},
        child: const Text(
          'Finish',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
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
                    // SizedBox(
                    //   height: 200,
                    //   child: Image.asset(
                    //     "assets/logo.png",
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                    const SizedBox(
                      height: 35,
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

  Future<void> fillUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      final _auth = FirebaseAuth.instance;
      final _fireStore = FirebaseFirestore.instance;

      User? user = _auth.currentUser;
      
    }
  }

  // postDetailsToFirestore() async {
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //   User? user = _auth.currentUser;

  //   UserModel userModel = UserModel();

  //   userModel.email = user!.email;
  //   userModel.uid = user.uid;
  //   userModel.userName = userNameController.text;
  //   userModel.address = 'Kanpur, Uttar Pradesh';
  //   userModel.pno = '7007144430';

  //   await firebaseFirestore
  //       .collection("users")
  //       .doc(user.uid)
  //       .set(userModel.toMap());

  //   Fluttertoast.showToast(msg: "Account created successfully!");
  //   Navigator.of(context).pushReplacementNamed(SecondHomeScreen.routeName);
  // }
}
