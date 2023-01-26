import 'package:chat_app/base.dart';
import 'package:chat_app/models/room_category.dart';
import 'package:chat_app/modules/add_room/add_room_navigator.dart';
import 'package:chat_app/modules/add_room/add_room_viewmodel.dart';
import 'package:chat_app/modules/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class addRoomScreen extends StatefulWidget {
  static const String routeName = "RoomScreen";

  @override
  State<addRoomScreen> createState() => _addRoomScreenState();
}

class _addRoomScreenState extends BaseView<addRoomScreen, AddRoomViewModel>
    implements AddRoomNavigator {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var roomNameController = TextEditingController();
  var roomDescriptionController = TextEditingController();
  var categories = RoomCategory.getCategories();
  late RoomCategory roomCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
    roomCategory = categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/main_bg.png',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Chat App'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Form(
              key: formKey,
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 21, vertical: 42),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 16,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                            child: Text(
                          'Create New Room',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        Image.asset(
                          'assets/images/create_room_bg.png',
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: roomNameController,
                          decoration: InputDecoration(
                            hintText: 'Room Name',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'Please Enter Room Name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        DropdownButton<RoomCategory>(
                            value: roomCategory,
                            items: categories
                                .map((category) =>
                                    DropdownMenuItem<RoomCategory>(
                                        value: category,
                                        child: Row(
                                          children: [
                                            Image.asset(category.image,
                                                fit: BoxFit.fill),
                                            Text(category.name),
                                          ],
                                        )))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              roomCategory = value;
                              setState(() {});
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: roomDescriptionController,
                          decoration: InputDecoration(
                            hintText: 'Room Description',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'Please Enter Room Description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              validateForm();
                            },
                            child: const Text('Create')),
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      viewModel.createRoom(roomNameController.text,
          roomDescriptionController.text, roomCategory.id);
    }
  }

  @override
  AddRoomViewModel initViewModel() => AddRoomViewModel();

  @override
  void roomCreated() {
    Navigator.pop(context);
    setState(() {});
  }
}
