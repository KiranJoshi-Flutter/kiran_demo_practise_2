import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kiran_demo_practise_2/screens/PostScreen.dart';
import 'package:kiran_demo_practise_2/screens/about_us_screen.dart';
import 'package:kiran_demo_practise_2/screens/contact_us_screen.dart';

class Album {
  final int page;
  final int perPage;
  final List<dynamic> datas;

  Album({
    @required this.page,
    @required this.perPage,
    @required this.datas,
  });

  factory Album.froJson(Map<String, dynamic> json) {
    return Album(
      page: json['page'],
      perPage: json['per_page'],
      datas: json['data'],
    );
  }
}

Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse('https://reqres.in/api/users'));

  if (response.statusCode == 200) {
    return Album.froJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Album> futureAlbum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      drawer: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange,
              Colors.red,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.green,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Center(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                        'https://st.depositphotos.com/2101611/3925/v/600/depositphotos_39258143-stock-illustration-businessman-avatar-profile-picture.jpg',
                      ),
                    ),
                    title: Text('Kiran Joshi'),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                title: Text('Home'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostScreen(),
                    ),
                  );
                },
                title: Text('Posts'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUsScreen(),
                    ),
                  );
                },
                title: Text('About Us'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactUsScreen(),
                    ),
                  );
                },
                title: Text('Contact Us'),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: snapshot.data.datas.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Image.network(
                        '${snapshot.data.datas[index]['avatar']}',
                        height: 100.0,
                        width: 100.0,
                        alignment: Alignment.topLeft,
                      ),
                      Text('${snapshot.data.datas[index]['first_name']}'),
                      Text('${snapshot.data.datas[index]['email']}'),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.hasError}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
