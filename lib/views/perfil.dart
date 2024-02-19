import 'package:buenos/controls/servicio_back/FacadeService.dart';
import 'package:buenos/controls/utiles/Utiles.dart';
import 'package:buenos/views/exception/confirmacion.dart';
import 'package:flutter/material.dart';

class PerfilWidget extends StatefulWidget {
  const PerfilWidget({Key? key}) : super(key: key);

  @override
  _PerfilWidgetState createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  TextEditingController _nombresController = TextEditingController();
  TextEditingController _apellidosController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _celularController = TextEditingController();
  TextEditingController _fechaNacimientoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _actualizarDatos() async {
    Utiles utiles = Utiles();
    final external = await utiles.getValue("external_usuario");

    setState(() {
      FacadeService servicio = FacadeService();
      Map<String, String> mapa = {
        "nombres": _nombresController.text,
        "apellidos": _apellidosController.text,
        "direccion": _direccionController.text,
        "celular": _celularController.text,
        "fecha_nac": _fechaNacimientoController.text
      };
      servicio.actualizarDatos(external, mapa).then((value) async {
        if (value.code == 200) {
          final SnackBar msg = SnackBar(
              content: Text(
                  'Los datos de  ${value.data['nombres']} han sido actualizados con exito'));
          ScaffoldMessenger.of(context).showSnackBar(msg);
          Navigator.pushReplacementNamed(context, 'noticias');
          print("actualizo");
        } else {
          final SnackBar msg = SnackBar(
              content: Text(
                  'Los datos de  ${value.data['nombres']} no se han podido actualizar'));
          ScaffoldMessenger.of(context).showSnackBar(msg);
          Navigator.pushReplacementNamed(context, 'noticias');
          print("no actualzio");
        }
        print(value.code);
      });
    });
  }

  void _cargarDatos() async {
    Utiles utiles = Utiles();
    final external = await utiles.getValue("external_usuario");
    print(external);
    FacadeService facadeService = FacadeService();
    facadeService.obtenerUsuario(external).then((value) {
      setState(() {
        _nombresController.text =
            (value.data['nombres'] == null || value.data['nombres'] == "NONE")
                ? ''
                : value.data['nombres'];
        _apellidosController.text = (value.data['apellidos'] == null ||
                value.data['apellidos'] == "NONE")
            ? ''
            : value.data['apellidos'];
        _direccionController.text = (value.data['direccion'] == null ||
                value.data['direccion'] == "NONE")
            ? ''
            : value.data['direccion'];
        _celularController.text =
            (value.data['celular'] == null || value.data['celular'] == "NONE")
                ? ''
                : value.data['celular'];
        _fechaNacimientoController.text = (value.data['fecha_nac'] == null ||
                value.data['fecha_nac'] == "NONE")
            ? ''
            : value.data['fecha_nac'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              mostrarDialogoConfirmacion(
                context,
                'Cerrar Sesión',
                'Desea Salir?',
                () {
                  Utiles utiles = Utiles();
                  utiles.removeAllItem();
                  Navigator.pushNamed(context, 'home');
                },
              );
            },
          ),
        ],
      ),
      body: ListView(padding: EdgeInsets.all(16.0), children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nombresController,
              decoration: InputDecoration(labelText: 'Nombres'),
            ),
            TextFormField(
              controller: _apellidosController,
              decoration: InputDecoration(labelText: 'Apellidos'),
            ),
            TextFormField(
              controller: _direccionController,
              decoration: InputDecoration(labelText: 'Dirección'),
            ),
            TextFormField(
              controller: _celularController,
              decoration: InputDecoration(labelText: 'Celular'),
            ),
            TextFormField(
              controller: _fechaNacimientoController,
              decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                mostrarDialogoConfirmacion(
                    context, 'Guardar Cambios', 'Desea actualizar Datos', () {
                  _actualizarDatos();
                });
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ]),
    );
  }

  void mostrarDialogoConfirmacion(
    BuildContext context,
    String titulo,
    String mensaje,
    VoidCallback onAceptar,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmacionDialog(
          titulo: titulo,
          mensaje: mensaje,
          onAceptar: onAceptar,
        );
      },
    );
  }
}
