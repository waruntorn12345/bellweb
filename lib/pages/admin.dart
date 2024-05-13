import 'package:admin/blocs/admin_bloc.dart';
import 'package:admin/utils/dialog.dart';
import 'package:admin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final formKey = GlobalKey<FormState>();
  var passwordOldCtrl = TextEditingController();
  var passwordNewCtrl = TextEditingController();
  bool changeStarted = false;

  Future handleChange() async {
    final ab = context.read<AdminBloc>();
    if (ab.userType == 'tester') {
      openDialog(context, 'You are a Tester',
          'Only Admin can upload, delete & modify contents');
    } else {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        setState(() {
          changeStarted = true;
        });
        await context
            .read<AdminBloc>()
            .saveNewAdminPassword(passwordNewCtrl.text)
            .then((value) =>
                openDialog(context, 'Password has changed successfully!', ''));
        setState(() {
          changeStarted = false;
        });
        clearTextFields();
      }
    }
  }

  clearTextFields() {
    passwordOldCtrl.clear();
    passwordNewCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final String? adminPass = context.watch<AdminBloc>().adminPass;
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              "เปลี่ยนรหัสผ่านผู้ดูแลระบบ",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 10),
              height: 3,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(15)),
            ),
            SizedBox(
              height: 100,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: passwordOldCtrl,
                    decoration: inputDecoration(
                        'ป้อนรหัสผ่านเก่า', 'รหัสผ่านเก่า', passwordOldCtrl),
                    validator: (String? value) {
                      if (value!.isEmpty) return 'รหัสผ่านเก่าว่างเปล่า!';
                      if (value != adminPass)
                        return 'รหัสผ่านเก่าไม่ถูกต้อง ลองอีกครั้ง';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: passwordNewCtrl,
                    decoration: inputDecoration(
                        'ใส่รหัสผ่านใหม่', 'รหัสผ่านใหม่', passwordNewCtrl),
                    obscureText: true,
                    validator: (String? value) {
                      if (value!.isEmpty) return 'รหัสผ่านใหม่ว่างเปล่า!';
                      if (value == adminPass) return 'โปรดใช้รหัสผ่านอื่น';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.deepPurpleAccent,
                      height: 45,
                      child: changeStarted == true
                          ? Center(
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator()),
                            )
                          : TextButton(
                              child: Text(
                                'อัปเดตรหัสผ่าน',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                handleChange();
                              })),
                ],
              ),
            )
          ],
        ));
  }
}
