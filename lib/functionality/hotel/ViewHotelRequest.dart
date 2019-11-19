// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:eaglebiz/myConfig/Config.dart';
// import 'package:eaglebiz/myConfig/ServicesApi.dart';
// import 'package:flutter/material.dart';

// class ViewHotelRequest extends StatefulWidget {
//   int hotel_id;
//   String reqNo;
//   ViewHotelRequest(this.hotel_id, this.reqNo);
//   @override
//   _ViewHotelRequestState createState() =>
//       _ViewHotelRequestState(hotel_id, reqNo);
// }

// class _ViewHotelRequestState extends State<ViewHotelRequest> {
//   int hotel_id;
//   String reqNo;
//   _ViewHotelRequestState(this.hotel_id, this.reqNo);
//   Dio dio = Dio(Config.options);
 

//   @override
//   void initState() {
//     super.initState();
//     getDataHotelrequestbytId(hotel_id);
//     // getDataHotelrequestHistorybytId(hotel_id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           reqNo,
//           style: TextStyle(color: Colors.white, fontSize: 15),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//     );
//   }

//   getDataHotelrequestbytId(int hotel_id) async {
//     Response response = await dio.post(ServicesApi.getData,
//         data: {"parameter1": "getHotelRequestsbyId", "parameter2": hotel_id},
//         options: Options(
//           contentType: ContentType.parse('application/json'),
//         ));
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       // print(response.data);
//       setState(() {
//         hrbtid = (json.decode(response.data) as List)
//             .map((f) => HotelRequestByTId.fromJson(f))
//             .toList();
//       });
//     } else if (response.statusCode == 401) {
//       throw Exception("Incorrect data");
//     }
//   }
// }
