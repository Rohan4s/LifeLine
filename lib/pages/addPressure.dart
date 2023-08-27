import 'package:flutter/material.dart';
import 'package:lifeline/entities/pressureClass.dart';
import 'package:lifeline/helper/pressureHelper.dart';

class AddPressure extends StatefulWidget {
  const AddPressure({Key? key}) : super(key: key);

  @override
  State<AddPressure> createState() => _AddPressureState();
}

class _AddPressureState extends State<AddPressure> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  final TextEditingController pulseController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final weightAdded =  SnackBar(
      content: Text('Successfully Added Your Weight',style: TextStyle(color: Colors.blueGrey[900]),),
      backgroundColor: Colors.cyan[50],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pressure'),
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
                  decoration:
                      InputDecoration(labelText: 'Enter Systolic Pressure'),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'[0-9.]').hasMatch(value!)) {
                      return 'Cannot Be Empty';
                    }
                  },
                  controller: systolicController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Enter Diastolic Pressure'),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'[0-9.]').hasMatch(value!)) {
                      return 'Cannot Be Empty';
                    }
                  },
                  controller: diastolicController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter Pulse'),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'[0-9.]').hasMatch(value!)) {
                      return 'Cannot Be Empty';
                    }
                  },
                  controller: pulseController,
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
          if (formKey.currentState!.validate()) {
            int systolicPressure = int.parse(systolicController.text);
            int diastolicPressure = int.parse(diastolicController.text);
            int pulse = int.parse(pulseController.text);

            PressureClass pressure = PressureClass(
                systolicPressure: systolicPressure,
                diastolicPressure: diastolicPressure,
                pulse: pulse);

            PressureHelper.addPressure(pressure);

            if(!context.mounted)return;
            Navigator.of(context).pop(true);
            ScaffoldMessenger.of(context).showSnackBar(weightAdded);

            print('valid');
            print(systolicController.text);
            print(diastolicController.text);
            print(pulseController.text);
          } else {
            print('invalid');
            print(systolicController.text);
            print(diastolicController.text);
            print(pulseController.text);
          }
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
