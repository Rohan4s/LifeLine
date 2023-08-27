import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeline/entities/user.dart';
import 'package:lifeline/entities/weightClass.dart';
import 'package:lifeline/helper/userHelper.dart';
import 'package:lifeline/helper/weightHelper.dart';

class AddWeight extends StatefulWidget {
  @override
  State<AddWeight> createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  bool _empty = false;
  final weightController = TextEditingController();
  final weightAdded = SnackBar(
    content: Text(
      'Successfully Added Your Weight',
      style: TextStyle(color: Colors.blueGrey[900]),
    ),
    backgroundColor: Colors.cyan[50],
  );
  List<WeightClass> weights = [];

  @override
  void initState() {
    // TODO: implement initState
    getWeights();
    super.initState();
  }

  submit() async {
    double height = 1.5;
    List<User>? users = await UserHelper.getUser();
    if (users != null) height = users[0].height;
    print(height);
    print(weightController.text);

    // closes keyboard
    FocusManager.instance.primaryFocus?.unfocus();



    double inputWeight = double.parse(weightController.text);
    double bmi = inputWeight / (height * height);
    bmi = double.parse(bmi.toStringAsFixed(2));

    WeightClass newWeight = WeightClass(weight: inputWeight, bmi: bmi);

    int id = await WeightHelper.addWeight(newWeight,weights[0]);

    print('$id inserted');
    if (!context.mounted) return;
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context).showSnackBar(weightAdded);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Weight',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  setState(() {
                    _empty = weightController.text.isEmpty ? true : false;
                  });
                  if (_empty) {
                    return;
                  }
                  submit();
                },
                decoration: InputDecoration(
                  errorText: _empty ? 'You must enter your weight' : null,
                  labelText: "Enter your weight",
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.blueGrey[900],
                    ),
                    onPressed: submit,
                  ),
                ),
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final text = newValue.text;
                    return text.isEmpty
                        ? newValue
                        : double.tryParse(text) == null
                            ? oldValue
                            : newValue;
                  }),
                ],
              ),
            ],
          )),
    );
  }

  Future getWeights() async {
    List<WeightClass>? listWeights = await WeightHelper.getAllWeights();

    setState(() {
      if (listWeights == null) {
        weights = [];
      } else {
        weights = listWeights;
      }
    });
  }
}
