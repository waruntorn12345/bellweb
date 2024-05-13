import 'package:admin/utils/cached_image.dart';
import 'package:admin/widgets/html_body.dart';
import 'package:flutter/material.dart';

showPlacePreview(
  context,
  String name,
  String location,
  String imageUrl_1,
  String description,
  double lat,
  double lng,
  String startpointName,
  String endpointName,
  String startpointName1,
  String endpointName1,
  String startpointName2,
  String endpointName2,
  String price,
  List? paths,
  List? paths1,
  List? paths2,
) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.50,
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                        height: 350,
                        width: MediaQuery.of(context).size.width,
                        child:
                            CustomCacheImage(imageUrl: imageUrl_1, radius: 0.0)

                        // Image(
                        //     fit: BoxFit.cover, image: NetworkImage(imageUrl_1)),
                        ),
                    Positioned(
                      top: 10,
                      right: 20,
                      child: CircleAvatar(
                        child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context)),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        height: 3,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.location_on, size: 16, color: Colors.grey),
                          Text(
                            location,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'Latitude: ',
                                  style: TextStyle(color: Colors.grey),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: lat.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[700])),
                              ])),
                          SizedBox(
                            width: 5,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'Longitude: ',
                                  style: TextStyle(color: Colors.grey),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: lng.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[700])),
                              ])),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      HtmlBodyWidget(htmlDescription: description),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Guide Details(เที่ยวสบายๆ)',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        height: 3,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                              text: TextSpan(
                                  text: 'Startpoint Name: ',
                                  style: TextStyle(color: Colors.grey),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: startpointName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[700])),
                              ])),
                          Spacer(),
                          RichText(
                              text: TextSpan(
                                  text: 'Endpoint Name: ',
                                  style: TextStyle(color: Colors.grey),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: endpointName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[700])),
                              ])),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: <Widget>[
                      //     RichText(
                      //         text: TextSpan(
                      //             text: ' Name: ',
                      //             style: TextStyle(color: Colors.grey),
                      //             children: <TextSpan>[
                      //           TextSpan(
                      //               text: Name,
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.w700,
                      //                   color: Colors.grey[700])),
                      //         ])),
                      //     Spacer(),
                      //     RichText(
                      //         text: TextSpan(
                      //             text: 'detail: ',
                      //             style: TextStyle(color: Colors.grey),
                      //             children: <TextSpan>[
                      //           TextSpan(
                      //               text: detail,
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.w700,
                      //                   color: Colors.grey[700])),
                      //         ])),
                      //   ],
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: <Widget>[
                      //     RichText(
                      //         text: TextSpan(
                      //             text: 'Startpoint Latitude: ',
                      //             style: TextStyle(color: Colors.grey),
                      //             children: <TextSpan>[
                      //           TextSpan(
                      //               text: startpointLat.toString(),
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.w700,
                      //                   color: Colors.grey[700])),
                      //         ])),
                      //     Spacer(),
                      //     RichText(
                      //         text: TextSpan(
                      //             text: 'Startpoint Longitude: ',
                      //             style: TextStyle(color: Colors.grey),
                      //             children: <TextSpan>[
                      //           TextSpan(
                      //               text: startpointLng.toString(),
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.w700,
                      //                   color: Colors.grey[700])),
                      //         ])),
                      //   ],
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: <Widget>[
                      //     RichText(
                      //         text: TextSpan(
                      //             text: 'Endpoint Latitude: ',
                      //             style: TextStyle(color: Colors.grey),
                      //             children: <TextSpan>[
                      //           TextSpan(
                      //               text: endpointLat.toString(),
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.w700,
                      //                   color: Colors.grey[700])),
                      //         ])),
                      //     Spacer(),
                      //     RichText(
                      //         text: TextSpan(
                      //             text: 'Endpoint Longitude: ',
                      //             style: TextStyle(color: Colors.grey),
                      //             children: <TextSpan>[
                      //           TextSpan(
                      //               text: endpointLng.toString(),
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.w700,
                      //                   color: Colors.grey[700])),
                      //         ])),
                      //   ],
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      // RichText(
                      //     text: TextSpan(
                      //         text: 'Estimated Cost: ',
                      //         style: TextStyle(color: Colors.grey),
                      //         children: <TextSpan>[
                      //       TextSpan(
                      //           text: price,
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w700,
                      //               color: Colors.grey[700])),
                      //     ])),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Paths',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        height: 2,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(15)),
                      ),

                      Container(
                        child: paths!.isEmpty
                            ? Center(
                                child: Text('No path list were added'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: paths.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final path = paths[index];
                                  final name = path['name'] ?? '';

                                  return ListTile(
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Latitude: ${path['latitude']}'),
                                        Text('Longitude: ${path['longitude']}'),
                                        Text('Image URL: ${path['image']}'),
                                        Text('Detail: ${path['detail']}'),
                                        Text('audioUrl: ${path['audioUrl']}'),
                                        Text('radius: ${path['radius']}'),
                                      ],
                                    ),
                                    leading: CircleAvatar(
                                      child: Text(index.toString()),
                                    ),
                                    title: Text(name),
                                  );
                                },
                              ),
                      ),
                      Text('Guide Details(เที่ยวอิ่มท้อง)',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        height: 3,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                              text: TextSpan(
                                  text: 'Startpoint Name: ',
                                  style: TextStyle(color: Colors.grey),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: startpointName1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[700])),
                              ])),
                          Spacer(),
                          RichText(
                              text: TextSpan(
                                  text: 'Endpoint Name: ',
                                  style: TextStyle(color: Colors.grey),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: endpointName1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[700])),
                              ])),
                        ],
                      ),
                      Text('Paths1',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        height: 2,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(15)),
                      ),

                      Container(
                        child: paths1!.isEmpty
                            ? Center(
                                child: Text('No path list were added'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: paths1.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final path1 = paths1[index];
                                  final name = path1['name'] ?? '';

                                  return ListTile(
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Latitude: ${path1['latitude']}'),
                                        Text(
                                            'Longitude: ${path1['longitude']}'),
                                        Text('Image URL: ${path1['image']}'),
                                        Text('Detail: ${path1['detail']}'),
                                        Text('audioUrl: ${path1['audioUrl']}'),
                                        Text('radius: ${path1['radius']}'),
                                      ],
                                    ),
                                    leading: CircleAvatar(
                                      child: Text(index.toString()),
                                    ),
                                    title: Text(name),
                                  );
                                },
                              ),
                      ),
                      Text('Guide Details(เที่ยวหาความรู้)',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        height: 3,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                              text: TextSpan(
                                  text: 'Startpoint Name: ',
                                  style: TextStyle(color: Colors.grey),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: startpointName2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[700])),
                              ])),
                          Spacer(),
                          RichText(
                              text: TextSpan(
                                  text: 'Endpoint Name: ',
                                  style: TextStyle(color: Colors.grey),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: endpointName2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[700])),
                              ])),
                        ],
                      ),
                      Text('Paths2',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        height: 2,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.circular(15)),
                      ),

                      Container(
                        child: paths2!.isEmpty
                            ? Center(
                                child: Text('No path list were added'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: paths2.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final path2 = paths2[index];
                                  final name = path2['name'] ?? '';

                                  return ListTile(
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Latitude: ${path2['latitude']}'),
                                        Text(
                                            'Longitude: ${path2['longitude']}'),
                                        Text('Image URL: ${path2['image']}'),
                                        Text('Detail: ${path2['detail']}'),
                                        Text('audioUrl: ${path2['audioUrl']}'),
                                        Text('radius: ${path2['radius']}'),
                                      ],
                                    ),
                                    leading: CircleAvatar(
                                      child: Text(index.toString()),
                                    ),
                                    title: Text(name),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      });
}
