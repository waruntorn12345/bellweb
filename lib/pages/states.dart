import 'package:admin/blocs/admin_bloc.dart';
import 'package:admin/models/state.dart';
import 'package:admin/utils/dialog.dart';
import 'package:admin/utils/empty.dart';
import 'package:admin/utils/styles.dart';
import 'package:admin/utils/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class States extends StatefulWidget {
  const States({Key? key}) : super(key: key);

  @override
  _CitiesPageState createState() => _CitiesPageState();
}

class _CitiesPageState extends State<States> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<StateModel> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String collectionName = 'states';
  bool? _hasData;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection(collectionName)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
    else
      data = await firestore
          .collection(collectionName)
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible!['timestamp']])
          .limit(10)
          .get();

    if (data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasData = true;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => StateModel.fromFirestore(e)).toList();
        });
      }
    } else {
      if (_lastVisible == null) {
        setState(() {
          _isLoading = false;
          _hasData = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasData = true;
        });
        openToast(context, 'No more content available');
      }
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  refreshData() async {
    setState(() {
      _data.clear();
      _snap.clear();
      _lastVisible = null;
    });
    await _getData();
  }

  handleDelete(timestamp1) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(50),
            elevation: 0,
            children: <Widget>[
              Text('Delete?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
              SizedBox(
                height: 10,
              ),
              Text('Want to delete this item from the database?',
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Row(
                children: <Widget>[
                  TextButton(
                    style: buttonStyle(Colors.redAccent),
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      if (ab.userType == 'tester') {
                        Navigator.pop(context);
                        openDialog(context, 'You are a Tester',
                            'Only admin can delete contents');
                      } else {
                        await ab
                            .deleteContent(timestamp1, collectionName)
                            .then((value) => ab.getStates())
                            .then((value) => ab.decreaseCount('states_count'))
                            .then((value) =>
                                openToast(context, 'Deleted Successfully'));
                        refreshData();
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    style: buttonStyle(Colors.deepPurpleAccent),
                    child: Text(
                      'No',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'แหล่งท่องเที่ยว',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
            Container(
              width: 300,
              height: 40,
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(30)),
              child: TextButton.icon(
                  onPressed: () {
                    openAddDialog();
                  },
                  icon: Icon(LineIcons.list),
                  label: Text('เพิ่มแหล่งท่องเที่ยว')),
            ),
          ],
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
          height: 30,
        ),
        Expanded(
          child: _hasData == false
              ? EmptyPage(
                  icon: Icons.content_paste,
                  message: 'ไม่พบสถานะ\nอัปโหลดสถานะก่อน!')
              : RefreshIndicator(
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    controller: controller,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: _data.length + 1,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (_, int index) {
                      if (index < _data.length) {
                        return dataList(_data[index]);
                      }
                      return Center(
                        child: new Opacity(
                          opacity: _isLoading ? 1.0 : 0.0,
                          child: new SizedBox(
                              width: 32.0,
                              height: 32.0,
                              child: new CircularProgressIndicator()),
                        ),
                      );
                    },
                  ),
                  onRefresh: () async {
                    refreshData();
                  },
                ),
        ),
      ],
    );
  }

  Widget dataList(StateModel d) {
    return Container(
      height: 130,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: CachedNetworkImageProvider(d.thumbnailUrl!),
              fit: BoxFit.cover)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            d.name!,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          Spacer(),
          InkWell(
            child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.edit, size: 16, color: Colors.grey[800])),
            onTap: () => openEditDialog(d.name!, d.thumbnailUrl!, d.timestamp!),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.delete, size: 16, color: Colors.grey[800])),
            onTap: () => handleDelete(d.timestamp),
          )
        ],
      ),
    );
  }

  // add/upload states

  var formKey = GlobalKey<FormState>();
  var nameCtrl = TextEditingController();
  var thumbnailCtrl = TextEditingController();
  String? timestamp;

  Future addState() async {
    final DocumentReference ref =
        firestore.collection(collectionName).doc(timestamp);
    await ref.set({
      'name': nameCtrl.text,
      'thumbnail': thumbnailCtrl.text,
      'timestamp': timestamp
    });
  }

  handleAddState() async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (ab.userType == 'tester') {
        Navigator.pop(context);
        openDialog(context, 'You are a Tester', 'Only admin can add contents');
      } else {
        await getTimestamp()
            .then((value) => addState())
            .then((value) =>
                context.read<AdminBloc>().increaseCount('states_count'))
            .then((value) => openToast(context, 'Added Successfully'))
            .then((value) => ab.getStates());
        refreshData();
        Navigator.pop(context);
      }
    }
  }

  clearTextfields() {
    nameCtrl.clear();
    thumbnailCtrl.clear();
  }

  Future getTimestamp() async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      timestamp = _timestamp;
    });
  }

  openAddDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(100),
            children: <Widget>[
              Text(
                'เพิ่มแหล่งท่องเที่ยวในฐานข้อมูล',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: inputDecoration('ป้อนชื่อแหล่งท่องเที่ยว',
                            'ชื่อแหล่งท่องเที่ยว', nameCtrl),
                        controller: nameCtrl,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'ชื่อแหล่งท่องเที่ยวว่างเปล่า';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: inputDecoration('ป้อน URL รูปขนาดย่อ',
                            'URL รูปขนาดย่อ', thumbnailCtrl),
                        controller: thumbnailCtrl,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'URL ของภาพขนาดย่อว่างเปล่า';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                          child: Row(
                        children: <Widget>[
                          TextButton(
                            style: buttonStyle(Colors.deepPurpleAccent),
                            child: Text(
                              'เพิ่มแหล่งท่องเที่ยว',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              await handleAddState();
                              clearTextfields();
                            },
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            style: buttonStyle(Colors.redAccent),
                            child: Text(
                              'ยกเลิก',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ))
                    ],
                  ))
            ],
          );
        });
  }

  //update/edit states

  var nameCtrl1 = TextEditingController();
  var thumbnailCtrl1 = TextEditingController();
  var formKey1 = GlobalKey<FormState>();

  Future _updateState(String stateTimestamp) async {
    final DocumentReference ref =
        firestore.collection(collectionName).doc(stateTimestamp);
    await ref.update({
      'name': nameCtrl1.text,
      'thumbnail': thumbnailCtrl1.text,
    });
  }

  Future _handleUpdateState(String stateTimestamp) async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    if (formKey1.currentState!.validate()) {
      formKey1.currentState!.save();
      if (ab.userType == 'tester') {
        Navigator.pop(context);
        openDialog(context, 'You are a Tester', 'Only admin can update states');
      } else {
        await _updateState(stateTimestamp)
            .then((value) => openToast(context, 'Updated Successfully'))
            .then((value) => ab.getStates());
        refreshData();
        Navigator.pop(context);
      }
    }
  }

  void openEditDialog(
      String oldStateName, String oldThumbnailUrl, String stateTimestamp) {
    showDialog(
        context: context,
        builder: (context) {
          nameCtrl1.text = oldStateName;
          thumbnailCtrl1.text = oldThumbnailUrl;

          return SimpleDialog(
            contentPadding: EdgeInsets.all(100),
            children: <Widget>[
              Text(
                'แก้ไข/อัปเดตสถานะในฐานข้อมูล',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                  key: formKey1,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: inputDecoration('ป้อนชื่อแหล่งท่องเที่ยว',
                            'ชื่อแหล่งท่องเที่ยว', nameCtrl1),
                        controller: nameCtrl1,
                        validator: (value) {
                          if (value!.isEmpty) return 'ชื่อว่างเปล่า';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: inputDecoration('ป้อน URL รูปขนาดย่อ',
                            'URL รูปขนาดย่อ', thumbnailCtrl1),
                        controller: thumbnailCtrl1,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'URL ของภาพขนาดย่อว่างเปล่า';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                          child: Row(
                        children: <Widget>[
                          TextButton(
                            style: buttonStyle(Colors.purpleAccent),
                            child: Text(
                              'อัพเดทสถานที่ท่องเที่ยว',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async =>
                                _handleUpdateState(stateTimestamp),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            style: buttonStyle(Colors.redAccent),
                            child: Text(
                              'ยกเลิก',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ))
                    ],
                  ))
            ],
          );
        });
  }
}
