class YardVehicle {
  final String vehicleNo;
  final String objective;
  String? dockInTime;
  String? operationStartTime;
  String? operationEndTime;
  String? dockOutTime;
  int step;
  final String vehicleRegNo;

  YardVehicle({
    required this.vehicleNo,
    required this.objective,
    required this.vehicleRegNo,
    this.dockInTime,
    this.dockOutTime,
    required this.step,
    this.operationEndTime,
    this.operationStartTime,
  });

  static YardVehicle getData() {
    return YardVehicle(
      vehicleNo: 'UP78EA7812',
      objective: 'Loading',
      vehicleRegNo: 'ucusvcbasocsibciascuosbcoasbcboasc',
      step: 0,
    );
  }
}
