import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/RouteTransition.dart';
import 'package:smartpark/Screen/PageChangePassword.dart';
import 'package:smartpark/Screen/PageGeneralSettings.dart';
import 'package:smartpark/Screen/PageLogin.dart';
import 'package:smartpark/Screen/PageParkingHistory.dart';
import 'package:division/division.dart';
import 'package:smartpark/Screen/PageWallet.dart';

class PageProfile extends StatefulWidget {
  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Profile", style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: SafeArea(
        child: UserPage(),
      )
    );
  }
}

class UserPage extends StatelessWidget {
  final contentStyle = (BuildContext context) => ParentStyle()
    ..overflow.scrollable()
    ..padding(vertical: 30, horizontal: 20)
    ..minHeight(MediaQuery.of(context).size.height - (2 * 30));

  final titleStyle = TxtStyle()
    ..bold()
    ..fontSize(32)
    ..margin(bottom: 20)
    ..alignmentContent.centerLeft();

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: contentStyle(context),
      child: Column(
        children: <Widget>[
          UserCard(),
          SizedBox(height: 10,),
          Settings(),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final User _user = User();
  Widget _buildUserRow(){
    return StreamBuilder<dynamic>(
      stream: _user.userData(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          return Row(
            children: <Widget>[
              Parent(
                style: userImageStyle,
                child: Icon(
                  Icons.person_outline,
                  color: hex("#8860d0")
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Txt(snapshot.data["userName"], style: nameTextStyle,),
                  Txt(snapshot.data["userEmail"], style: nameDescriptionTextStyle,),
                  Txt(snapshot.data["userPhoneNumber"], style: nameDescriptionTextStyle,),
                  Txt("Credit: Rs " + snapshot.data["userCredit"].toString(), style: nameDescriptionTextStyle,)
                ],
              ),
            ],
          );
        }
        else{
          return Container();
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: userCardStyle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildUserRow(), 
        ],
      ),
    );
  }

  //Styling
  static List<Color> color = [Color(0xff8860d0), Color(0xff5ab9ea)];
  final ParentStyle userCardStyle = ParentStyle()
    ..height(100)
    ..padding(horizontal: 20.0, vertical: 10)
    ..alignment.center()
    ..linearGradient(colors: color)
    ..borderRadius(all: 20.0)
    ..elevation(10, color: hex('#3977FF'));

  final ParentStyle userImageStyle = ParentStyle()
    ..height(50)
    ..width(50)
    ..margin(right: 10.0)
    ..borderRadius(all: 30)
    ..background.hex('ffffff');

  final ParentStyle userStatsStyle = ParentStyle()..margin(vertical: 10.0);

  final TxtStyle nameTextStyle = TxtStyle()
    ..textColor(Colors.white)
    ..fontSize(18)
    ..fontWeight(FontWeight.w600);

  final TxtStyle nameDescriptionTextStyle = TxtStyle()
    ..textColor(Colors.white.withOpacity(0.6))
    ..fontSize(12);
}

class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Actions",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        SettingsItem( Icons.history, hex('#f172a1'), 'History', 'Your Transaction history'),

        SettingsItem( Icons.attach_money, hex('#a1c3d1'), 'Wallet', 'Credit details'),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "General Settings",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        SettingsItem(Icons.person, hex('#8860d0'), 'Profile Settings', 'Change your name & phone number'),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Account",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        SettingsItem( Icons.lock, hex('#84ceeb'), 'Account Settings', 'Change your password'),
        SettingsItem(Icons.delete, hex('#ac3b61'), 'Delete Account', 'Delete your account'),
        SettingsItem(Icons.power_settings_new, hex('#b39bc8'), 'Logout', 'Sign out'),
      ],
    );
  }
}

class SettingsItem extends StatefulWidget {
  SettingsItem(this.icon, this.iconBgColor, this.title, this.description);

  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String description;

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  final User _user = User();
  final System _system = System();
  bool pressed = false;
  String selected;
  String _password = "";

