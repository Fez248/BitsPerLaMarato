import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Importa el paquete de la cámara
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';


class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Foto de la compresaS'),
      ),
      body: Stack(
        children: <Widget> [
            FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                        // Si la inicialización está completa, muestra la vista previa de la cámara
                        return CameraPreview(_controller);
                    } else {
                        // Muestra un indicador de carga mientras espera la inicialización
                        return Center(child: CircularProgressIndicator());
                    }
                },
            ),
            Positioned.fill(
                child: Center(
                    child: Container(
                        width: screenSize.width * 0.5,
                        height: screenSize.height * 0.5,
                        margin: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                    )
                )
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          try {
            // Asegúrate de esperar la inicialización antes de intentar tomar una foto
            await _initializeControllerFuture;

            // Captura la foto
            final XFile file = await _controller.takePicture();

            // Navega a la pantalla de vista previa de la imagen después de tomar la foto
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: file.path),
              ),
            );
          } catch (e) {
            print("Error al tomar la foto: $e");
          }
        },
      ),
      // Centra el botón de la cámara
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// Widget para mostrar la imagen después de tomarla
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  Future<void> _processImage(String imageUrl) async//sirve para llamar al script de python
  {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('on_request_example');

    try {
        FirebaseAuth auth = FirebaseAuth.instance;
        User? user = auth.currentUser;

        if (user != null)
        { 
          String? token = await user.getIdToken();
          final HttpsCallableResult result = await callable.call(<String, dynamic>{'Authorization': 'Bearer $token'});
          // final HttpsCallableResult result = await callable.call({
          //     imageUrl: imagePath, //se le puede pasar informacion extra como el tamaño del overlay
          //     //width: screenSize.width * 0.5,
          //     //height: screenSize.height * 0.5,
          // }, <String, dynamic> {'Authorization': 'Bearer $token'});
          print('Resultado de la Cloud Function: ${result.data}');
        }

    } catch (e) {
        print('Error al invocar la Cloud Function: $e');
    }
  }

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Foto')),
      body: Column(
        children: [
          Image.file(File(imagePath)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _processImage(imagePath),
        child: Icon(Icons.save),
      ),
    );
  }
}


// class camera extends StatefulWidget {
//     const camera({super.key, required this.title}); //constructora

//     final String title;

//     @override
//     State<camera> createState() => _camera();
// }

// class _camera extends State<camera> {
//     //aquí van variables que necesite y funciones auxiliares
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;

//     @override
//     Widget build(BuildContext context)
//     {

//     }
// }