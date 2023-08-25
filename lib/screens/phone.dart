import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yms/screens/verify.dart';

class MyPhone extends StatefulWidget {
  static const routeName = '/phone';
  const MyPhone({Key? key}) : super(key: key);
  static String verify = '';
  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  String phone = '';
  // bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   countryController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img1.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      onChanged: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      // setState(() {
                      //   _isLoading = true;
                      // });
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: countryController.text + phone,
                        verificationCompleted:
                            (PhoneAuthCredential credential) {
                          Navigator.of(context).pushNamed('/');
                        },
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          // setState(() {
                          //   _isLoading = false;
                          // });
                          MyPhone.verify = verificationId;
                          Navigator.of(context).pushNamed(MyVerify.routeName);
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    child: const Text("Send the code")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
