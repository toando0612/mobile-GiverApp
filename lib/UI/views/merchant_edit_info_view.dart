import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/scoped_model/merchant_edit_info_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'base_view.dart';

class MerchantEditInfoView extends StatefulWidget {
  final User user;
  MerchantEditInfoView({@required this.user});

  @override
  _MerchantEditInfoViewState createState() => _MerchantEditInfoViewState();
}

class _MerchantEditInfoViewState extends State<MerchantEditInfoView> {
  //save the result of gallery file
  String _selectedCate = '';

  static const menuCategories = <String>[
    'Food',
    'Clothing',
    'Accessories',
  ];
  final List<DropdownMenuItem<String>> _dropdownMenuCategories = menuCategories
      .map(
        (String value) => DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    ),
  )
      .toList();
  var isEditProfileImage = false;

//save the result of camera file
  File uploadFile;

  @override
  Widget build(BuildContext context) {

    Future<bool> updateNewImage(StorageReference ref, BuildContext context,
        MerchantEditInfoViewModel model) async {
      String uid = widget.user.id;
      print('start add new image');
      print('firename:');
      print(uid);
      StorageUploadTask uploadTask = ref.putFile(uploadFile);

      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      String url = dowurl.toString();
      print('URLLLLLLL: '+ url);
      setState(() {
        isEditProfileImage = false;
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
      model.onInfoEdited(url, uid);
      return true;
    }

    Future uploadPic(
        BuildContext context, MerchantEditInfoViewModel model) async {
      model.setState(ViewState.EditImageUrl);
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
        BuildContext context, MerchantEditInfoViewModel model, String url) {
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
                            ? Image.asset('assets/merchant.jpg')
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

    onSubmitCate(String newInput, MerchantEditInfoViewModel model) async {
        await model.onInfoEdited(newInput, widget.user.id);
    }

    onSubmit(String newInput, String currentInput, MerchantEditInfoViewModel model) async {
      if (newInput != currentInput){
        await model.onInfoEdited(newInput, widget.user.id);
      }else{
        model.setState(ViewState.DataFetched);
      }
    }
    Widget _getCenteredViewMessage(
        BuildContext context, String message, MerchantEditInfoViewModel model,
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

    Widget _noDataUi(BuildContext context, MerchantEditInfoViewModel model) {
      return _getCenteredViewMessage(context, "No data available yet", model);
    }

    Widget _errorUi(BuildContext context, MerchantEditInfoViewModel model) {
      return _getCenteredViewMessage(
          context, "Error retrieving your data. Tap to try again", model,
          error: true);
    }

    Widget _getMerchantProfile(
        BuildContext context, MerchantEditInfoViewModel model) {
      User currentUser = model.getCurrentUser(model.merchants, widget.user.id);
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
              Divider(),
              ListTile(
                leading: Icon(Icons.my_location),
                title: model.state != ViewState.EditLocation
                    ? Text(currentUser.address??'')
                    : TextFormField(
                  onFieldSubmitted: (newInput) => onSubmit(newInput, currentUser.address, model),
                  initialValue: currentUser.address,
                ),
                trailing: FlatButton(
                    onPressed: () => model.setState(ViewState.EditLocation),
                    child: Icon(Icons.edit)),
              ),
              Divider(),
              ListTile(
                leading: DropdownButton(
                  value: _selectedCate==''?currentUser.category:_selectedCate,
                  hint: Text('Choose'),
                  onChanged: (String newValue) {
                    setState(() {
                      _selectedCate = newValue;
                      model.setState(ViewState.EditCategory);
                    });
                  },
                  items: _dropdownMenuCategories,
                ),
                trailing: _selectedCate!=''?FlatButton(
                    onPressed: () => onSubmitCate(_selectedCate, model),
                    child: Icon(Icons.check_box)):Text(''),
              ),
            ],
          ),
        ),
      );
    }

    Widget _getBodyUi(BuildContext context, MerchantEditInfoViewModel model) {
      switch (model.state) {
        case ViewState.NoDataAvailable:
          return _noDataUi(context, model);
        case ViewState.Error:
          return _errorUi(context, model);
        case ViewState.DataFetched:
        default:
          return _getMerchantProfile(context, model);
      }
    }

    return BaseView<MerchantEditInfoViewModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          leading: FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Icon(Icons.backspace)),
          title: Text("Edit Profile Page"),
        ),
        body: Builder(builder: (context) => _getBodyUi(context, model)),
      ),
    );
  }
}
