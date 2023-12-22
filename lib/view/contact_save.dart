import 'dart:io';

import 'package:contact_diary/provider/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ContactSave extends StatefulWidget {
  const ContactSave({super.key});
  @override

  State<ContactSave> createState() => _ContactSaveState();
}

class _ContactSaveState extends State<ContactSave> {
  ImagePicker picker = ImagePicker();
  XFile? xFile;

  // TextEditingController nameController = TextEditingController();
  // TextEditingController contactController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> fk = GlobalKey<FormState>();

  // bool isEdit = false;
  @override
  void initState() {
    Provider.of<ContactProvider>(context,listen:false).repair();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Next Page"),
      ),
      body: Form(
        key: fk,
        child: Consumer<ContactProvider>(
          builder: (BuildContext context, contactprovider, child) {
            return Stepper(
              currentStep: contactprovider.cIndex,
              onStepContinue: () {
                contactprovider.stepperContinue();
              },
              onStepCancel: () {
                contactprovider.stepperCancel();
              },
              onStepTapped: (value) {
                contactprovider.cIndex = value;
                contactprovider.stepperTapped();
              },
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    if (details.currentStep != 3)
                      ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text("Continue")),
                    SizedBox(
                      width: 10,
                    ),
                    if (details.currentStep != 0)
                      OutlinedButton(
                          onPressed: details.onStepCancel, child: Text("Back")),
                  ],
                );
              },
              steps: [
                Step(
                  title: Text("Step 1"),
                  content: TextFormField(
                    controller: contactprovider.nameController,
                    decoration: InputDecoration(hintText: "Name"),
                    onChanged: (value) {},
                  ),
                  label: Text("S1"),
                  isActive: contactprovider.cIndex >= 0,
                  state: (contactprovider.nameController.text.isEmpty &&
                          contactprovider.isEdit &&
                          contactprovider.cIndex != 0)
                      ? StepState.error
                      : StepState.complete,
                ),
                Step(
                  title: Text("Step 2"),
                  content: TextFormField(
                    controller: contactprovider.contactController,
                    decoration: InputDecoration(hintText: "Number"),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  state: (contactprovider.contactController.text.isEmpty &&
                          contactprovider.isEdit &&
                          contactprovider.cIndex != 1)
                      ? StepState.error
                      : StepState.complete,
                  isActive: contactprovider.cIndex >= 1,
                ),
                Step(
                  title: Text("Step 3"),
                  content: TextFormField(
                    controller: contactprovider.emailController,
                    decoration: InputDecoration(hintText: "Email"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (value) {
                    //   if (value?.isEmpty ?? true) {
                    //     return "Enter Email";
                    //   } else if (!isEmail(value ?? "")) {
                    //     return "Enter valid Email";
                    //   }
                    //   return null;
                    // },
                  ),
                  state: (contactprovider.emailController.text.isEmpty &&
                          contactprovider.isEdit &&
                          contactprovider.cIndex != 2)
                      ? StepState.error
                      : StepState.complete,
                  isActive: contactprovider.cIndex >= 2,
                ),
                Step(
                  title: Text("Step 4"),
                  content: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        maxRadius: 80,
                        backgroundImage: contactprovider.xFile != null
                            ? FileImage(
                                File(contactprovider.xFile?.path ?? ""),
                              )
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () {
                              contactprovider.stepperCamera();
                            }, icon: Icon(Icons.camera_alt)),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () {
                              contactprovider.stepperGallery();
                            },
                            icon: Icon(Icons.photo)),
                      ),
                    ],
                  ),
                  isActive: contactprovider.cIndex >= 3,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<ContactProvider>(context, listen: false).addcontact();
          Navigator.pop(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }
}
