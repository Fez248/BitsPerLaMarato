import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: CameraScreen(),
    );
  }
}



class CameraScreen extends StatefulWidget {

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
 late CameraController _controller;
 Future<void>? _initializeControllerFuture;
  

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    //càmera posterior
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build (BuildContext){
    return Scaffold(
      appBar: AppBar(
        title: Text("càmera amb overlay")
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return Stack(
              children: [
                CameraPreview(_controller),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Tu overlay aquí',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ]
            );
          } 
          else {
            // Si la inicialización aún no ha terminado, muestra un indicador de carga
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        )
    );
  }   
}

/*
class Overlay extends StatefulWidget{
  
  Widget build(BuildContext context ){
  double deviceWidth = MediaQuery.of(context).size.width;
  double deviceHeight = MediaQuery.of(context).size.height;
  }


  @override
  State<Overlay> createState() => _OverlayState();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Rectángulo con bordes
        Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // Color del borde
              width: 2.0, // Ancho del borde
            ),
          ),
          child: Center(
            child: Text(
              'Mi Rectángulo',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}


class _OverlayState extends State<Overlay>{

  @override

} */

