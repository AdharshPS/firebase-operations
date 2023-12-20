class AddDataController {
  Future<void> addUser(
      {dynamic employee, String? name, String? des, String? url}) {
    return employee
        .add({'name': name, 'designation': des, 'image': url})
        .then((value) => print("user added"))
        .catchError((error) => print("error : $error"));
  }

  Future<void> updateUser(
      {dynamic employee, dynamic empId, String? name, String? des}) {
    return employee
        .doc(empId)
        .update({
          'name': name,
          'designation': des,
        })
        .then((value) => print("user updated"))
        .catchError((error) => print("error : $error"));
  }

  Future<void> deleteUser({dynamic employee, dynamic empId}) {
    return employee
        .doc(empId)
        .delete()
        .then((value) => print("user updated"))
        .catchError((error) => print("error : $error"));
  }
}
