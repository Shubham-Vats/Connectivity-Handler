import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String trackID;
Map details;
Map lyrics;
String resultdata = '';

class SecondScreen extends StatefulWidget {
  
  final int trackId;
  const SecondScreen({Key key, @required this.trackId}) : super(key: key);
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  
  //Function to get Specific details and Lyrics with Track ID
  Future getSpecificDataAndLyrics() async{
    trackID=widget.trackId.toString();
    String urlSpecificDetails = "https://api.musixmatch.com/ws/1.1/track.get?track_id=$trackID&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7";
    String urlSpecificLyrics = "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackID&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7";
    try {
      http.Response responseSpecificDetails = await http.get(urlSpecificDetails);
      http.Response responseSpecificLyrics = await http.get(urlSpecificLyrics);
      if(responseSpecificDetails.statusCode.compareTo(responseSpecificLyrics.statusCode) == 0){

        print("Details and Lyrics Successfully Fetched");        
        
        details = json.decode(responseSpecificDetails.body);
        lyrics = json.decode(responseSpecificLyrics.body);
      
        return details;
      }
      else{
        print("Not be able to Fetch Details and Lyrics");
      }
    }catch (e) {
      debugPrint(e.toString());
    }
  }

  void checkConnectivity(){
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) { 
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        setState(() {
          resultdata = "Connected";
        });
      }
      else{
        setState(() {
          resultdata = "No Internet";
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }
  
  @override
  Widget build(BuildContext context) {
    setState(() {
      trackID = widget.trackId.toString();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Track Details",style: TextStyle(color: Colors.black),),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back,color: Colors.black)
        ),
      ),
      body: Center(
        child: resultdata != null ? Container(
          child: FutureBuilder(
            future: getSpecificDataAndLyrics(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData)
              {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.deepOrange],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Name",style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
                              SizedBox(height: 6.0,),
                              Text("${snapshot.data["message"]["body"]["track"]["track_name"]}", style: TextStyle(fontSize: 20.0, color: Colors.white),)
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Artist",style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
                              SizedBox(height: 6.0,),
                              Text("${snapshot.data["message"]["body"]["track"]["artist_name"]}", style: TextStyle(fontSize: 20.0, color: Colors.white),)
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Album Name",style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
                              SizedBox(height: 6.0,),
                              Text("${snapshot.data["message"]["body"]["track"]["album_name"]}", style: TextStyle(fontSize: 20.0, color: Colors.white),)
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Explicit",style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
                              SizedBox(height: 6.0,),
                              Text(snapshot.data["message"]["body"]["track"]["explicit"] == 0 ? "False" : "True", style: TextStyle(fontSize: 20.0, color: Colors.white),)
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Rating",style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
                              SizedBox(height: 6.0,),
                              Text("${snapshot.data["message"]["body"]["track"]["track_rating"]}", style: TextStyle(fontSize: 20.0, color: Colors.white),)
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Lyrics",style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
                              SizedBox(height: 6.0,),
                              Text("${lyrics["message"]["body"]["lyrics"]["lyrics_body"]}", style: TextStyle(fontSize: 20.0, color: Colors.white),)
                            ],
                          ),
                        ]
                      ),
                    ),
                  ),
                );
              }
              else
              {
                return Center(
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 100.0,
                          width: 100.0,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            gradient: LinearGradient(
                              colors: [Colors.orange, Colors.deepOrange]
                            ),
                          ),
                          height: 90.0,
                          width: 90.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Loading...", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 17.0),)
                          )
                        ),
                      ),
                    ],
                  )
                );
              }
            },
          ),
        ) : Text("Hello", style: TextStyle(fontSize: 25.0)),
      ),    
    );
  }
}
