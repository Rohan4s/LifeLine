
import 'package:appointment/db/med_db_helper.dart';
import 'package:appointment/models/medicine.dart';
import 'package:appointment/models/medicine.dart';
import 'package:appointment/models/medicine.dart';
import 'package:appointment/models/medicine.dart';
import 'package:appointment/models/medicine.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class MedicineController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }
  var medicineList=<Medicine>[].obs;

  Future<int>addMedicine({Medicine? medicine})async{
    return await DBHelperMedicine.insert(medicine!);
  }

  void getMedicines()async{
    List<Map<String,dynamic>>medicines=await DBHelperMedicine.query();
    medicineList.assignAll(medicines.map((data) => new Medicine.fromJson(data)).toList());
  }

  void delete(Medicine medicine){
    DBHelperMedicine.delete(medicine);
    getMedicines();

  }
  void markTaskCompleted(int id)async{
    await DBHelperMedicine.update(id);
    getMedicines();
  }


}