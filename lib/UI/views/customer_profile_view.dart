import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/widgets/busy_overlay.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/customer_profile_view_model.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:image_picker/image_picker.dart';
import 'base_view.dart';

class CustomerProfileView extends StatefulWidget {
  final User user;
  CustomerProfileView({@required this.user});

  @override
  _CustomerProfileViewState createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
  //save the result of gallery file
  var isEditProfileImage = false;

//save the result of camera file
  File uploadFile;

  @override
  Widget build(BuildContext context) {

    Future<bool> updateNewImage(StorageReference ref, BuildContext context,
        CustomerProfileViewModel model) async {
      String uid = widget.user.id;
      print('start add new image');
      print('firename:');
      print(uid);
      StorageUploadTask uploadTask = ref.putFile(uploadFile);

      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      String url = dowurl.toString();
      setState(() {
        isEditProfileImage = false;
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
      model.onInfoEdited(url, uid);
      return true;
    }

    Future uploadPic(
        BuildContext context, CustomerProfileViewModel model) async {
      model.setState(ViewState.EditImageUrl);
      print('deleting old image && add new image process:');
      // reference to image file of current user
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('profileImages/' + widget.user.id);
      updateNewImage(firebaseStorageRef, context, model);
    }

    imageSelectorGallery() async {
      uploadFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        // maxHeight: 50.0,
        // maxWidth: 50.0,
      );
      print("You selected gallery image : " + uploadFile.path);
      setState(() {
        isEditProfileImage = true;
      });
    }

    imageSelectorCamera() async {
      uploadFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        // maxHeight: 50.0,
        // maxWidth: 50.0,
      );
      print("You took camera image : " + uploadFile.path);
      setState(() {
        isEditProfileImage = true;
      });
    }

    Widget _buildAvatar(
        BuildContext context, CustomerProfileViewModel model, String url) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.camera_alt),
                  onPressed: () => imageSelectorCamera(),
                ),
                SizedBox(
                  height: 30.0,
                ),
                FlatButton(
                  child: Icon(Icons.photo_library),
                  onPressed: () => imageSelectorGallery(),
                )
              ],
            ),
            flex: 3,
          ),
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.deepPurpleAccent ,
                  child: ClipOval(
                    child: new SizedBox(
                      width: 190.0,
                      height: 190.0,
                      child: uploadFile != null
                          ? Image.file(
                              uploadFile,
                              fit: BoxFit.fill,
                            )
                          : url==null||url==''
                          ? Image.asset('assets/customer.png')
                          : Image.network(url)
                    ),
                  ),
                ),
                onTap: () => imageSelectorGallery(),
              ),
            ),
          ),
          Expanded(
            child: !isEditProfileImage
                ? Text('')
                : Column(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            uploadFile = null;
                          });
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      FlatButton(
                        child: Icon(Icons.check_box),
                        onPressed: () => uploadPic(context, model),
                      )
                    ],
                  ),
            flex: 1,
          ),
        ],
      );
    }

    onSubmit(String newInput, String currentInput, CustomerProfileViewModel model) async {
      if (newInput != currentInput){
      await model.onInfoEdited(newInput, widget.user.id);
      }else{
        model.setState(ViewState.DataFetched);
      }
    }
    Widget _getCenteredViewMessage(
        BuildContext context, String message, CustomerProfileViewModel model,
        {bool error = false}) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    message??'',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  error
                      ? Icon(
                          // WWrap in gesture detector and call you refresh future here
                          Icons.refresh,
                          color: Colors.white,
                          size: 45.0,
                        )
                      : Container()
                ],
              )));
    }

    Widget _noDataUi(BuildContext context, CustomerProfileViewModel model) {
      return _getCenteredViewMessage(context, "No data available yet", model);
    }

    Widget _errorUi(BuildContext context, CustomerProfileViewModel model) {
      return _getCenteredViewMessage(
          context, "Error retrieving your data. Tap to try again", model,
          error: true);
    }

    Widget _getCustomerProfile(
        BuildContext context, CustomerProfileViewModel model) {
      User currentUser = model.getCurrentUser(model.customers, widget.user.id);
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                _buildAvatar(context, model, currentUser.imageUrl),
                ListTile(
                  leading: Icon(Icons.people),
                  title: model.state == ViewState.EditUsername
                      ? TextFormField(
                          onFieldSubmitted: (newInput) => onSubmit(newInput, currentUser.username, model),
                          initialValue: currentUser.username,
                        )
                      : Text(currentUser.username,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                  trailing: FlatButton(
                      onPressed: () => model.setState(ViewState.EditUsername),
                      child: Icon(Icons.edit)),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text(currentUser.email??''),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: model.state != ViewState.EditPhone
                      ? Text(currentUser.phone??'')
                      : TextFormField(
                          onFieldSubmitted: (newInput) => onSubmit(newInput, currentUser.phone, model),
                          initialValue: currentUser.phone,
                        ),
                  trailing: FlatButton(
                      onPressed: () => model.setState(ViewState.EditPhone),
                      child: Icon(Icons.edit)),
                ),
              ],
          ),
        ),
      );
    }

    Widget _getBodyUi(BuildContext context, CustomerProfileViewModel model) {
      switch (model.state) {
        case ViewState.NoDataAvailable:
          return _noDataUi(context, model);
        case ViewState.Error:
          return _errorUi(context, model);
        case ViewState.DataFetched:
        default:
          return _getCustomerProfile(context, model);
      }
    }

    return BaseView<CustomerProfileViewModel>(
      builder: (context, child, model) => BusyOverlay(
        show: model.state == ViewState.Busy || model.state == ViewState.EditImageUrl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            leading: FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Icon(Icons.backspace)),
            title: Text("Edit Profile Page"),
            actions: <Widget>[
              Center(
                child: Text(
                  "CREDIT",
                ),
              ),
              Center(
                  child: Text(
                widget.user.points.toString(),
                style: TextStyle(color: Colors.red, fontSize: 25),
              )),
              Center(child: IconButton(icon: Icon(Icons.credit_card))),
            ],
          ),
          body: Builder(builder: (context) => _getBodyUi(context, model)),
        ),
      ),
    );
  }
}
