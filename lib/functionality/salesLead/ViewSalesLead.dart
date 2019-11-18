import 'package:flutter/material.dart';

class PreviewSalesLead extends StatefulWidget {
  var datalist;
  PreviewSalesLead(this.datalist);
  @override
  _PreviewSalesLeadState createState() => _PreviewSalesLeadState(datalist);
}

class _PreviewSalesLeadState extends State<PreviewSalesLead> {
  var dataList;
  _PreviewSalesLeadState(this.dataList);
  String customerName,
      requirement,
      contactName,
      contactDesignation,
      contactEmail,
      contactMobile;
  var referalPerson;

  @override
  void initState() {
    super.initState();
    getProfileName();
  }

  void getProfileName() {
    setState(() {
      customerName = dataList.srCustomerName;
      requirement = dataList.srRequirement;
      contactName = dataList.srContactName;
      contactEmail = dataList.srContactEmail;
      contactDesignation = dataList.srDesignation;
      contactMobile = dataList.srPhoneNo;
      referalPerson = dataList.referredByFullName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            dataList.srNo.toString(),
            style: TextStyle(color: Colors.white, fontSize: 15),
          )),
      body: Container(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: customerName),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Customer Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: requirement),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Requirement",
                  prefixIcon: Icon(Icons.assignment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: contactName),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Contact Name",
                  prefixIcon: Icon(Icons.account_box),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: contactDesignation),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Contact Designation",
                  prefixIcon: Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: contactEmail),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Contact Email",
                  prefixIcon: Icon(Icons.contact_mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: contactMobile),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Contact Mobile",
                  prefixIcon: Icon(Icons.phone_android),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: referalPerson),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
