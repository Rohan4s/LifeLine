import 'package:flutter/material.dart';
import 'package:lifeline/entities/user.dart';
import 'package:lifeline/helper/userHelper.dart';
import 'Home.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    signedUp(context);
  }

  Future<void> signedUp(BuildContext context) async {

    List<User>? users = await UserHelper.getUser();
    if (users != null && users.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final setupProfile = SnackBar(
      content: Text(
        'Successfully created your account',
        style: TextStyle(color: Colors.blueGrey[900]),
      ),
      backgroundColor: Colors.cyan[50],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.04,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter Your Name'),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'[0-9.]').hasMatch(value!)) {
                      return 'Cannot Be Empty';
                    }
                  },
                  controller: nameController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter Your Email'),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'[0-9.]').hasMatch(value!)) {
                      return 'Cannot Be Empty';
                    }
                  },
                  controller: emailController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter Your Age'),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'[0-9.]').hasMatch(value!)) {
                      return 'Cannot Be Empty';
                    }
                  },
                  controller: ageController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter Your height'),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'[0-9.]').hasMatch(value!)) {
                      return 'Cannot Be Empty';
                    }
                  },
                  controller: heightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          User user = User(
              name: nameController.text.isEmpty ? ' ' : nameController.text,
              email: emailController.text.isEmpty ? ' ' : emailController.text,
              age: ageController.text.isEmpty
                  ? 0
                  : int.parse(ageController.text),
              height:
                  heightController.text.isEmpty ? 0 : double.parse(heightController.text));
          UserHelper.addUser(user);
          print(user.height);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
          // if (formKey.currentState!.validate()) {
          //   int systolicPressure = int.parse(systolicController.text);
          //   int diastolicPressure = int.parse(diastolicController.text);
          //   int pulse = int.parse(pulseController.text);
          //
          //   PressureClass pressure = PressureClass(
          //       systolicPressure: systolicPressure,
          //       diastolicPressure: diastolicPressure,
          //       pulse: pulse);
          //
          //   PressureHelper.addPressure(pressure);
          //
          //   if(!context.mounted)return;
          //   Navigator.of(context).pop(true);
          //   ScaffoldMessenger.of(context).showSnackBar(setupProfile);
          //
          //   print('valid');
          //   print(systolicController.text);
          //   print(diastolicController.text);
          //   print(pulseController.text);
          // } else {
          //   print('invalid');
          //   print(systolicController.text);
          //   print(diastolicController.text);
          //   print(pulseController.text);
          // }
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
