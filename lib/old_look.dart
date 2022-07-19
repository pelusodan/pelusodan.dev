import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter95/flutter95.dart';
import 'dart:js' as js;

void main() {
  runApp(Flutter95App());
}

class Flutter95Stateful extends StatefulWidget {
  final title;

  const Flutter95Stateful({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Flutter95State();
}

class IndexedWindow {
  int index;
  Widget widget;

  IndexedWindow(this.index, this.widget);
}

class _Flutter95State extends State<Flutter95Stateful> {
  /**
   * This keeps track of the windows on our screen
   */
  List<int> windowIds = [0, 1, 99, 2];

  Offset aboutPosition = Offset(100, 100);
  Offset projectPosition = Offset(200, 200);
  double prevScale = 1;
  double scale = 1;

  String? currentEmail;

  String? currentMessage;

  String? currentName;

  void updateScale(double zoom) => setState(() => scale = prevScale * zoom);

  void commitScale() => setState(() => prevScale = scale);

  void updateAboutPosition(Offset newPosition) => setState(() {
        aboutPosition = newPosition;
        windowIds.remove(1);
        windowIds.add(1);
      });

  void updateProjectPosition(Offset newPosition) => setState(() {
        projectPosition = newPosition;
        windowIds.remove(2);
        windowIds.add(2);
      });

  void updateStaticContactPosition() => setState(() {
        windowIds.remove(99);
        windowIds.add(99);
      });

  var accepted = false;
  var verticalOffset = 77;

  Toolbar95 mainToolbar() {
    return Toolbar95(actions: [
      Item95(
        label: 'File',
        menu: _buildMenu(),
      ),
      Item95(
        label: 'Edit',
        onTap: (context) {},
      ),
      Item95(
        label: 'Save',
        onTap: (context) {},
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Material(
      type: MaterialType.transparency,
      child: Scaffold95(
          title: 'peluso.dev',
          toolbar: mainToolbar(),
          body: Container(
              width: screenWidth,
              height: screenHeight - verticalOffset,
              child: GestureDetector(
                onScaleUpdate: (details) => updateScale(details.scale),
                onScaleEnd: (_) => commitScale(),
                child: Stack(
                    children: windowIds
                        .map((e) => generateWidgetFromId(e, context))
                        .toList()),
              ))),
    );
  }

  Menu95 _buildMenu() {
    return Menu95(
      items: [
        MenuItem95(
          value: 1,
          label: 'New',
        ),
        MenuItem95(
          value: 2,
          label: 'Open',
        ),
        MenuItem95(
          value: 3,
          label: 'Exit',
        ),
      ],
      onItemSelected: (item) {
        if(item==1) {
          js.context.callMethod('open',
              [
                'https://pelusodan.com'
              ]);
        }
      },
    );
  }

  Widget buildAbout() {
    return Draggable(
      maxSimultaneousDrags: 1,
      data: 'about_window',
      child: Transform.scale(
        scale: scale,
        child: buildAboutWindowContent(),
      ),
      feedback: buildAboutWindowContent(),
      childWhenDragging: Container(),
      onDragEnd: (details) => updateAboutPosition(details.offset),
    );
  }

  Widget buildProject() {
    return Draggable(
      maxSimultaneousDrags: 1,
      data: 'contact_window',
      child: Transform.scale(
        scale: scale,
        child: buildProjectContent(),
      ),
      feedback: buildProjectContent(),
      childWhenDragging: Container(),
      onDragEnd: (details) => updateProjectPosition(details.offset),
    );
  }

  Widget buildAboutWindowContent() {
    return Elevation95(
        type: Elevation95Type.down,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                width: 500,
                height: 300,
                child: Scaffold95(
                  title: "About",
                  toolbar: Toolbar95(
                    actions: [
                      Item95(
                        label: 'socials',
                        menu: Menu95(
                            items: [
                              MenuItem95(value: 1, label: 'github'),
                              MenuItem95(value: 2, label: 'linkedin'),
                              MenuItem95(value: 3, label: 'twitter')
                            ],
                            onItemSelected: (item) {
                              switch (item) {
                                case 1:
                                  {
                                    js.context.callMethod('open',
                                        [
                                          'https://github.com/pelusodan'
                                        ]);
                                  }
                                  break;
                                case 2:
                                  {
                                    js.context.callMethod('open',
                                        [
                                          'https://www.linkedin.com/in/pelusodan/'
                                        ]);
                                  }
                                  break;
                                case 3:
                                  {
                                    js.context.callMethod('open',
                                        [
                                          'https://twitter.com/DanPeluso2'
                                        ]);
                                  }
                                  break;
                              }

                            }),
                      )
                    ],
                  ),
                  body: Row(
                    children: [
                      Image.asset(
                        'img/header_dan.png',
                        width: 190,
                        height: 190,
                      ),
                      Text(
                        'mobile developer \nhardware engineer \nmusician',
                        style: Flutter95.textStyle,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget buildContactMeContent() {
    return GestureDetector(
      child: Elevation95(
          type: Elevation95Type.down,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                    width: 500,
                    height: 500,
                    child: Scaffold95(
                      title: "Contact Me",
                      body: buildContactMeForm(),
                    )),
              ],
            ),
          )),
      onTap: () {
        updateStaticContactPosition();
      },
    );
  }

  Widget generateWidgetFromId(int e, BuildContext context) {
    if (e == 0) {
      return Positioned.fill(
          child: Container(
        color: Colors.blue,
      ));
    } else if (e == 1) {
      return Positioned(
        child: buildAbout(),
        left: aboutPosition.dx,
        top: aboutPosition.dy - verticalOffset,
      );
    } else if (e == 2) {
      return Positioned(
        child: buildProject(),
        left: projectPosition.dx,
        top: projectPosition.dy - verticalOffset,
      );
    } else if (e == 99) {
      //This serves as the contact form which cannot move
      return Positioned(
        child: buildContactMeContent(),
        bottom: 50,
        right: 20,
      );
    } else {
      return Container();
    }
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  final subjectController = TextEditingController();

  Widget buildContactMeForm() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(children: [
        Row(
          children: [
            Text("name",
                style:
                    Flutter95.textStyle.copyWith(fontWeight: FontWeight.bold)),
            Expanded(
                child: Container(
              child: TextField95(
                controller: nameController,
              ),
              margin: const EdgeInsets.all(10),
            )),
          ],
        ),
        Row(
          children: [
            Text("email",
                style:
                    Flutter95.textStyle.copyWith(fontWeight: FontWeight.bold)),
            Expanded(
                child: Container(
              child: TextField95(
                controller: emailController,
              ),
              margin: const EdgeInsets.all(10),
            )),
          ],
        ),
        Row(
          children: [
            Text("subject",
                style:
                    Flutter95.textStyle.copyWith(fontWeight: FontWeight.bold)),
            Expanded(
                child: Container(
              child: TextField95(
                controller: subjectController,
              ),
              margin: const EdgeInsets.all(10),
            )),
          ],
        ),
        Row(
          children: [
            Text("message",
                style:
                    Flutter95.textStyle.copyWith(fontWeight: FontWeight.bold)),
            Expanded(
                child: Container(
              child: TextField95(
                height: 100,
                maxLines: 5,
                multiline: true,
                controller: messageController,
              ),
              margin: const EdgeInsets.all(10),
            )),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(15),
          child: Button95(
            onTap: () {
              //TODO: Make this send an email to my account
            },
            child: Text(
              'submit',
              style: Flutter95.textStyle,
            ),
          ),
        )
      ]),
    );
  }

  Widget buildProjectContent() {
    return Elevation95(
        type: Elevation95Type.down,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                width: 500,
                height: 300,
                child: Scaffold95(
                  title: "WalletGuru",
                  toolbar: Toolbar95(
                    actions: [
                      Item95(
                        label: 'repo',
                        onTap: (_) async {
                          onRepoTapped();
                        },
                      )
                    ],
                  ),
                  body: Row(
                    children: [
                      Image.asset(
                        'img/wallet_guru.png',
                        width: 190,
                        height: 190,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'WalletGuru is a finance-based Reddit client designed to show users the most relevant information to their current account balance performance.',
                              style: Flutter95.textStyle,
                              textAlign: TextAlign.center,
                            ),
                            Image.asset(
                              'img/feed.png',
                              width: 80,
                              height: 80,
                            )
                          ],
                        )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void onRepoTapped() {
    js.context.callMethod(
        'open', ['https://github.com/pelusodan/WalletGuru']);
  }
}

class Flutter95App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Flutter95.background,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  var accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold95(
        title: 'Flutter95',
        toolbar: Toolbar95(actions: [
          Item95(
            label: 'File',
            menu: _buildMenu(),
          ),
          Item95(
            label: 'Edit',
            onTap: (context) {},
          ),
          Item95(
            label: 'Save',
            onTap: (context) {},
          ),
        ]),
        body: Container(
          width: 800,
          height: 800,
          child: Stack(
            children: [
              Positioned.fill(
                  child: Container(
                color: Colors.blue,
              )),
              buildAbout(),
            ],
          ),
        ));
  }

  Menu95 _buildMenu() {
    return Menu95(
      items: [
        MenuItem95(
          value: 1,
          label: 'New',
        ),
        MenuItem95(
          value: 2,
          label: 'Open',
        ),
        MenuItem95(
          value: 3,
          label: 'Exit',
        ),
      ],
      onItemSelected: (item) {
        if(item==1) {
          js.context.callMethod('open',
              [
                'https://pelusodan.com'
              ]);
        }
      },
    );
  }

  Widget buildAbout() {
    return Draggable(
      data: 'about_window',
      child: Elevation95(
          type: Elevation95Type.down,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  width: 500,
                  height: 300,
                  child: Scaffold95(
                    title: "About",
                    toolbar: Toolbar95(
                      actions: [
                        Item95(
                          label: 'socials',
                          menu: Menu95(
                              items: [
                                MenuItem95(value: 1, label: 'github'),
                                MenuItem95(value: 2, label: 'linkedin'),
                                MenuItem95(value: 3, label: 'twitter')
                              ],
                              onItemSelected: (item) {

                              }),
                        )
                      ],
                    ),
                    body: Row(
                      children: [
                        Image.asset(
                          'img/header_dan.png',
                          width: 190,
                          height: 190,
                        ),
                        Text(
                          'mobile developer \nhardware engineer \nmusician',
                          style: Flutter95.textStyle,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
      feedback: Elevation95(
          type: Elevation95Type.down,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  width: 500,
                  height: 300,
                  child: Scaffold95(
                    title: "About",
                    toolbar: Toolbar95(
                      actions: [
                        Item95(
                          label: 'socials',
                          menu: Menu95(
                              items: [
                                MenuItem95(value: 1, label: 'github'),
                                MenuItem95(value: 2, label: 'linkedin'),
                                MenuItem95(value: 3, label: 'twitter')
                              ],
                              onItemSelected: (item) {}
                              ),
                        )
                      ],
                    ),
                    body: Row(
                      children: [
                        Image.asset(
                          'img/header_dan.png',
                          width: 190,
                          height: 190,
                        ),
                        Text(
                          'mobile developer \nhardware engineer \nmusician',
                          style: Flutter95.textStyle,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
      childWhenDragging: Container(),
    );
  }

  Widget buildDragTarget() {
    return DragTarget(
      builder: (context, List<String?> candidateData, rejectedData) {
        return accepted ? buildAbout() : Container();
      },
      onAccept: (data) {
        accepted = false;
      },
      onWillAccept: (data) {
        return true;
      },
      onMove: (data) {
        accepted = false;
      },
    );
  }
}