import 'dart:math';
import 'dart:ui';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'dart:async';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_player/youtube_player.dart';

var cc = 'Latest';

void main() => runApp(splash());
bool f = false;
List<Api> favlist = List<Api>();
List<Api> apilist = List<Api>();
var clickedindex;
ScrollController ss;
DateTime timee = DateTime(56);
Map<String, Api> map = Map();
Color color;
Color color2;
Color color3;
const SCALE_FRACTION = 0.8;
const FULL_SCALE = 1.0;
const PAGER_HEIGHT = 550.0;
int currentPage = 0;
var t = TextStyle(color: Colors.white, fontSize: 25);
List<String> slist = <String>[
  "Now Playing",
  "Popular",
  "Top Rated",
  "Upcoming",
];

class calculator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return state();
  }
}

class state extends State<calculator> {
  double viewPortFraction = 0.8;
  PageController pageController;
  double page = 2.0;

  @override
  void initState() {
    pageController = PageController(
        initialPage: currentPage, viewportFraction: viewPortFraction);
    super.initState();
  }

  void dispose() {
    ss.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "calculator",
        debugShowCheckedModeBanner: false,
        home: Builder(
            builder: (context) => Stack(children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "${imageapi + apilist[currentPage].poster_path}"),
                            fit: BoxFit.cover)),
                  ),
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    body: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  GestureDetector(
                                    child: Icon(
                                      Icons.favorite,
                                      size: 35,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        f = true;
                                      });
                                    },
                                  ),
                                  Positioned(
                                    child: Text(
                                      favlist.length.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    top: 8.5,
                                    left: 13.5,
                                  )
                                ],
                              ),
                              /* IconButtton(
                                Icons.favorite,
                                size: 35,
                                color: Colors.red,
                              ),*/
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                    width: 200,
                                    height: 30,
                                    child: PageView.builder(
                                      physics: BouncingScrollPhysics(),
                                      onPageChanged: (p) {
                                        convert(slist[p]).then((value) {
                                          setState(() {
                                            f = false;
                                            apilist = new List<Api>();
                                            apilist.addAll(value);
                                            for (var i in apilist) {
                                              map[i.title] = i;
                                            }
                                          });
                                        });
                                      },
                                      itemCount: slist.length,
                                      itemBuilder: (context, index) => Center(
                                              child: Text(
                                            "${slist[index]}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )),
                                      pageSnapping: true,
                                      controller: PageController(
                                          viewportFraction: 0.65,
                                          initialPage: currentPage),
                                    )),
                              ),
                              IconButton(
                                icon: Icon(Icons.search),
                                iconSize: 35,
                                color: Colors.white,
                                onPressed: () {
                                  showSearch(
                                      context: context, delegate: DataSearch());
                                },
                              ),
                            ],
                          ),
                          Center(
                            child: Container(
                              color: Colors.transparent,
                              height: PAGER_HEIGHT,
                              child: NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification notification) {
                                  if (notification
                                      is ScrollUpdateNotification) {
                                    setState(() {
                                      page = pageController.page;
                                    });
                                  }
                                },
                                child: PageView.builder(
                                  onPageChanged: (pos) {
                                    setState(() {
                                      currentPage = pos;
                                    });
                                  },
                                  physics: BouncingScrollPhysics(),
                                  controller: pageController,
                                  itemCount:
                                      f ? favlist.length : apilist.length,
                                  itemBuilder: (context, index) {
                                    final scale = max(
                                        SCALE_FRACTION,
                                        (FULL_SCALE - (index - page).abs()) +
                                            viewPortFraction);
                                    return Center(
                                      child: Container(
                                        color: Colors.transparent,
                                        margin: EdgeInsets.all(10),
                                        height: PAGER_HEIGHT * scale,
                                        width: PAGER_HEIGHT * scale,
                                        child: Card(
                                          color: Colors.transparent,
                                          child: GestureDetector(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    child: Image(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(imageapi +
                                                          (f
                                                              ? favlist[index]
                                                                  .poster_path
                                                              : apilist[index]
                                                                  .poster_path)),

                                                      //   width:PAGER_HEIGHT  *scale ,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              setState(() {
                                                clickedindex =
                                                    apilist[index].title;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            calculator2()));
                                              });
                                            },
                                          ),
                                          elevation: 0,
                                          shape: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ])));
  }
}

