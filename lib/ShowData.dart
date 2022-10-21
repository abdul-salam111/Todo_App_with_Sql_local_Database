import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:newsqlproject/AddData.dart';
import 'package:newsqlproject/Database/NotesDataBase.dart';
import 'package:newsqlproject/DetailsPage.dart';
import 'package:newsqlproject/models/NotesModel.dart';

class ShowData extends StatefulWidget {
  const ShowData({Key? key}) : super(key: key);

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  late Future<List<NotesModal>> noteslist;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      noteslist = NotesDatabase.instance.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Data'),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: noteslist,
            builder: ((context, AsyncSnapshot<List<NotesModal>> snapshot) {
              return snapshot.data == null
                  ? Center(
                      child: LoadingAnimationWidget.dotsTriangle(
                        color: Colors.black,
                        size: 200,
                      ),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, int index) {
                        return Dismissible(
                          onDismissed: (DismissDirection direction) {
                            setState(() {
                              NotesDatabase.instance.delete(
                                  NotesModal(id: snapshot.data![index].id));
                              noteslist = NotesDatabase.instance.getUsers();
                            });
                          },
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => DetailPage(
                                            title: snapshot.data![index].title,
                                            description: snapshot
                                                .data![index].description,
                                            dateTime:
                                                snapshot.data![index].time,
                                          )));
                            },
                            child: Card(
                                child: ListTile(
                                    dense: true,
                                    minLeadingWidth: 0,
                                    leading: CircleAvatar(
                                      radius: 35,
                                      child: Text(
                                        snapshot.data![index].title
                                            .toString()[0]
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    isThreeLine: true,
                                    title: Text(
                                      snapshot.data![index].title.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      snapshot.data![index].description
                                          .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: SizedBox(
                                        width: 150,
                                        child: Row(children: [
                                          Text(
                                            DateFormat.yMd().format(snapshot
                                                .data![index].time as DateTime),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          AddData(
                                                            notesModal: snapshot
                                                                .data![index],
                                                            istrue: true,
                                                          )));
                                            },
                                            icon: Icon(Icons.edit),
                                          ),
                                        ])))),
                          ),
                          secondaryBackground: Container(
                            child: Center(
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            color: Colors.red,
                          ),
                          background: Container(),
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                        );
                      },
                    );
            }),
          )),
        ],
      ),
    );
  }
}
