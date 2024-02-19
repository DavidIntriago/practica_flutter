import 'package:buenos/controls/servicio_back/FacadeService.dart';
import 'package:flutter/material.dart';
//* Importación necesaria
import 'dart:developer';
import 'package:validators/validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext) {
    final _formkey = GlobalKey<FormState>();
    final TextEditingController nombresC = TextEditingController();
    final TextEditingController apellidosC = TextEditingController();
    final TextEditingController correoC = TextEditingController();
    final TextEditingController claveC = TextEditingController();

    void _iniciar() {
      setState(() {
        //Conexion c = Conexion();
        //c.solicitudGet("autos", false);
        FacadeService servicio = FacadeService();
        if (_formkey.currentState!.validate()) {
          Map<String, String> mapa = {
            "nombres": nombresC.text,
            "apellidos": apellidosC.text,
            "correo": correoC.text,
            "clave": claveC.text
          };
          //log(mapa.toString());
          servicio.registro(mapa).then((value) async {
            log(value.toString());
            if (value.code == 200) {
              log("registro");
              Navigator.pushNamed(context, 'home');
            } else {
              log("no registro");
            }
            print(value.code);
          });
          log('ta bien');
        } else {
          log('ta mal');
        }
      });
    }

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
              child: const Text("Registro",
                  style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.normal,
                      fontSize: 20)),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text("Registro",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 20)),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: apellidosC,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Debe ingresar sus Apellidos";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Apellidos',
                      suffixIcon: const Icon(Icons.account_tree)),
                )),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: nombresC,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Debe ingresar sus Nombres";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Nombres',
                      suffixIcon: const Icon(Icons.account_tree)),
                )),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: correoC,
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
                  controller: claveC,
                  obscureText: true,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Debe ingresar una clave";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Clave',
                      suffixIcon: const Icon(Icons.account_tree)),
                )),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Registrar'),
                onPressed: _iniciar,
              ),
            ),
            Row(
              children: <Widget>[
                const Text("Ya tienes una cuenta"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'home');
                    },
                    child: const Text(
                      'Inicio Sesion',
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
