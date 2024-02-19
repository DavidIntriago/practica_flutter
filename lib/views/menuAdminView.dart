import 'package:buenos/controls/Conexion.dart';
import 'package:buenos/controls/servicio_back/FacadeService.dart';
import 'package:buenos/controls/utiles/Utiles.dart';
import 'package:flutter/material.dart';
import 'package:buenos/views/sessionView.dart';

class MenuAdminView extends StatefulWidget {
  const MenuAdminView({Key? key}) : super(key: key);

  @override
  _MenuAdminViewState createState() => _MenuAdminViewState();
}

class _MenuAdminViewState extends State<MenuAdminView> {
  List<dynamic> noticias = []; // Lista para almacenar las noticias
  Map<String, dynamic> admin = {};
  @override
  void initState() {
    super.initState();
    ListarNoticias();
    _cargarDatos();
  }

  void ListarNoticias() {
    FacadeService facadeService = FacadeService();
    facadeService.listarAutos().then((value) {
      setState(() {
        noticias = value.data;
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
        admin = value.data;
      });
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias'),
      ),
      drawer: Drawer(
        // Menú lateral
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                '${admin['nombres']} ${admin['apellidos']}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle_sharp),
              title: Text(
                'Perfil',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'perfil');
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                'Mapa',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                // Agrega el código para la acción de la opción 2
                Navigator.pushNamed(context, 'mapa');
                // Cierra el menú lateral
              },
            ),
            ListTile(
              leading: Icon(Icons.newspaper),
              title: Text(
                'Noticias',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                // Agrega el código para la acción de la opción 3
                Navigator.pop(context); // Cierra el menú lateral
              },
            ),
            Expanded(child: Container()),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Salir',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context); // Cierra el menú lateral
                Utiles util = Utiles();
                util.removeAllItem();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SesionView(),
                ));
              },
            ), // Espaciador para expandir y empujar "Exit" al final
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: noticias.length,
        itemBuilder: (context, index) {
          Conexion conexion = Conexion();
          final url = conexion.URL_MEDIA;
          final noticia = noticias[index];
          final imagenUrl =
              '${url}${noticia['foto']}'; // Ajusta la URL según tu configuración
          print(imagenUrl);
          final cuerpoNoticia = noticia['cuerpo'].length > 50
              ? noticia['cuerpo'].substring(0, 60) + '...'
              : noticia['cuerpo'];

          return Card(
            elevation: 2.0,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Utiles util = Utiles();
                util.saveValue("external_noticia", noticia['external_id']);
                print(noticia['external_id']);
                Navigator.pushNamed(context, 'noticia_info');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio:
                        16 / 9, // Establecer la relación de aspecto deseada
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        imagenUrl,
                        fit: BoxFit
                            .cover, // Ajustar la imagen para cubrir completamente el contenedor
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        noticia['titulo'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(cuerpoNoticia),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Utiles util = Utiles();
                          util.saveValue(
                              "external_noticia", noticia['external_id']);
                          print(noticia['external_id']);
                          Navigator.pushNamed(context, 'mapa');
                        },
                        child: Text('Mapa'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
