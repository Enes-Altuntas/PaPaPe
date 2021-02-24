import 'package:bulovva/Register/screens/Register.dart';
import 'package:bulovva/Map/screens/Map.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashState createState() => _DashState();
}

class _DashState extends State {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[Map(), Register()];

  void onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Bulovva',
            style: GoogleFonts.bebasNeue(
                fontSize: 25,
                fontStyle: FontStyle.normal,
                color: Colors.purple[800]),
          ),
        ),
        backgroundColor: Colors.amber[600],
      ),
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Kayıt Ol',
          ),
        ],
        selectedItemColor: Colors.purple[800],
        backgroundColor: Colors.amber[600],
        currentIndex: _selectedIndex,
        onTap: onItemTap,
      ),
    );
  }
}
