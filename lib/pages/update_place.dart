import 'package:admin/blocs/admin_bloc.dart';
import 'package:admin/models/place.dart';
import 'package:admin/utils/dialog.dart';
import 'package:admin/utils/snacbar.dart';
import 'package:admin/utils/styles.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/widgets/cover_widget.dart';
import 'package:admin/widgets/place_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePlace extends StatefulWidget {
  final Place placeData;
  UpdatePlace({Key? key, required this.placeData}) : super(key: key);

  @override
  _UpdatePlaceState createState() => _UpdatePlaceState();
}

class _UpdatePlaceState extends State<UpdatePlace> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  // var scaffoldKey = GlobalKey<ScaffoldState>();
  final String collectionName = 'places';
  List? paths = [];
  List? paths1 = [];
  List? paths2 = [];
  String _helperText =
      'ป้อนรายการเส้นทางเพื่อช่วยให้ผู้ใช้ไปยังปลายทางที่ต้องการ เช่น';
  String _helperText1 =
      'ป้อนรายการเส้นทางเพื่อช่วยให้ผู้ใช้ไปยังปลายทางที่ต้องการ เช่น';
  String _helperText2 =
      'ป้อนรายการเส้นทางเพื่อช่วยให้ผู้ใช้ไปยังปลายทางที่ต้องการ เช่น';
  bool uploadStarted = false;
  var stateSelection;

  var nameCtrl = TextEditingController();
  var locationCtrl = TextEditingController();
  var descriptionCtrl = TextEditingController();
  var image1Ctrl = TextEditingController();
  var image2Ctrl = TextEditingController();
  var image3Ctrl = TextEditingController();
  var latCtrl = TextEditingController();
  var lngCtrl = TextEditingController();

  var startpointNameCtrl = TextEditingController();
  var endpointNameCtrl = TextEditingController();
  var priceCtrl = TextEditingController();
  var startpointName1Ctrl = TextEditingController();
  var endpointName1Ctrl = TextEditingController();
  var startpointName2Ctrl = TextEditingController();
  var endpointName2Ctrl = TextEditingController();
  var pathsCtrl = TextEditingController();
  var paths1Ctrl = TextEditingController();
  var paths2Ctrl = TextEditingController();
  var NameCtrl = TextEditingController();
  var detailCtrl = TextEditingController();
  var imageCtrl = TextEditingController();
  var latitudeCtrl = TextEditingController();
  var longitudeCtrl = TextEditingController();
  var radiusCtrl = TextEditingController();
  var audioUrlCtrl = TextEditingController();
  var id = TextEditingController();
  clearFields() {
    nameCtrl.clear();
    locationCtrl.clear();
    descriptionCtrl.clear();
    image1Ctrl.clear();
    image2Ctrl.clear();
    image3Ctrl.clear();
    latCtrl.clear();
    lngCtrl.clear();
    startpointNameCtrl.clear();
    endpointNameCtrl.clear();
    priceCtrl.clear();
    startpointName1Ctrl.clear();
    endpointName1Ctrl.clear();
    startpointName2Ctrl.clear();
    endpointName2Ctrl.clear();
    pathsCtrl.clear();
    paths1Ctrl.clear();
    paths2Ctrl.clear();
    paths!.clear();
    paths1!.clear();
    paths2!.clear();
    FocusScope.of(context).unfocus();
  }

  void handleSubmit() async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    if (stateSelection == null) {
      openDialog(context, 'เลือกแหล่งท่องเที่ยวก่อน', '');
    } else {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        if (paths!.length == 0) {
          openSnacbar(scaffoldKey, 'รายการเส้นทางต้องไม่ว่างเปล่า');
        } else {
          if (ab.userType == 'tester') {
            openDialog(context, 'You are a Tester',
                'Only Admin can upload, delete & modify contents');
          } else {
            setState(() => uploadStarted = true);
            await saveToDatabase();
            setState(() => uploadStarted = false);
            openDialog(context, 'อัปโหลดสำเร็จ', '');
            //clearFields();
          }
        }
      }
    }
  }

  Future saveToDatabase() async {
    final DocumentReference ref =
        firestore.collection(collectionName).doc(widget.placeData.timestamp);
    final DocumentReference ref1 = firestore
        .collection(collectionName)
        .doc(widget.placeData.timestamp)
        .collection('travel guide')
        .doc(widget.placeData.timestamp);
    final DocumentReference ref2 = firestore
        .collection(collectionName)
        .doc(widget.placeData.timestamp)
        .collection('travel guide1')
        .doc(widget.placeData.timestamp);
    final DocumentReference ref3 = firestore
        .collection(collectionName)
        .doc(widget.placeData.timestamp)
        .collection('travel guide2')
        .doc(widget.placeData.timestamp);
    var _placeData = {
      'state': stateSelection,
      'place name': nameCtrl.text,
      'location': locationCtrl.text,
      'latitude': double.parse(latCtrl.text),
      'longitude': double.parse(lngCtrl.text),
      'description': descriptionCtrl.text,
      'image-1': image1Ctrl.text,
      'image-2': image2Ctrl.text,
      'image-3': image3Ctrl.text,
    };

    var _guideData = {
      'startpoint name': startpointNameCtrl.text,
      'endpoint name': endpointNameCtrl.text,
      'price': priceCtrl.text,
      'paths': paths,
    };
    var _guideData1 = {
      'startpoint name': startpointName1Ctrl.text,
      'endpoint name': endpointName1Ctrl.text,
      'paths1': paths1,
    };
    var _guideData2 = {
      'startpoint name': startpointName2Ctrl.text,
      'endpoint name': endpointName2Ctrl.text,
      'paths2': paths2,
    };
    await ref.update(_placeData).then((value) => ref1.update(_guideData).then(
        (value) => ref2
            .update(_guideData1)
            .then((value) => ref3.update(_guideData2))));
  }

  Future getGuideData() async {
    firestore
        .collection(collectionName)
        .doc(widget.placeData.timestamp)
        .collection('travel guide')
        .doc(widget.placeData.timestamp)
        .get()
        .then((DocumentSnapshot snap) {
      Map x = snap.data() as Map<dynamic, dynamic>;
      startpointNameCtrl.text = x['startpoint name'];
      endpointNameCtrl.text = x['endpoint name'];

      setState(() {
        paths = x['paths'];
      });
      NameCtrl.text = x['name'];
      latitudeCtrl.text = x['latitude'].toString();
      longitudeCtrl.text = x['longitude'].toString();
      imageCtrl.text = x['image'];
      detailCtrl.text = x['detail'];
      audioUrlCtrl.text = x['audioUrl'];
    });
    firestore
        .collection(collectionName)
        .doc(widget.placeData.timestamp)
        .collection('travel guide1')
        .doc(widget.placeData.timestamp)
        .get()
        .then((DocumentSnapshot snap) {
      Map x = snap.data() as Map<dynamic, dynamic>;
      startpointName1Ctrl.text = x['startpoint name'];
      endpointName1Ctrl.text = x['endpoint name'];

      setState(() {
        paths1 = x['paths1'];
      });
      NameCtrl.text = x['name'];
      latitudeCtrl.text = x['latitude'].toString();
      longitudeCtrl.text = x['longitude'].toString();
      imageCtrl.text = x['image'];
      detailCtrl.text = x['detail'];
      audioUrlCtrl.text = x['audioUrl'];
    });
    firestore
        .collection(collectionName)
        .doc(widget.placeData.timestamp)
        .collection('travel guide2')
        .doc(widget.placeData.timestamp)
        .get()
        .then((DocumentSnapshot snap) {
      Map x = snap.data() as Map<dynamic, dynamic>;
      startpointName2Ctrl.text = x['startpoint name'];
      endpointName2Ctrl.text = x['endpoint name'];

      setState(() {
        paths2 = x['paths2'];
      });
      NameCtrl.text = x['name'];
      latitudeCtrl.text = x['latitude'].toString();
      longitudeCtrl.text = x['longitude'].toString();
      imageCtrl.text = x['image'];
      detailCtrl.text = x['detail'];
      audioUrlCtrl.text = x['audioUrl'];
    });
  }

  initData() {
    stateSelection = widget.placeData.state;
    nameCtrl.text = widget.placeData.name!;
    locationCtrl.text = widget.placeData.location!;
    descriptionCtrl.text = widget.placeData.description!;
    image1Ctrl.text = widget.placeData.imageUrl1!;
    image2Ctrl.text = widget.placeData.imageUrl2!;
    image3Ctrl.text = widget.placeData.imageUrl3!;
    latCtrl.text = widget.placeData.latitude.toString();
    lngCtrl.text = widget.placeData.longitude.toString();

    getGuideData();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  handlePreview() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (paths!.isNotEmpty) {
        showPlacePreview(
          context,
          nameCtrl.text,
          locationCtrl.text,
          image1Ctrl.text,
          descriptionCtrl.text,
          double.parse(latCtrl.text),
          double.parse(lngCtrl.text),
          startpointNameCtrl.text,
          endpointNameCtrl.text,
          startpointName1Ctrl.text,
          endpointName1Ctrl.text,
          startpointName2Ctrl.text,
          endpointName2Ctrl.text,
          priceCtrl.text,
          paths,
          paths1,
          paths2,
        );
      } else {
        openToast(context, 'รายการเส้นทางว่างเปล่า!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      key: scaffoldKey,
      body: CoverWidget(
        widget: Form(
            key: formKey,
            child: ListView(
              controller: ScrollController(),
              children: <Widget>[
                SizedBox(
                  height: h * 0.10,
                ),
                Text(
                  'รายละเอียดสถานที่',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 20,
                ),
                statesDropdown(),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: inputDecoration(
                      'ป้อนชื่อสถานที่', 'ชื่อสถานที่', nameCtrl),
                  controller: nameCtrl,
                  validator: (value) {
                    if (value!.isEmpty) return 'ค่าว่างเปล่า';
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: inputDecoration(
                      'ใส่ชื่อสถานที่', 'ชื่อสถานที่', locationCtrl),
                  controller: locationCtrl,
                  validator: (value) {
                    if (value!.isEmpty) return 'ค่าว่างเปล่า';
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration:
                            inputDecoration('ป้อน ละติจูด', 'ละติจูด', latCtrl),
                        controller: latCtrl,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return 'ค่าว่างเปล่า';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: inputDecoration(
                            'ป้อนลองจิจูด', 'ลองจิจูด', lngCtrl),
                        keyboardType: TextInputType.number,
                        controller: lngCtrl,
                        validator: (value) {
                          if (value!.isEmpty) return 'ค่าว่างเปล่า';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: inputDecoration('ป้อน URL รูปภาพ (ภาพขนาดย่อ)',
                      'ภาพที่ 1 (ภาพขนาดย่อ)', image1Ctrl),
                  controller: image1Ctrl,
                  validator: (value) {
                    if (value!.isEmpty) return 'ค่าว่างเปล่า';
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: inputDecoration(
                      'ป้อน URL รูปภาพ', 'ภาพที่ 2 ', image2Ctrl),
                  controller: image2Ctrl,
                  validator: (value) {
                    if (value!.isEmpty) return 'ค่าว่างเปล่า';
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: inputDecoration(
                      'ป้อน URL รูปภาพ', 'ภาพที่ 3', image3Ctrl),
                  controller: image3Ctrl,
                  validator: (value) {
                    if (value!.isEmpty) return 'ค่าว่างเปล่า';
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'ป้อนรายละเอียดของสถานที่',
                      border: OutlineInputBorder(),
                      labelText: 'รายละเอียดสถานที่',
                      contentPadding: EdgeInsets.only(
                          right: 0, left: 10, top: 15, bottom: 5),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[300],
                          child: IconButton(
                              icon: Icon(Icons.close, size: 15),
                              onPressed: () {
                                descriptionCtrl.clear();
                              }),
                        ),
                      )),
                  textAlignVertical: TextAlignVertical.top,
                  minLines: 5,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: descriptionCtrl,
                  validator: (value) {
                    if (value!.isEmpty) return 'ค่าว่างเปล่า';
                    return null;
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'รายละเอียดการเดินทาง(เที่ยวสบายๆ)',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: inputDecoration(
                            'ใส่ชื่อจุดเริ่มตันการเดินทาง',
                            'ใส่ชื่อจุดเริ่มตัน',
                            startpointNameCtrl),
                        controller: startpointNameCtrl,
                        validator: (value) {
                          if (value!.isEmpty) return 'ค่าว่างเปล่า';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: inputDecoration('ใส่ชื่อจุดจบการเดินทาง',
                            'ใส่ชื่อจุดจบการเดินทาง', endpointNameCtrl),
                        controller: endpointNameCtrl,
                        validator: (value) {
                          if (value!.isEmpty) return 'ค่าว่างเปล่า';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // TextFormField(
                //   decoration:
                //       inputDecoration('Enter travel cost', 'Price', priceCtrl),
                //   keyboardType: TextInputType.number,
                //   controller: priceCtrl,
                //   validator: (value) {
                //     if (value!.isEmpty) return 'Value is empty';
                //     return null;
                //   },
                // ),
                SizedBox(
                  height: 20,
                ),
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: TextFormField(
                //         decoration: inputDecoration('Enter startpoint latitude',
                //             'Startpoint latitude', startpointLatCtrl),
                //         controller: startpointLatCtrl,
                //         keyboardType: TextInputType.number,
                //         validator: (value) {
                //           if (value!.isEmpty) return 'Value is empty';
                //           return null;
                //         },
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(
                //       child: TextFormField(
                //         decoration: inputDecoration(
                //             'Enter startpoint longitude',
                //             'Startpoint longitude',
                //             startpointLngCtrl),
                //         keyboardType: TextInputType.number,
                //         controller: startpointLngCtrl,
                //         validator: (value) {
                //           if (value!.isEmpty) return 'Value is empty';
                //           return null;
                //         },
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 20,
                ),
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: TextFormField(
                //         decoration: inputDecoration('Enter endpoint latitude',
                //             'Endpoint latitude', endpointLatCtrl),
                //         controller: endpointLatCtrl,
                //         keyboardType: TextInputType.number,
                //         validator: (value) {
                //           if (value!.isEmpty) return 'Value is empty';
                //           return null;
                //         },
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(
                //       child: TextFormField(
                //         decoration: inputDecoration('Enter endpoint longitude',
                //             'Endpoint longitude', endpointLngCtrl),
                //         keyboardType: TextInputType.number,
                //         controller: endpointLngCtrl,
                //         validator: (value) {
                //           if (value!.isEmpty) return 'Value is empty';
                //           return null;
                //         },
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText:
                          "ป้อนรายการเส้นทางทีละรายการโดยแตะ 'Enter' ทุกครั้ง",
                      border: OutlineInputBorder(),
                      labelText: 'รายการเส้นทาง',
                      helperText: _helperText,
                      contentPadding: EdgeInsets.only(
                          right: 0, left: 10, top: 15, bottom: 5),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[300],
                          child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 15,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              pathsCtrl.clear();
                            },
                          ),
                        ),
                      )),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  controller: pathsCtrl,
                  onFieldSubmitted: (String value) {
                    if (value.length == 0) {
                      setState(() {
                        _helperText = "คุณไม่สามารถใส่รายการว่างเป็นรายการ";
                      });
                    } else {
                      List<String> pathInfo =
                          value.split(',').map((s) => s.trim()).toList();
                      if (pathInfo.length != 7) {
                        setState(() {
                          _helperText =
                              'รูปแบบการป้อนข้อมูลไม่ถูกต้อง โปรดลองอีกครั้ง';
                        });
                      } else {
                        try {
                          String name = pathsCtrl.text.split(',')[0].trim();
                          double? latitudeCtrl = double.tryParse(
                              pathsCtrl.text.split(',')[1].trim());
                          double? longitudeCtrl = double.tryParse(
                              pathsCtrl.text.split(',')[2].trim());
                          String imageCtrl =
                              pathsCtrl.text.split(',')[3].trim();
                          String detailCtrl =
                              pathsCtrl.text.split(',')[4].trim();
                          String audioUrlCtrl =
                              pathsCtrl.text.split(',')[5].trim();
                          String radiusCtrl =
                              pathsCtrl.text.split(',')[6].trim();
                          if (latitudeCtrl == null || longitudeCtrl == null) {
                            setState(() {
                              _helperText =
                                  'รูปแบบการป้อนข้อมูลไม่ถูกต้อง: ละติจูดและลองจิจูดต้องเป็นตัวเลขที่ถูกต้อง';
                            });
                            return;
                          }
                          setState(() {
                            paths?.add({
                              'name': name,
                              'latitude': latitudeCtrl,
                              'longitude': longitudeCtrl,
                              'image': imageCtrl,
                              'detail': detailCtrl,
                              'audioUrl': audioUrlCtrl,
                              'radius': radiusCtrl
                            });
                            _helperText = 'เพิ่ม ${paths?.length} รายการ';
                            print(paths);
                          });
                        } catch (e) {
                          setState(() {
                            _helperText =
                                'Invalid input format: ${e.toString()}';
                          });
                        }
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: paths?.length == 0
                      ? Center(
                          child: Text('ไม่มีการเพิ่มรายการเส้นทาง'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: paths?.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> path = paths![index];
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(index.toString()),
                              ),
                              title: Text(path['name'] as String),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Latitude: ${path['latitude']}'),
                                  Text('Longitude: ${path['longitude']}'),
                                  Text('Image URL: ${path['image']}'),
                                  Text('Detail: ${path['detail']}'),
                                  Text('audioUrl: ${path['audioUrl']}'),
                                  Text('radius: ${path['radius']}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // Show edit form
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TextEditingController nameCtrl =
                                              TextEditingController(
                                                  text: path['name']);
                                          TextEditingController latitudeCtrl =
                                              TextEditingController(
                                                  text: path['latitude']
                                                      .toString());
                                          TextEditingController longitudeCtrl =
                                              TextEditingController(
                                                  text: path['longitude']
                                                      .toString());
                                          TextEditingController imageCtrl =
                                              TextEditingController(
                                                  text: path['image']);
                                          TextEditingController detailCtrl =
                                              TextEditingController(
                                                  text: path['detail']);
                                          TextEditingController audioUrlCtrl =
                                              TextEditingController(
                                                  text: path['audioUrl']);
                                          TextEditingController radiusCtrl =
                                              TextEditingController(
                                                  text: path['radius']);
                                          return AlertDialog(
                                            title: Text('Edit Path'),
                                            content: Form(
                                              // Use TextFormField to get user input
                                              // and store the values in local variables
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    controller: nameCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated name in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Name',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: latitudeCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated latitude in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Latitude',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: longitudeCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated longitude in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Longitude',
                                                    ),
                                                  ),
                                                  // Add more TextFormFields to get other values
                                                  TextFormField(
                                                    controller: imageCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated image URL in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Image URL',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: detailCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated detail in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Detail',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: audioUrlCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated audio URL in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Audio URL',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: radiusCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated radius in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Radius',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Save'),
                                                onPressed: () {
                                                  // Update the path with the new values
                                                  setState(() {
                                                    paths![index]['name'] =
                                                        nameCtrl.text;
                                                    paths![index]['latitude'] =
                                                        double.tryParse(
                                                            latitudeCtrl.text);
                                                    paths![index]['longitude'] =
                                                        double.tryParse(
                                                            longitudeCtrl.text);
                                                    paths![index]['image'] =
                                                        imageCtrl.text;
                                                    paths![index]['detail'] =
                                                        detailCtrl.text;
                                                    paths![index]['audioUrl'] =
                                                        audioUrlCtrl.text;
                                                    paths![index]['radius'] =
                                                        radiusCtrl.text;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline),
                                    onPressed: () {
                                      setState(() {
                                        paths?.removeAt(index);
                                        _helperText =
                                            'ลบ ${paths?.length} รายการ';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Text(
                  'รายละเอียดการเดินทาง(เที่ยวอิ่มท้อง)',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: inputDecoration(
                            'ใส่ชื่อจุดเริ่มตันการเดินทาง',
                            'ใส่ชื่อจุดเริ่มตัน',
                            startpointName1Ctrl),
                        controller: startpointName1Ctrl,
                        validator: (value) {
                          if (value!.isEmpty) return 'ค่าว่างเปล่า';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: inputDecoration('ใส่ชื่อจุดจบการเดินทาง',
                            'ใส่ชื่อจุดจบการเดินทาง', endpointName1Ctrl),
                        controller: endpointName1Ctrl,
                        validator: (value) {
                          if (value!.isEmpty) return 'ค่าว่างเปล่า';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText:
                          "ป้อนรายการเส้นทางทีละรายการโดยแตะ 'Enter' ทุกครั้ง",
                      border: OutlineInputBorder(),
                      labelText:
                          'ชื่อ, ละติจูด, ลองจิจูด, รูปภาพ, รายละเอียด, URL เสียง, รัศมี',
                      helperText: _helperText1,
                      contentPadding: EdgeInsets.only(
                          right: 0, left: 10, top: 15, bottom: 5),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[300],
                          child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 15,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              paths1Ctrl.clear();
                            },
                          ),
                        ),
                      )),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  controller: paths1Ctrl,
                  onFieldSubmitted: (String value) {
                    if (value.length == 0) {
                      setState(() {
                        _helperText1 = "คุณไม่สามารถใส่รายการว่างเป็นรายการ";
                      });
                    } else {
                      List<String> pathInfo =
                          value.split(',').map((s) => s.trim()).toList();
                      if (pathInfo.length != 7) {
                        setState(() {
                          _helperText1 =
                              'รูปแบบการป้อนข้อมูลไม่ถูกต้อง โปรดลองอีกครั้ง';
                        });
                      } else {
                        try {
                          String name = paths1Ctrl.text.split(',')[0].trim();
                          double? latitudeCtrl = double.tryParse(
                              paths1Ctrl.text.split(',')[1].trim());
                          double? longitudeCtrl = double.tryParse(
                              paths1Ctrl.text.split(',')[2].trim());
                          String imageCtrl =
                              paths1Ctrl.text.split(',')[3].trim();
                          String detailCtrl =
                              paths1Ctrl.text.split(',')[4].trim();
                          String audioUrlCtrl =
                              paths1Ctrl.text.split(',')[5].trim();
                          String radiusCtrl =
                              paths1Ctrl.text.split(',')[6].trim();
                          if (latitudeCtrl == null || longitudeCtrl == null) {
                            setState(() {
                              _helperText1 =
                                  'Invalid input format: latitude and longitude must be valid numbers';
                            });
                            return;
                          }
                          setState(() {
                            paths1?.add({
                              'name': name,
                              'latitude': latitudeCtrl,
                              'longitude': longitudeCtrl,
                              'image': imageCtrl,
                              'detail': detailCtrl,
                              'audioUrl': audioUrlCtrl,
                              'radius': radiusCtrl
                            });
                            _helperText1 = 'เพิ่ม ${paths1?.length} items';
                            print(paths1);
                          });
                        } catch (e) {
                          setState(() {
                            _helperText1 =
                                'Invalid input format: ${e.toString()}';
                          });
                        }
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: paths1?.length == 0
                      ? Center(
                          child: Text('ไม่มีการเพิ่มรายการเส้นทาง'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: paths1?.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> path1 = paths1![index];
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(index.toString()),
                              ),
                              title: Text(path1['name'] as String),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Latitude: ${path1['latitude']}'),
                                  Text('Longitude: ${path1['longitude']}'),
                                  Text('Image URL: ${path1['image']}'),
                                  Text('Detail: ${path1['detail']}'),
                                  Text('audioUrl: ${path1['audioUrl']}'),
                                  Text('radius: ${path1['radius']}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // Show edit form
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TextEditingController nameCtrl =
                                              TextEditingController(
                                                  text: path1['name']);
                                          TextEditingController latitudeCtrl =
                                              TextEditingController(
                                                  text: path1['latitude']
                                                      .toString());
                                          TextEditingController longitudeCtrl =
                                              TextEditingController(
                                                  text: path1['longitude']
                                                      .toString());
                                          TextEditingController imageCtrl =
                                              TextEditingController(
                                                  text: path1['image']);
                                          TextEditingController detailCtrl =
                                              TextEditingController(
                                                  text: path1['detail']);
                                          TextEditingController audioUrlCtrl =
                                              TextEditingController(
                                                  text: path1['audioUrl']);
                                          TextEditingController radiusCtrl =
                                              TextEditingController(
                                                  text: path1['radius']);
                                          return AlertDialog(
                                            title: Text('Edit Path'),
                                            content: Form(
                                              // Use TextFormField to get user input
                                              // and store the values in local variables
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    controller: nameCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated name in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Name',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: latitudeCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated latitude in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Latitude',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: longitudeCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated longitude in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Longitude',
                                                    ),
                                                  ),
                                                  // Add more TextFormFields to get other values
                                                  TextFormField(
                                                    controller: imageCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated image URL in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Image URL',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: detailCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated detail in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Detail',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: audioUrlCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated audio URL in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Audio URL',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: radiusCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated radius in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Radius',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Save'),
                                                onPressed: () {
                                                  // Update the path with the new values
                                                  setState(() {
                                                    paths1![index]['name'] =
                                                        nameCtrl.text;
                                                    paths1![index]['latitude'] =
                                                        double.tryParse(
                                                            latitudeCtrl.text);
                                                    paths1![index]
                                                            ['longitude'] =
                                                        double.tryParse(
                                                            longitudeCtrl.text);
                                                    paths1![index]['image'] =
                                                        imageCtrl.text;
                                                    paths1![index]['detail'] =
                                                        detailCtrl.text;
                                                    paths1![index]['audioUrl'] =
                                                        audioUrlCtrl.text;
                                                    paths1![index]['radius'] =
                                                        radiusCtrl.text;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline),
                                    onPressed: () {
                                      setState(() {
                                        paths1?.removeAt(index);
                                        _helperText1 =
                                            'ลบ ${paths1?.length} รายการ';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Text(
                  'รายละเอียดการเดินทาง(เที่ยวหาความรู้)',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: inputDecoration(
                            'ใส่ชื่อจุดเริ่มตันการเดินทาง',
                            'ใส่ชื่อจุดเริ่มตัน',
                            startpointName2Ctrl),
                        controller: startpointName2Ctrl,
                        validator: (value) {
                          if (value!.isEmpty) return 'ค่าว่างเปล่า';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: inputDecoration('ใส่ชื่อจุดจบการเดินทาง',
                            'ใส่ชื่อจุดจบการเดินทาง', endpointName2Ctrl),
                        controller: endpointName2Ctrl,
                        validator: (value) {
                          if (value!.isEmpty) return 'ค่าว่างเปล่า';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText:
                          "ป้อนรายการเส้นทางทีละรายการโดยแตะ 'Enter' ทุกครั้ง",
                      border: OutlineInputBorder(),
                      labelText:
                          'ชื่อ, ละติจูด, ลองจิจูด, รูปภาพ, รายละเอียด, URL เสียง, รัศมี',
                      helperText: _helperText2,
                      contentPadding: EdgeInsets.only(
                          right: 0, left: 10, top: 15, bottom: 5),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[300],
                          child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 15,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              paths2Ctrl.clear();
                            },
                          ),
                        ),
                      )),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  controller: paths2Ctrl,
                  onFieldSubmitted: (String value) {
                    if (value.length == 0) {
                      setState(() {
                        _helperText2 = "คุณไม่สามารถใส่รายการว่างเป็นรายการ";
                      });
                    } else {
                      List<String> pathInfo =
                          value.split(',').map((s) => s.trim()).toList();
                      if (pathInfo.length != 7) {
                        setState(() {
                          _helperText2 =
                              'รูปแบบการป้อนข้อมูลไม่ถูกต้อง โปรดลองอีกครั้ง';
                        });
                      } else {
                        try {
                          String name = paths2Ctrl.text.split(',')[0].trim();
                          double? latitudeCtrl = double.tryParse(
                              paths2Ctrl.text.split(',')[1].trim());
                          double? longitudeCtrl = double.tryParse(
                              paths2Ctrl.text.split(',')[2].trim());
                          String imageCtrl =
                              paths2Ctrl.text.split(',')[3].trim();
                          String detailCtrl =
                              paths2Ctrl.text.split(',')[4].trim();
                          String audioUrlCtrl =
                              paths2Ctrl.text.split(',')[5].trim();
                          String radiusCtrl =
                              paths2Ctrl.text.split(',')[6].trim();
                          if (latitudeCtrl == null || longitudeCtrl == null) {
                            setState(() {
                              _helperText2 =
                                  'Invalid input format: latitude and longitude must be valid numbers';
                            });
                            return;
                          }
                          setState(() {
                            paths2?.add({
                              'name': name,
                              'latitude': latitudeCtrl,
                              'longitude': longitudeCtrl,
                              'image': imageCtrl,
                              'detail': detailCtrl,
                              'audioUrl': audioUrlCtrl,
                              'radius': radiusCtrl
                            });
                            _helperText2 = 'เพิ่ม ${paths2?.length} รายการ';
                            print(paths2);
                          });
                        } catch (e) {
                          setState(() {
                            _helperText2 =
                                'Invalid input format: ${e.toString()}';
                          });
                        }
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: paths2?.length == 0
                      ? Center(
                          child: Text('ไม่มีการเพิ่มรายการเส้นทาง'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: paths2?.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> path2 = paths2![index];
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(index.toString()),
                              ),
                              title: Text(path2['name'] as String),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Latitude: ${path2['latitude']}'),
                                  Text('Longitude: ${path2['longitude']}'),
                                  Text('Image URL: ${path2['image']}'),
                                  Text('Detail: ${path2['detail']}'),
                                  Text('audioUrl: ${path2['audioUrl']}'),
                                  Text('radius: ${path2['radius']}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // Show edit form
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TextEditingController nameCtrl =
                                              TextEditingController(
                                                  text: path2['name']);
                                          TextEditingController latitudeCtrl =
                                              TextEditingController(
                                                  text: path2['latitude']
                                                      .toString());
                                          TextEditingController longitudeCtrl =
                                              TextEditingController(
                                                  text: path2['longitude']
                                                      .toString());
                                          TextEditingController imageCtrl =
                                              TextEditingController(
                                                  text: path2['image']);
                                          TextEditingController detailCtrl =
                                              TextEditingController(
                                                  text: path2['detail']);
                                          TextEditingController audioUrlCtrl =
                                              TextEditingController(
                                                  text: path2['audioUrl']);
                                          TextEditingController radiusCtrl =
                                              TextEditingController(
                                                  text: path2['radius']);
                                          return AlertDialog(
                                            title: Text('Edit Path'),
                                            content: Form(
                                              // Use TextFormField to get user input
                                              // and store the values in local variables
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    controller: nameCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated name in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Name',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: latitudeCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated latitude in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Latitude',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: longitudeCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated longitude in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Longitude',
                                                    ),
                                                  ),
                                                  // Add more TextFormFields to get other values
                                                  TextFormField(
                                                    controller: imageCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated image URL in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Image URL',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: detailCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated detail in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Detail',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: audioUrlCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated audio URL in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Audio URL',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: radiusCtrl,
                                                    onChanged: (value) {
                                                      // Store the updated radius in a local variable
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Radius',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Save'),
                                                onPressed: () {
                                                  // Update the path with the new values
                                                  setState(() {
                                                    paths2![index]['name'] =
                                                        nameCtrl.text;
                                                    paths2![index]['latitude'] =
                                                        double.tryParse(
                                                            latitudeCtrl.text);
                                                    paths2![index]
                                                            ['longitude'] =
                                                        double.tryParse(
                                                            longitudeCtrl.text);
                                                    paths2![index]['image'] =
                                                        imageCtrl.text;
                                                    paths2![index]['detail'] =
                                                        detailCtrl.text;
                                                    paths2![index]['audioUrl'] =
                                                        audioUrlCtrl.text;
                                                    paths2![index]['radius'] =
                                                        radiusCtrl.text;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline),
                                    onPressed: () {
                                      setState(() {
                                        paths2?.removeAt(index);
                                        _helperText2 =
                                            'เพิ่ม ${paths2?.length} รายการ';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton.icon(
                        icon: Icon(
                          Icons.remove_red_eye,
                          size: 25,
                          color: Colors.blueAccent,
                        ),
                        label: Text(
                          'ดูตัวอย่าง',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                        onPressed: () {
                          handlePreview();
                        })
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    color: Colors.deepPurpleAccent,
                    height: 45,
                    child: uploadStarted == true
                        ? Center(
                            child: Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator()),
                          )
                        : TextButton(
                            child: Text(
                              'อัปโหลดข้อมูลสถานที่',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              handleSubmit();
                            })),
                SizedBox(
                  height: 200,
                ),
              ],
            )),
      ),
    );
  }

  Widget statesDropdown() {
    final AdminBloc ab = Provider.of(context, listen: false);
    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(30)),
        child: DropdownButtonFormField(
            itemHeight: 50,
            decoration: InputDecoration(border: InputBorder.none),
            onChanged: (dynamic value) {
              setState(() {
                stateSelection = value;
              });
            },
            onSaved: (dynamic value) {
              setState(() {
                stateSelection = value;
              });
            },
            value: stateSelection,
            hint: Text('เลือกแหล่งท่องเที่ยว'),
            items: ab.states.map((f) {
              return DropdownMenuItem(
                child: Text(f),
                value: f,
              );
            }).toList()));
  }
}
