import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  List system;
  List queue;
  int? todaysTotal;
  Appointment({required this.queue, required this.system, this.todaysTotal});

  static Appointment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Appointment(
        queue: snapshot['queue'],
        system: snapshot['system'],
        todaysTotal: snapshot['todaysTotal']);
  }

  Map<String, dynamic> toJson() => {
        'queue': queue,
        'system': system,
        'todaysTotal': todaysTotal,
      };
}

class UserModel {
  final String email;
  final String uid;
  final String name;
  final String? shopname;
  final String address;
  final int? noofcounter;
  final String? pannumber;
  final bool isBarber;
  final String phone;
  final String? profileImage;
  final String? shopImage;
  const UserModel({
    required this.email,
    required this.uid,
    required this.name,
    this.shopname,
    required this.address,
    this.noofcounter,
    this.pannumber,
    required this.isBarber,
    required this.phone,
    this.profileImage,
    this.shopImage,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      email: snapshot['email'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      shopname: snapshot['shopname'],
      address: snapshot['shopaddress'],
      phone: snapshot['phone'],
      noofcounter: snapshot['noofcounter'],
      pannumber: snapshot['pannumber'],
      isBarber: snapshot['isBarber'],
      profileImage: snapshot['profileImage'],
      shopImage: snapshot['shopImage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'name': name,
        'shopname': shopname,
        'shopaddress': address,
        'noofcounter': noofcounter,
        'pannumber': pannumber,
        'isBarber': isBarber,
        'phone': phone,
        'profileImage': profileImage,
        'shopImage': shopImage,
      };
}
