import 'package:buenos/controls/Conexion.dart';
import 'package:buenos/controls/servicio_back/FacadeService.dart';
import 'package:buenos/controls/utiles/Utiles.dart';
import 'package:buenos/views/perfil.dart';
import 'package:flutter/material.dart';

class NoticiasView extends StatefulWidget {
  const NoticiasView({Key? key}) : super(key: key);

  @override
  _NoticiasViewState createState() => _NoticiasViewState();
}

class _NoticiasViewState extends State<NoticiasView> {
  List<dynamic> noticias = [];
  List<dynamic> comentarios = [];

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    ListarNoticias();
    _listarComentarios();
  }

  void ListarNoticias() {
    FacadeService facadeService = FacadeService();
    facadeService.listarAutos().then((value) {
      setState(() {
        noticias = value.data; // Almacena las noticias en la lista
      });
    });
  }

  void _listarComentarios() async {
    Utiles utiles = Utiles();
    final external = await utiles.getValue("external_usuario");
    FacadeService facadeService = FacadeService();
    facadeService.obtenerComentariosUsuario(external).then((value) {
      setState(() {
        comentarios = value.data;
      });
      print(comentarios);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            if (index == 0) {
              ListarNoticias();
            } else if (index == 1) {
              _listarComentarios();
            }
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.newspaper),
            icon: Icon(Icons.newspaper_outlined),
            label: 'Noticias',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.history)),
            label: 'Actividad',
          ),
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.account_circle_sharp),
            ),
            label: 'Perfil',
          ),
        ],
      ),
      body: <Widget>[
        ///
        ListView.builder(
          itemCount: noticias.length,
          itemBuilder: (context, index) {
            Conexion conexion = Conexion();
            final url = conexion.URL_MEDIA;
            final noticia = noticias[index];
            final imagenUrl = '${url}${noticia['foto']}';

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
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imagenUrl,
                          fit: BoxFit.cover,
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
                        subtitle: Text(noticia['cuerpo']),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        Scaffold(
          appBar: AppBar(
            title: Text('Comentarios'),
          ),
          body: ListView.builder(
            itemCount: comentarios.length,
            itemBuilder: (context, index) {
              final comentario = comentarios[index];

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(comentario['cuerpo']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha: ${comentario['fecha']}'),
                      Text('Usuario: ${comentario['persona']['nombres']}'),
                      Text('Noticia: ${comentario['noticia']['titulo']}'),
                    ],
                  ),
                  onTap: () {
                    Utiles util = Utiles();
                    print(comentario['noticia']['external_id']);
                    util.saveValue("external_noticia",
                        comentario['noticia']['external_id']);

                    Navigator.pushNamed(context, 'noticia_info');
                  },
                ),
              );
            },
          ),
        ),

        PerfilWidget(),
      ][currentPageIndex],
    );
  }
}
