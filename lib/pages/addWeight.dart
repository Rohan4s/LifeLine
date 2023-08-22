import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeline/entities/weightClass.dart';
import 'package:lifeline/helper/weightHelper.dart';

class AddWeight extends StatefulWidget {
  const AddWeight({Key? key}) : super(key: key);
  @override
  State<AddWeight> createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  final weightController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // weightController.addListener(() {
    //   print(weightController.text);
    // });
    super.initState();
  }

  submit() async {
    double height = 1.52;
    print(weightController.text);
    FocusManager.instance.primaryFocus?.unfocus();

    double weight = double.parse(weightController.text);
    double bmi = weight / (height * height);
    bmi = double.parse(bmi.toStringAsFixed(2));
    WeightClass weightModel = WeightClass(weight: weight, bmi: bmi);
    int id = await WeightDBhelper.addNote(weightModel);
    print('$id inserted');
    if(!context.mounted)return;
    Navigator.of(context).pop(true);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Weight'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                textInputAction: TextInputAction.send,
                onSubmitted: (value){
                  submit();
                },
                decoration: InputDecoration(

                  labelText: "Enter your weight",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: submit,
                  ),
                ),
                controller: weightController,
                keyboardType: TextInputType.numberWithOptions(
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

  Widget pickImageButton(
      {required String text,
      required IconData icon,
      required VoidCallback onClick}) {
    return Container(
      child: ElevatedButton.icon(
          onPressed: onClick, icon: Icon(icon), label: Text(text)),
    );
  }
}
