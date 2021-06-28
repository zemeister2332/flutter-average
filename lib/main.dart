import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  String titleApp = "Average Application";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: titleApp,
      theme:
          ThemeData(accentColor: Colors.tealAccent, primarySwatch: Colors.teal),
      home: HomePageApp(titleApp),
    );
  }
}

class HomePageApp extends StatefulWidget {
  final String? titleApp;
  HomePageApp(this.titleApp);
  @override
  _HomePageAppState createState() => _HomePageAppState();
}

class _HomePageAppState extends State<HomePageApp> {
  String subjectName = "";
  int? subjectPercent;
  int? subjectScore = 7;
  List<Subject>? allSubject;
  var formKey = GlobalKey<FormFieldState>();
  double average = 0;

  static int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allSubject = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.titleApp!,
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          }
        },
        child: Icon(Icons.check, color: Colors.black),
        backgroundColor: Colors.yellowAccent,
      ),
      body: applicationBodyPart(),
    );
  }

  Widget applicationBodyPart() {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // STATIC FORM BLOCK
          Expanded(
            child: Container(
              // color: Colors.yellowAccent,
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 3, color: Colors.green)),
                            border: OutlineInputBorder(),
                            labelText: "Subject",
                            hintText: "Enter Subject Name",
                            labelStyle: TextStyle(fontSize: 20.0)),
                        validator: (inputSubject) {
                          if (inputSubject!.length > 3) {
                            return null;
                          } else {
                            return "Subject Name Must Be Minimum 3 Symbols";
                          }
                        },
                        onSaved: (savedInput) {
                          setState(
                            () {
                              subjectName = savedInput!;
                              allSubject!.add(Subject(
                                  subjectName, subjectPercent, subjectScore));
                              // print(subjectName);
                              average = 0;
                              calculateTheAverage();
                            },
                          );
                        }),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border:
                                  Border.all(color: Colors.green, width: 3)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text(
                                "Score Percents",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              value: subjectPercent,
                              items: subjectPercentGenerate(),
                              onChanged: (int? selectedItem) {
                                setState(() {
                                  subjectPercent = selectedItem;
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border:
                                  Border.all(color: Colors.green, width: 3)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text(subjectScore.toString()),
                              value: subjectScore,
                              items: subjectScoreGenerate(),
                              onChanged: (int? selectedItem) {
                                setState(() {
                                  subjectScore = selectedItem;
                                  print(subjectScore);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              // color: Colors.amberAccent,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Average: ${average.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 36.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[300]),
              // color: Colors.greenAccent,
              child: ListView.builder(
                itemBuilder: _itemBuilderForCards,
                itemCount: allSubject!.length,
              ),
            ),
            flex: 4,
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> subjectPercentGenerate() {
    List<DropdownMenuItem<int>> percents = [];
    for (var i = 10; i < 101; i += 10) {
      percents.add(
        DropdownMenuItem(
          child: Text(
            "Percent: $i %",
            style: TextStyle(fontSize: 20.0),
          ),
          value: i,
        ),
      );
    }
    return percents;
  }

  List<DropdownMenuItem<int>> subjectScoreGenerate() {
    List<DropdownMenuItem<int>> scores = [];
    for (var i = 1; i < 10; i += 1) {
      scores.add(
        DropdownMenuItem(
          child: Text(
            "Score: $i",
            style: TextStyle(fontSize: 20.0),
          ),
          value: i,
        ),
      );
    }
    return scores;
  }

  Widget _itemBuilderForCards(context, index) {
    count += 1;
    print("COUNT: $count");
    return Dismissible(
      key: Key(count.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          allSubject!.removeAt(index);
          print(direction);
          calculateTheAverage();
        });
      },
      child: Card(
        child: ListTile(
          title: Text(
            allSubject![index].name!,
            style: TextStyle(fontSize: 24.0),
          ),
          subtitle: Text(allSubject![index].percent.toString() + "%"),
          trailing: CircleAvatar(
            child: Text(
              allSubject![index].score.toString(),
              style: TextStyle(fontSize: 22.0),
            ),
          ),
        ),
      ),
    );
  }

  void calculateTheAverage() {
    int totalPercent = 0;
    int totalScore = 0;
    average = 0;
    for (var element in allSubject!) {
      var percent = element.percent;
      var ball = element.score;

      //totalPercent += percent!;
      //totalScore += ball!;
      average += (ball! * percent! / 100);
      print("AVERAGE" + average.toString());
    }
  }
}

class Subject {
  String? name;
  int? percent;
  int? score;

  Subject(this.name, this.percent, this.score);
}