  void _dialogDeleteAccount(){
    Alert(
      context: context,
      type: AlertType.warning,
      title: "",
      desc: "Are you sure you want to delete your account?",
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: Colors.red, 
              fontSize: 20
            ),
          ),
          onPressed: (){
            Navigator.of(context).pop();
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.red,
          child: Text(
            "Confirm",
            style: TextStyle(
              color: Colors.white, 
              fontSize: 20
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            _dialogPassword("deleteAccount");
          },
          width: 120,
        )
      ],
    ).show();
  }  
 
  void _dialogPasswordError(type){
    Alert(
      context: context,
      type: AlertType.error,
      title: "OH NO!",
      desc: "Incorrect password",
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            "Try Again",
            style: TextStyle(
              color: Colors.white, 
              fontSize: 20
            ),
          ),
          onPressed: (){
            Navigator.of(context).pop();
            _dialogPassword(type);
          },
          width: 120,
        )
      ],
    ).show();
  }

  Widget _widgetPassword(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15,),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextField(
          onChanged: (String value){
            setState(() {
              _password = value;
            });
          },
          obscureText: true,
          cursorColor: Colors.deepPurple,
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: Material(
              elevation: 0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Icon(
                Icons.lock_outline,
                color: hex("#8860d0"),
              ),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)
          ),
        ),
      ),
    );
  }

  void _dialogPassword(type){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Please enter your current password"),
              _widgetPassword(),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.red
                ),
              ),
              onPressed: () async{
                if (_password == ""){
                  Navigator.of(context).pop(0);
                  return _dialogPasswordError(type);
                }
                else{
                  var result = await _system.validateCurrentPassword(_password, context);
                  if (result){
                    if (type == "password"){
                      Navigator.push(context, RouteTransition(page: PageChangePassword()));
                    }
                    else if (type == "deleteAccount"){
                      await _user.deleteAccount();
                      Navigator.pushAndRemoveUntil(context, RouteTransition(page: PageLogin()), (route) => false);
                    }
                  }
                  else{
                    _dialogPasswordError(type);
                  }
                }
              },
            ),
            FlatButton(
              child: Text("Dismiss"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: settingsItemStyle(pressed),
      gesture: Gestures()
        ..onTap(() async {
          setState(() {
            selected = widget.title;
          });
          if (selected == "Profile Settings"){
            var userDetails = await _user.getUserDetails();
            Navigator.push(context, RouteTransition(page: PageGeneralSettings(name: userDetails.data["userName"], phoneNumber: userDetails.data["userPhoneNumber"],)));
          }
          else if (selected == "Wallet"){
            Navigator.push(context, RouteTransition(page: PageWallet()));
          }
          else if(selected == "Account Settings"){
            _dialogPassword("password");
          }
          else if(selected == "History"){
            Navigator.push(context, RouteTransition(page: PageParkingHistory()));
          }
          else if(selected == "Delete Account"){
            _dialogDeleteAccount();
          }
          else if(selected == "Logout"){
            await _user.signOut(context);
          }
        }
      ),
      child: Row(
        children: <Widget>[
          Parent(
            style: settingsItemIconStyle(widget.iconBgColor),
            child: Icon(widget.icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Txt(widget.title, style: itemTitleTextStyle),
              SizedBox(height: 5),
              Txt(widget.description, style: itemDescriptionTextStyle),
            ],
          )
        ],
      ),
    );
  }

  final settingsItemStyle = (pressed) => ParentStyle()
    ..elevation(pressed ? 0 : 50, color: Colors.grey)
    ..scale(pressed ? 0.95 : 1.0)
    ..alignmentContent.center()
    ..height(70)
    ..margin(vertical: 10)
    ..borderRadius(all: 15)
    ..background.hex('#ffffff')
    ..ripple(true)
    ..animate(150, Curves.easeOut);

  final settingsItemIconStyle = (Color color) => ParentStyle()
    ..background.color(color)
    ..margin(left: 15)
    ..padding(all: 12)
    ..borderRadius(all: 30);

  final TxtStyle itemTitleTextStyle = TxtStyle()
    ..bold()
    ..fontSize(16);

  final TxtStyle itemDescriptionTextStyle = TxtStyle()
    ..textColor(Colors.black26)
    ..bold()
    ..fontSize(12);
}