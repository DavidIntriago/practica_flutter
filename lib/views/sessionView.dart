import 'package:buenos/controls/servicio_back/FacadeService.dart';
import 'package:flutter/material.dart';
//* Importación necesaria
import 'dart:developer';
import 'package:validators/validators.dart';
import 'package:buenos/controls/utiles/Utiles.dart';

class SesionView extends StatefulWidget {
  const SesionView({Key? key}) : super(key: key);

  @override
  _SesionViewState createState() => _SesionViewState();
}

class _SesionViewState extends State<SesionView> {
  //? Formkey para el formulario. privada _
  final _formkey = GlobalKey<FormState>();

  //* variables para validacion
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();

  void _iniciar() {
    setState(() {
      //Conexion c = Conexion();
      //c.solicitudGet("autos", false);
      FacadeService servicio = FacadeService();
      if (_formkey.currentState!.validate()) {
        Map<String, String> mapa = {
          "correo": correoControl.text,
          "clave": claveControl.text
        };
        servicio.inicioSesion(mapa).then((value) async {
          if (value.code == 200) {
            print('aqui');
            Utiles util = Utiles();
            util.saveValue('external_usuario', value.data['external_id']);

            util.saveValue('token', value.data['token']);
            servicio.validarRol().then((mapa) async {
              if (mapa.code == 200) {
                print('aqui');
                print(mapa);
                util.saveValue("admin", "admin");
                final SnackBar msg =
                    SnackBar(content: Text('Bienvenido ${value.data['user']}'));
                ScaffoldMessenger.of(context).showSnackBar(msg);
                Navigator.pushReplacementNamed(context, 'menuAdmin');
                print('es admin');
              } else {
                final SnackBar msg =
                    SnackBar(content: Text('Bienvenido ${value.data['user']}'));
                ScaffoldMessenger.of(context).showSnackBar(msg);
                Navigator.pushReplacementNamed(context, 'noticias');
                print('es usuario');
              }
            });
          } else {
            final SnackBar msg = SnackBar(content: Text('Error ${value.code}'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }
        });
      } else {
        log('ta mal');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey, //* Asignación del key
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text("Notici NUevas",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text("App de noticias",
                  style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.normal,
                      fontSize: 20)),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text("Inicio de sesion",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 20)),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: correoControl,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Debe ingresar su correo";
                    }
                    if (!isEmail(value.toString())) {
                      return "Debe ser un correo valido";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Correo',
                      suffixIcon: const Icon(Icons.alternate_email)),
                )),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: claveControl,
                  obscureText: true,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Debe ingresar una clave";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Clave', suffixIcon: const Icon(Icons.key)),
                )),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Inicio'),
                onPressed: _iniciar,
              ),
            ),
            Row(
              children: <Widget>[
                const Text("No tienes una cuenta"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'register');
                    },
                    child: const Text(
                      'Registrate',
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
