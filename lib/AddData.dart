import 'package:flutter/material.dart';
import 'package:newsqlproject/Database/NotesDataBase.dart';
import 'package:newsqlproject/ShowData.dart';
import 'package:newsqlproject/models/NotesModel.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class AddData extends StatefulWidget {
  bool? istrue = false;
  NotesModal? notesModal;

  AddData({this.notesModal, this.istrue});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  DateTime? datePicked = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    update();
  }

  void update() {
    if (widget.istrue != true) {
      titlecontroller.clear();
      descriptioncontroller.clear();
    } else {
      titlecontroller.text = widget.notesModal!.title!;
      descriptioncontroller.text = widget.notesModal!.description!;
      datePicked = widget.notesModal!.time;
    }
  }

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  // TextEditingController timecontroller = TextEditingController();
  String errortitle = "Required*";
  String errordescrip = "Required*";
  String errordate = "you must enter date";
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
                controller: titlecontroller,
                decoration: InputDecoration(
                    errorText: errortitle,
                    hintText: "Note Title",
                    hintStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    border: InputBorder.none),
              ),
              TextField(
                style: TextStyle(
                  color: Colors.grey,
                ),
                maxLines: 5,
                controller: descriptioncontroller,
                decoration: InputDecoration(
                    errorText: errordescrip,
                    labelStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                    label: Text("Description"),
                    border: InputBorder.none),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () async {
                    datePicked = await DatePicker.showSimpleDatePicker(context,
                        initialDate: DateTime(1994),
                        firstDate: DateTime(1960),
                        lastDate: DateTime.now(),
                        locale: DateTimePickerLocale.en_us,
                        dateFormat: "dd/MM/yyyy");
                    print("fhdfhdjf" + datePicked.toString());
                  },
                  child: Text(
                    "Choose Date",
                    style: TextStyle(fontSize: 17),
                  )),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: Size(170, 50),
                          side: BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 62, 41, 223))),
                      child: widget.istrue != true
                          ? Text("Add Note",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 62, 41, 223)))
                          : Text(
                              "Update Note",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 62, 41, 223)),
                            ),
                      onPressed: () async {
                        // await print("hfjdhfjdhfjdhfjdfhdjfhdf");
                        print("helllo $datePicked");
                        if (titlecontroller.text.isEmpty) {
                          setState(() {
                            errortitle = "please enter title";
                          });
                        } else if (descriptioncontroller.text.isEmpty) {
                          setState(() {
                            errordescrip = "please enter description";
                          });
                        } else if (datePicked == null) {
                          print(datePicked);
                          AlertDialog(
                            title: Text("Warning!"),
                          );
                        } else if (widget.istrue != true) {
                          NotesDatabase.instance
                              .insert(
                            NotesModal(
                                title: titlecontroller.text.toString(),
                                description:
                                    descriptioncontroller.text.toString(),
                                time: datePicked),
                          )
                              .then((value) {
                            print("added");
                          }).onError((error, stackTrace) {
                            print(error.toString());
                          });
                          setState(() {
                            titlecontroller.clear();
                            descriptioncontroller.clear();
                          });
                        } else {
                          NotesDatabase.instance.update(NotesModal(
                              id: widget.notesModal!.id!,
                              title: titlecontroller.text.toString(),
                              description:
                                  descriptioncontroller.text.toString(),
                              time: datePicked));
                          setState(() {
                            widget.istrue = false;
                            NotesDatabase.instance.getUsers();
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => ShowData()));
                        }
                      },
                    )),
                    Container(
                        child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: Size(170, 50),
                          side: BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 41, 105, 21))),
                      child: Text(
                        "My Notes",
                        style:
                            TextStyle(color: Color.fromARGB(255, 41, 105, 21)),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => ShowData()));
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
