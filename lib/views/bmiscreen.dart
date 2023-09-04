import 'package:flutter/material.dart';

import '../functions/bmifunctions.dart';
import '../models/bmidatamodel.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final appfunctions = Functions();
  final userDetailsForm = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  var selectedGender;
  DateTime? selectedBirthDay;
  var bmi = 0.0;
  var bmiComment = '';
  String age = '';

  String data = '';
  bool displayUserData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 186, 198),
      //appbar
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                child: Form(
                  key: userDetailsForm,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'User Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          const Text('Gender:'),
                          const Icon(Icons.male),
                          const Text('Male'),
                          Radio(
                            value: "Male",
                            groupValue: selectedGender,
                            onChanged: (value) {
                              selectedGender = value!;
                              setState(() {});
                            },
                          ),
                          const Icon(Icons.male),
                          const Text('Female'),
                          Radio(
                            value: "Female",
                            groupValue: selectedGender,
                            onChanged: (value) {
                              selectedGender = value!;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(children: [
                        Text(
                          selectedBirthDay == null
                              ? 'Select Birthday'
                              : 'Birthday: ${selectedBirthDay!.year}-${selectedBirthDay!.month}-${selectedBirthDay!.day}',
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_view_day),
                          onPressed: () {
                            _showDatePicker();
                          },
                        ),
                      ]),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          prefixIcon: Icon(Icons.balance),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your weight';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Height (cm)',
                          prefixIcon: Icon(Icons.straighten),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your height';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (userDetailsForm.currentState!.validate()) {
                                  printData();
                                  calculateBmi();
                                  calculateAge();
                                  setState(() {
                                    displayUserData = true;
                                  });
                                  final bmidata = BmiDatModel(
                                      name: nameController.text,
                                      address: addressController.text,
                                      gender: selectedGender,
                                      bmi: bmi.toString(),
                                      bmiComment: bmiComment);
                                  appfunctions.addBmiData(bmidata);
                                }
                              },
                              child: const Text("Submit"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                clearFields();
                                setState(() {
                                  displayUserData = false;
                                });
                              },
                              child: const Text("Reset Fields"),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: displayUserData,
                        child: Column(
                          children: [
                            Text(nameController.text ?? ''),
                            Text(addressController.text ?? ''),
                            Text(bmi.toStringAsFixed(2) ?? ''),
                            Text(bmiComment ?? ''),
                            Text(age ?? ''),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearFields() {
    nameController.clear();
    addressController.clear();
    weightController.clear();
    heightController.clear();
  }

  void _showDatePicker() async {
    final currentDate = DateTime.now();
    final initialDate = selectedBirthDay ?? currentDate;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (selectedDate != null) {
      setState(() {
        selectedBirthDay = selectedDate;
      });
    }
  }

  void calculateBmi() {
    double weight = double.tryParse(weightController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0;
    bmi = weight / ((height / 100) * (height / 100));
    bmiComment = bmiValueComment(bmi);
  }

  String bmiValueComment(double bmi) {
    if (bmi < 16) {
      return 'Underweight';
    } else if (bmi >= 16 && bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  void calculateAge() {
    if (selectedBirthDay != null) {
      final today = DateTime.now();
      final ageInDays = today.difference(selectedBirthDay!).inDays;
      final ageInYears = (ageInDays / 365).floor();
      age = '$ageInYears';
    }
  }

  void printData() {
    print(nameController.text);
    print(addressController.text);
    print(selectedGender);
    print(selectedBirthDay);
    print(bmi);
    print(bmiComment);
  }
}
