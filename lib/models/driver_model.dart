class Driver {
  final String dId;
  final String dName;
  final String dlNo;
  final String phone;
  final String address;
  final String vRegNo;
  String photoUrl;

  Driver({
    required this.dId,
    required this.dName,
    required this.dlNo,
    required this.phone,
    required this.address,
    required this.vRegNo,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        "dId": dId,
        "dName": dName,
        "dlNo": dlNo,
        "phone": phone,
        "address": address,
        "vRegNo": vRegNo,
        "photoUrl": photoUrl,
      };
}
