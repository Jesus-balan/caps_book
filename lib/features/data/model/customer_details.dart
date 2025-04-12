// driver_model.dart

class UserModel {
  final DriverUserData data;
  final String status;
  final String actionCode;

  UserModel({
    required this.data,
    required this.status,
    required this.actionCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      data: DriverUserData.fromJson(json['data']),
      status: json['status'],
      actionCode: json['action_code'],
    );
  }
}

class DriverUserData {
  final int id;
  final String uuid;
  final String phoneNumber;
  final String role;
  final bool isDriver;
  final bool isCustomer;
  final bool isStaff;
  final Driver driver;

  DriverUserData({
    required this.id,
    required this.uuid,
    required this.phoneNumber,
    required this.role,
    required this.isDriver,
    required this.isCustomer,
    required this.isStaff,
    required this.driver,
  });

  factory DriverUserData.fromJson(Map<String, dynamic> json) {
    return DriverUserData(
      id: json['id'],
      uuid: json['uuid'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      isDriver: json['is_driver'],
      isCustomer: json['is_customer'],
      isStaff: json['is_staff'],
      driver: Driver.fromJson(json['driver']),
    );
  }
}

class Driver {
  final int id;
  final String uuid;
  final String identity;
  final String driverId;
  final String branch;
  final String balance;
  final String address;
  final String aadharNo;
  final String email;
  final String dob;
  final String licenseNo;
  final String licenseType;
  final String dateOfJoining;
  final ImageDetail aadharPhoto;
  final ImageDetail licensePhoto;
  final ImageDetail profilePhoto;

  Driver({
    required this.id,
    required this.uuid,
    required this.identity,
    required this.driverId,
    required this.branch,
    required this.balance,
    required this.address,
    required this.aadharNo,
    required this.email,
    required this.dob,
    required this.licenseNo,
    required this.licenseType,
    required this.dateOfJoining,
    required this.aadharPhoto,
    required this.licensePhoto,
    required this.profilePhoto,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      uuid: json['uuid'],
      identity: json['identity'],
      driverId: json['driver_id'],
      branch: json['branch'],
      balance: json['balance'],
      address: json['address'],
      email: json['email'],
      aadharNo: json['aadhar_no'].toString(),
      dob: json['dob'],
      licenseNo: json['license_no'],
      licenseType: json['license_type'],
      dateOfJoining: json['date_of_joining'],
      aadharPhoto: ImageDetail.fromJson(json['aadhar_photo_details']),
      licensePhoto: ImageDetail.fromJson(json['license_image_details']),
      profilePhoto: ImageDetail.fromJson(json['profile_image_details']),
    );
  }
}

class ImageDetail {
  final int id;
  final String uuid;
  final String file;

  ImageDetail({
    required this.id,
    required this.uuid,
    required this.file,
  });

  factory ImageDetail.fromJson(Map<String, dynamic> json) {
    return ImageDetail(
      id: json['id'],
      uuid: json['uuid'],
      file: json['file'],
    );
  }
}