class calculator2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return state2();
  }
}

class state2 extends State<calculator2> {
  Api keys, genre, details;
  bool finish = false;

  @override
  void initState() {
    // TODO: implement initState
    /* keys.key='12';
    details.runtime=0;
    details.release_date='';
    details.status='';*/
    convert4(map[clickedindex].id).then((value) {
      setState(() {
        details = value;
      });
    });
    /*convert3(map[clickedindex].id).then((value) {
      setState(() {
        genre = value;
      });
    });*/
    convert2(map[clickedindex].id).then((value) {
      setState(() {
        keys = value;
      });
    });
    Timer(
        Duration(seconds: 1),
        () => setState(() {
              if (keys.key == null) keys.key = '3';
              finish = true;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!finish)
      return Container(
        child: Center(
            child: Container(
                width: 50, height: 50, child: CircularProgressIndicator())),
        color: Colors.white,
      );
    else
      return Material(
          child: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: ListView(children: <Widget>[
              Column(children: <Widget>[
                Container(
                    child: YoutubePlayer(
                  source: keys.key,
                  quality: YoutubeQuality.LOW,
                  aspectRatio: 16 / 9,
                  showThumbnail: true,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.red,
                        width: 120,
                        height: 170,
                        child: Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              imageapi + map[clickedindex].poster_path),
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            child: Card(
                                child: Center(
                                    child: Text(map[clickedindex]
                                        .vote_average
                                        .toString())),
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Running Time:  ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(details.runtime.toString())
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Status:  ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(details.status.toString())
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Release Date:  ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(details.release_date.toString())
                              ]),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.favorite),
                        iconSize: 60,
                        color: map[clickedindex].fav ? Colors.red : Colors.grey,
                        onPressed: () {
                          setState(() {
                            if (!map[clickedindex].fav)
                              favlist.add(map[clickedindex]);
                            map[clickedindex].fav = true;
                          });
                        })
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Overview",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      Text(map[clickedindex].overview)
                    ],
                  ),
                )
              ])
            ]),
          ),
        ],
      ));
  }
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    var suggest = apilist.where((p) => p.title.startsWith(query)).toList();
    return Container(
      color: Colors.white,
      child: ListView.builder(
          itemCount: suggest.length,
          itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: GestureDetector(
                  child: ListTile(
                    leading: Image(
                      image:
                          NetworkImage(imageapi + suggest[index].poster_path),
                    ),
                    title: Text(
                      suggest[index].title,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    trailing: Container(
                      width: 60,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Text(
                                suggest[index]
                                    .vote_average
                                    .toDouble()
                                    .toString(),
                                style: TextStyle(color: Colors.black)),
                          ]),
                    ),
                  ),
                  onTap: () {
                    clickedindex = suggest[index].title;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => calculator2()));
                  }))),
    );
  }
}

class splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return splashscreen();
  }
}

class splashscreen extends State<splash> {
  bool finished = false;

  @override
  void initState() {
    // TODO: implement initState
    convert(slist[currentPage]).then((value) {
      setState(() {
        apilist.addAll(value);

        for (var i in apilist) {
          map[i.title] = i;
        }
      });
    });
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => setState(() {
              finished = true;
            }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Color.fromARGB(255, 0, 44, 79),
        home: Builder(
          builder: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (!finished) Image.asset("images/3711.gif"),
                    //CircularProgressIndicator(),
                    if (finished)
                      FloatingActionButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => calculator())),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 25,
                          color: Colors.white,
                        ),
                        backgroundColor: Color.fromARGB(255, 0, 44, 79),
                      )
                  ],
                ),
              ),
        ));
  }
}
