// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:contact_diary/provider/contact_provider.dart';
import 'package:contact_diary/view/contact_save.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modal/util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Diary"),
        centerTitle: true,
      ),
      body: Consumer<ContactProvider>(
        builder: (BuildContext context, contactprovider, child) {
          return ListView.builder(
            itemCount: contactprovider.contactList.length,
            itemBuilder: (context, index) {
              var contactModel = contactprovider.contactList[index];
              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    height: 73,
                    // color: Colors.blue,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          maxRadius: 40,
                          backgroundImage: contactModel.xFile != null
                              ? FileImage(
                                  File(contactModel.xFile!.path ?? ""),
                                )
                              : null,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contactModel.name ?? "",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(contactModel.number ?? ""),
                            Text(contactModel.email ?? ""),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 370, top: 25),
                    child: InkWell(
                      onTap: () {
                        contactprovider.contactList.removeAt(index);
                      },
                      child: Icon(Icons.delete),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "ContactSave");
        },
      ),
    );
  }
}
