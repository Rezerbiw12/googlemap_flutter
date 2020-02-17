import 'package:flutter/material.dart';

class HotelScreen extends StatefulWidget {
  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  var data = [
    {
      'id': 1,
      'name': 'Grand Royal Hotel',
      'price': '180',
      'km': '2',
      'review': '80',
      'url':
          'https://cdn.content.tuigroup.com/adamtui/2016_9/28_18/34f75ef4-3a6d-4650-ab04-a68f0133fdbe/NRV_SOR_1672WebOriginalCompressed.jpg?i10c=img.resize(width:1080)'
    },
    {
      'id': 2,
      'name': 'Queen Hotel',
      'price': '220',
      'km': '3',
      'review': '200',
      'url':
          'https://q-cf.bstatic.com/images/hotel/max1024x768/681/68184730.jpg'
    },
    {
      'id': 3,
      'name': 'Coffee Hotel',
      'price': '150',
      'km': '4',
      'review': '150',
      'url':
          'https://pix10.agoda.net/hotelImages/104/104972/104972_16072716330044991252.jpg?s=1024x768'
    }
  ];
  getdata() {
    setState(() {
      print(data);
    });
  }

  @override
  void initState() {
    getdata();
    // TODO: implement initState
    super.initState();
  }

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
            height: 150,
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
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              autofocus: false,
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black26),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'London',
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                              ),
                            ),
                          )),
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
                                color: Colors.teal[300],
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
                              Text(
                                'Choose Date',
                                style: TextStyle(color: Colors.black26),
                              ),
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
                              height: 35,
                              child: VerticalDivider(color: Colors.black26),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Number of Rooms',
                                  style: TextStyle(color: Colors.black26),
                                ),
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
              height: 60,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '530 hotels found',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Filters',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 19),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.sort,
                          color: Colors.teal[300],
                          size: 40,
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
          Expanded(child: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
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
                                  data[index]['url']
                                ),
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
                                    color: Colors.teal[300],
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
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(data[index]['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      Row(
                                        children: <Widget>[
                                          Text('Wembley, London '),
                                          Icon(
                                            Icons.room,
                                            color: Colors.teal[300],
                                          ),
                                          Text('${data[index]['km']} km to city')
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.star,
                                              color: Colors.teal[300]),
                                          Icon(Icons.star,
                                              color: Colors.teal[300]),
                                          Icon(Icons.star,
                                              color: Colors.teal[300]),
                                          Icon(Icons.star,
                                              color: Colors.teal[300]),
                                          Icon(Icons.star_border,
                                              color: Colors.teal[300]),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text('${data[index]['review']} Reviews'),
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
                                          ' ${data[index]['price']} Bath',
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
              );
            },
          ))
        ],
      ),
    );
  }
}
