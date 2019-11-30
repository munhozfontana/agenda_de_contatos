import 'package:agenda_de_contatos/helpers/ContactHelper.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    super.initState();
    Contact c = Contact();
    c.name = "Daniel Ciolfi22222";
    c.email = "daniel@gmail.com";
    c.phone = "61982062690";
    c.img = "imgtest";

    Future<Contact> contact = helper.save(c);

    helper.save(c);
    helper.list().then((list) {
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
