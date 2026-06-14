import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stem_shop/utils/formatters/formatters.dart';

class UserModel {

final String id;
String firstName;
String lastName;
final String username;
final String email;
String phone;
String profilePicture;
final String academicLevel;
final String grade;
final String stemSchool;

/// Constructor for UserModel.
UserModel({
required this.id,
required this.firstName,
required this.lastName,
required this.username,
required this.email,
required this.phone,
required this.profilePicture,
required this.academicLevel,
required this.grade,
required this.stemSchool,
});

/// Helper function to get the full name.
String get fullName => '$firstName $lastName';

/// Helper function to format phone number.
String get formattedPhoneNo => TFormatter.formatPhoneNumber(phone);

/// Static function to split full name into first and last name.
static List<String> nameParts(fullName) => fullName.split(" ");


static UserModel empty() => UserModel(id: '', firstName: '', lastName: '', username: '', email: '', phone: '', profilePicture: '', academicLevel: '', grade: '', stemSchool: '');

Map<String, dynamic> toJson() {
return {
'FirstName': firstName,
'LastName': lastName,
'Username' : username,
'Email': email,
'PhoneNumber': phone,
'ProfilePicture': profilePicture,
'AcademicLevel': academicLevel,
'stemSchool': stemSchool,
'grade': grade,
};
}

/// Factory method to create a UserModel from a Firebase document snapshot.
factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
if (document.data() != null) {
final data = document.data() !;
return UserModel(
id: document.id,
firstName: data['FirstName' ] ?? '',
lastName: data[ 'LastName' ] ?? '',
username: data[ 'Username' ] ?? '',
email: data['Email'] ?? '',
phone: data['PhoneNumber'] ?? '',
profilePicture: data['ProfilePicture' ] ?? '',
academicLevel: data['AcademicLevel'] ?? '',
grade: data['Grade'] ?? '',
stemSchool: data['StemSchool'] ?? '',
);
}
	// If document has no data, return an empty UserModel to satisfy non-nullable return type.
	return UserModel.empty();


}

}