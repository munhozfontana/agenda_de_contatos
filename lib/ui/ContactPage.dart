import 'dart:io';

import 'package:agenda_de_contatos/helpers/ContactHelper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editContact;
  bool userEditted = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editContact = Contact();
    } else {
      _editContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editContact.name;
      _emailController.text = _editContact.email;
      _phoneController.text = _editContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_editContact.name.isNotEmpty && _editContact.name != null) {
            Navigator.pop(context, _editContact);
          } else {
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editContact.img != null
                        ? FileImage(File(_editContact.img))
                        : ExactAssetImage('images/userLogout.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            TextField(
              focusNode: _nameFocus,
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nome",
              ),
              onChanged: (text) {
                userEditted = true;
                setState(() {
                  _editContact.name = text;
                });
              },
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
              ),
              onChanged: (text) {
                userEditted = true;
                _editContact.name = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Celular",
              ),
              onChanged: (text) {
                userEditted = true;
                _editContact.phone = text;
              },
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
