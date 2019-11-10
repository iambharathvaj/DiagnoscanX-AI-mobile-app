import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' show basename;
import 'package:async/async.dart';


void main() {
  runApp(MyAppMain());
}

class MyAppMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DiagnoscanX',
      theme: ThemeData.dark(),
      
      initialRoute: MyHomePage.id,
      routes: {
        MyHomePage.id: (context) => MyHomePage(),
        Login.id: (context) => Login(),
        PayCard.id: (context) => PayCard(),
        MyApp1.id: (context) => MyApp1(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const String id = "HOMESCREEN";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[             
              Text( 
                "DiagnoscanX - Pneumonia detector",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ), 
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[                
              Text( 
                "Pneumonia vs Normal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ), 
            ],
          ),

          Row(
           mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[             
              Text( 
                "Welcome to DiagnoscanX!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ), 
            ],
          ),



          
          SizedBox(
            height: 50.0,
          ),
          CustomButton(
            text: "Log In",
            callback: () {
              Navigator.of(context).pushNamed(Login.id);
              //Test navigation
              //Navigator.of(context).pushNamed(MyApp1.id);            
            },
          ),
          // 
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  const CustomButton({Key key, this.callback, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.blueGrey[100],
        elevation: 6.0,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: callback,
          minWidth: 200.0,
          height: 45.0,
          child: Text(text),
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  static const String id = "LOGIN";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )) as FirebaseUser;

    Navigator.of(context).pushNamed(PayCard.id);
    
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text("Pneumonia vs Normal"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset(
                  "assets/images/logo1.png",
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              hintText: "Enter Your Email...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              hintText: "Enter Your Password...",
              border: const OutlineInputBorder(),
            ),
          ),
          CustomButton(
            text: "Log In",
            callback: () async {
              await loginUser();
            },
          )
        ],
      ),
    );
  }
}


class PayCard extends StatefulWidget {
  //new
  static const String id = "PayCard";
  final FirebaseUser user;
  const PayCard({Key key, this.user}) : super(key: key);
  
  @override
  _PayCardState createState() => new _PayCardState();
}

class _PayCardState extends State<PayCard> {
  var _paymentMethodId = "";
  
 
  @override
  initState() {
    
    
    super.initState();
    StripePayment.setSettings(
      
        //StripeSettings(publishableKey: "pk_test_xxxxxxxxxxxxxxxxxxxxxx", merchantIdentifier: "merchant.rbii.stripe-example", androidProductionEnvironment: false));
        StripeSettings(publishableKey: "pk_test_yyyyyyyyyyyyyyyyyyyy", merchantIdentifier: "merchant.rbii.stripe-example", androidProductionEnvironment: false));
  
  }

 
  @override
  
  Widget build(BuildContext context) {
    
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          leading: Hero(
          tag: 'logo',
          child: Container(
            height: 40.0,
            child: Image.asset("assets/images/logo1.png"),
          ),
        ),

          title: Text("Pneumonia vs Normal"),
          actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
             
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
            
        ),

        
        body: SafeArea(child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Divider(),
            Divider(),

            Text("     Enter Payment Method To Proceed"),
            

            RaisedButton(
            
              child: Text("Add Card"),
              
              onPressed: () {
                    
                  StripePayment.addSource().then((String token) {
                  setState(() {
                    
                    _paymentMethodId = token;
                    
                  });
                });
              },
            ),

            
            Text("Current payment method ID: $_paymentMethodId"),
            Divider(),  
            Divider(),
            Divider(),           
            Text("Must enter Payment Method to Proceed"),         
            Divider(),
            Divider(),
            
             
            Divider(),
            Divider(),  
            Text("Auto Payment Amount of 20.00 USD"),
            Text("is charged when pressing > button."),

          ],
        ),
      ),

      

      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
                  //bool statusFAB = true;
                  print("PAY METHOD");
                    print(_paymentMethodId);
                  setState(() {
                    if(_paymentMethodId == "") {
                      print("paymenthod if ");
                      print(_paymentMethodId);
                      return "need payment method";
                      
                    }
                    else{
                      print("paymenthod else");
                      print(_paymentMethodId);    
                      Navigator.of(context).pushNamed(MyApp1.id); 
                      return "got card";  
                    }  
                    
                  });
                },
        tooltip: 'Enable Classification',
        child: Icon(Icons.navigate_next),
      ), 


      ),
    );
  }
}



String txt = "";
String txt1 = "Upload / take X-ray picture to classify";


class MyApp1 extends StatefulWidget {
  static const String id = "MYAPP1";

  final FirebaseUser user;
  const MyApp1({Key key, this.user}) : super(key: key);
  
  @override
  _MyApp1State createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  File img;
  TextEditingController _textFieldController = TextEditingController();


  // The fuction which will upload the image as a file
  void upload(File imageFile) async {
    var stream =
    new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    String base =
    //    "https://bearclassifier-yo7j.onrender.com";
          "https://diagnoscanx-classifier.onrender.com";

    var uri = Uri.parse(base + '/analyze');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      int l = value.length;
      txt = value;

      setState(() {});
    });
  }

 

  void image_picker(int a) async {
    txt1 = "";
    setState(() {

    });
    debugPrint("Image Picker Activated");
    if (a == 0){
      img = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 224.0, maxWidth: 224.0);
    }
    else{
      img = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 224.0, maxWidth: 224.0);
    }

    txt = "Analysing...";
    debugPrint(img.toString());
    upload(img);
    setState(() {});
  }

 
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Pneumonia vs Normal"),
        
         actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
             
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: new Container(
        child: Center(
          child: Column(
            children: <Widget>[
              img == null
                  ? new Text(
                "Upload/Take Picture To Classify X-ray",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              )
                  : new Image.file(img,
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.8),
              new Text(
                txt,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              new Text(
                "NORMAL: 0 | PNEUMONIA: 1",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),

            ],


            
          ),
        ),
      ),
      
      floatingActionButton: new Stack(
        children: <Widget>[
          Align(
              alignment: Alignment(1.0, 1.0),
              child: new FloatingActionButton(
                heroTag: 'unq1',
                onPressed: (){
                  image_picker(0);
                },
                tooltip: "Take Picture",
                child: new Icon(Icons.camera_alt),
              )
          ),
          
          Align(
              alignment: Alignment(1.0, 0.8),
              child: new FloatingActionButton(
                heroTag: 'unq2',
                
                  onPressed: (){
                    image_picker(1);
                  },
                  tooltip: "Pick Image",
                  child: new Icon(Icons.file_upload)
              )
          ),
        ],
      ),

      


      
    ));
    
  }
}