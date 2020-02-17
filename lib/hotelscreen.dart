import 'package:flutter/material.dart';

class HotelScreen extends StatefulWidget {
  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Explore',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.room,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {})
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 180,
            color: Colors.grey[200],
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            labelText: "London",
                            filled: true,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 50.0,
                              width: 50.0,
                              child: Center(
                                  child: Icon(
                                Icons.search,
                                color: Colors.white,
                              )),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.greenAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                    offset: Offset(5.0, 5.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Choose Date'),
                              Text(
                                '12 Dec - 22 Dec',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 60,
                              child: VerticalDivider(color: Colors.black26),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Number of Rooms'),
                                Text(
                                  '1 Room - 2 Adults',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              color: Colors.white70,
              height: 60,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '530 hotels found',
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Filters',
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 19),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.sort,
                          color: Colors.greenAccent,
                          size: 40,
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            height: MediaQuery.of(context).size.height * 0.45,
            child: Card(
              color: Colors.white,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 5,
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://cdn.content.tuigroup.com/adamtui/2016_9/28_18/34f75ef4-3a6d-4650-ab04-a68f0133fdbe/NRV_SOR_1672WebOriginalCompressed.jpg?i10c=img.resize(width:1080)'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 35.0,
                                width: 35.0,
                                child: Center(
                                    child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.greenAccent,
                                )),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15,top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Grand Royal Hotel',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    Row(
                                      children: <Widget>[
                                        Text('Wembley, London '),
                                        Icon(
                                          Icons.room,
                                          color: Colors.greenAccent,
                                        ),
                                        Text('2 km to city')
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.star,
                                            color: Colors.greenAccent),
                                        Icon(Icons.star,
                                            color: Colors.greenAccent),
                                        Icon(Icons.star,
                                            color: Colors.greenAccent),
                                        Icon(Icons.star,
                                            color: Colors.greenAccent),
                                        Icon(Icons.star_border,
                                            color: Colors.greenAccent),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8),
                                              child: Text('80 Reviews'),
                                            )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        '180 Bath',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Text('/per night'),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        color: Colors.white,
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
