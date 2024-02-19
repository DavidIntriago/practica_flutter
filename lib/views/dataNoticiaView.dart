import 'package:buenos/controls/Conexion.dart';
import 'package:buenos/controls/servicio_back/FacadeService.dart';
import 'package:buenos/controls/utiles/Utiles.dart';
import 'package:buenos/views/exception/confirmacion.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DataNoticiaView extends StatefulWidget {
  const DataNoticiaView({Key? key}) : super(key: key);

  @override
  _DataNoticiaViewState createState() => _DataNoticiaViewState();
}

class _DataNoticiaViewState extends State<DataNoticiaView> {
  Map<String, dynamic> noticia = {};
  List<dynamic> comentarios = [];
  Map<String, dynamic> persona = {};

  Map<String, dynamic> usuario = {};

  final TextEditingController comentarioController = TextEditingController();
  bool mostrarComentarios = false;
  bool perteneceComentario = false;
  dynamic admin = '';

  @override
  void initState() {
    super.initState();
    cargarNoticia();
    obtenerUsuario();
  }

  _obtenerUbi() async {
    LocationPermission permisos;
    permisos = await Geolocator.checkPermission();
    if (permisos == LocationPermission.denied) {
      permisos = await Geolocator.requestPermission();
      if (permisos == LocationPermission.denied) {
        permisos = await Geolocator.requestPermission();
        print("debe darle autorizacion");
      } else {
        _mostrarPanelComentario();
      }
    } else {
      _mostrarPanelComentario();
    }
  }

  void _modificarComentario() async {
    Position posicion = await Geolocator.getCurrentPosition();
    Utiles util = Utiles();
    final coment = await util.getValue("external_comentario");
    Map<String, String> mapa = {
      "cuerpo": comentarioController.text,
      "latitud": posicion.latitude.toString(),
      "longitud": posicion.longitude.toString()
    };
    FacadeService facadeService = FacadeService();
    facadeService.actualizarComentario(coment, mapa).then((value) {
      if (value.code == 200) {
        print("actualizo");
        final SnackBar msg =
            SnackBar(content: Text('El comentario se actualizo con Exito'));
        ScaffoldMessenger.of(context).showSnackBar(msg);
        cargarNoticia();
      } else {
        print("no actualizo");
      }
    });
  }

  void _guardarComentario() async {
    Position posicion = await Geolocator.getCurrentPosition();
    Utiles util = Utiles();
    final noticia = await util.getValue("external_noticia");
    final usuario = await util.getValue("external_usuario");
    print(noticia);
    print(usuario);

    Map<String, String> mapa = {
      "cuerpo": comentarioController.text,
      "id_persona": usuario.toString(),
      "id_noticia": noticia.toString(),
      "latitud": posicion.latitude.toString(),
      "longitud": posicion.longitude.toString()
    };
    print(mapa);
    FacadeService facadeService = FacadeService();
    facadeService.guardarComentario(mapa).then((value) async {
      if (value.code == 200) {
        final SnackBar msg =
            SnackBar(content: Text('EL comentario se guardo con exito'));
        ScaffoldMessenger.of(context).showSnackBar(msg);
        cargarNoticia();
        print("registro");
      } else {
        print("no registro");
      }
      print(value.code);
    });
  }

  void obtenerUsuario() async {
    Utiles util = Utiles();
    final external = await util.getValue("external_usuario");
    print(external);
    FacadeService facadeService = FacadeService();
    facadeService.obtenerUsuario(external).then((value) {
      usuario = value.data;
    });
  }

  void cargarNoticia() async {
    Utiles util = Utiles();
    final external = await util.getValue("external_noticia");
    final check = await util.getValue("admin");
    print(external);
    FacadeService facadeService = FacadeService();
    facadeService.obtenerNoticia(external).then((value) {
      setState(() {
        noticia = value.data;
        persona = noticia['persona'];
        admin = check.toString();
      });
      print(noticia['persona']);
      print(admin);
    });
    facadeService.obtenerComentarios(external).then((value) {
      setState(() {
        comentarios = value.data;
      });
      print(comentarios);
    });
  }

  void _banear(dynamic external) async {
    print("externakl");
    print(external);
    Map<String, String> mapa = {
      "estado": "false",
    };
    print(mapa);
    FacadeService facadeService = FacadeService();
    facadeService.banear(external, mapa).then((value) async {
      print(value.msg.toString());
      if (value.code == 200) {
        print("baneado");
      } else {
        print("no baneado");
      }
      print(value.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    Conexion conexion = Conexion();
    final url = conexion.URL_MEDIA;
    final imagenUrl = '${url}${noticia['foto']}';
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Noticia'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  noticia['titulo'] ?? 'Sin título',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imagenUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Fecha: ${noticia['fecha'] ?? 'Sin fecha'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '${noticia['cuerpo'] ?? 'Sin cuerpo'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Autor: ${persona['nombres'] ?? 'Sin nombre'} ${persona['apellidos'] ?? 'Sin apellido'}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                mostrarComentarios = !mostrarComentarios;
              });
            },
            child: Text(mostrarComentarios
                ? 'Ocultar Comentarios'
                : 'Mostrar Comentarios'),
          ),
          Divider(),
          if (mostrarComentarios)
            Expanded(
              child: ListView.builder(
                itemCount: comentarios.length,
                itemBuilder: (context, index) {
                  final comentario = comentarios[index];
                  var isauth = perteneceComentario;
                  if (comentario['persona']['nombres'] == usuario['nombres']) {
                    isauth = true;
                  }
                  return ListTile(
                    title: Text(comentario['persona']['nombres']),
                    subtitle: Text(comentario['cuerpo']),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String choice) {
                        if (choice == 'banear') {
                          print("hfdskjfjksdfsd");
                          print(comentario['persona']['external_id']);
                          _banear(comentario['persona']['external_id']);
                          cargarNoticia();
                        } else if (choice == 'editar') {
                          comentarioController.text = comentario['cuerpo'];
                          Utiles util = Utiles();
                          util.saveValue(
                              "external_comentario", comentario['external_id']);
                          _editarComentario();
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        List<PopupMenuEntry<String>> items = [];

                        // Verificar si el comentario pertenece al usuario actual
                        // y agregar la opción "Editar"
                        if (isauth) {
                          items.add(
                            PopupMenuItem<String>(
                              value: 'editar',
                              child: Text('Editar'),
                            ),
                          );
                        }
                        ;
                        print(admin);
                        if (admin != "null") {
                          items.add(
                            PopupMenuItem<String>(
                              value: 'banear',
                              child: Text('Banear'),
                            ),
                          );
                        }

                        return items;
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: mostrarComentarios
          ? FloatingActionButton(
              onPressed: () {
                _obtenerUbi();
              },
              tooltip: 'Agregar Comentario',
              child: const Icon(Icons.comment),
            )
          : null,
    );
  }

  void _editarComentario() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: comentarioController,
                    decoration: InputDecoration(
                      labelText: 'Editar Comentario',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      mostrarDialogoConfirmacion(context, 'Guardar Cambios',
                          'Desea actualizar el Comentario', () {
                        _modificarComentario();
                        Navigator.pop(context);
                      });
                    },
                    child: Text('Guardar Cambios'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

  void _mostrarPanelComentario() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: comentarioController,
                    decoration: InputDecoration(
                      labelText: 'Nuevo Comentario',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _guardarComentario();
                      Navigator.pop(context); // Cierra el bottom sheet
                    },
                    child: Text('Guardar Comentario'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
