import 'package:buenos/controls/servicio_back/FacadeService.dart';
import 'package:buenos/controls/utiles/Utiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaView extends StatefulWidget {
  const MapaView({Key? key}) : super(key: key);

  @override
  _MapaViewState createState() => _MapaViewState();
}

class _MapaViewState extends State<MapaView> {
  List<LatLng> puntos = [];
  List<dynamic> comentarios = [];

  @override
  void initState() {
    super.initState();
    _obtenerPuntos();
  }

  void _obtenerPuntos() async {
    try {
      Utiles utiles = Utiles();
      var external = await utiles.getValue("external_noticia");
      print(external);
      FacadeService facadeService = FacadeService();
      if (external == null) {
        facadeService.listarComentarios().then((value) {
          setState(() {
            comentarios = value.data;
            print(value.data);
          });
          print('2guarda');
          print(comentarios);
          for (var comentario in comentarios) {
            if (comentario['latitud'] != null &&
                comentario['longitud'] != null) {
              puntos.add(LatLng(comentario['latitud'], comentario['longitud']));
            }
          }
          print(puntos);
        });
      } else {
        facadeService.obtenerComentario(external).then((value) {
          setState(() {
            comentarios = value.data;
          });
          print('2guarda');
          print(comentarios);
          for (var comentario in comentarios) {
            if (comentario['latitud'] != null &&
                comentario['longitud'] != null) {
              puntos.add(LatLng(comentario['latitud'], comentario['longitud']));
            }
          }
          print(puntos);
        });
      }
    } catch (e) {
      print('Error al obtener la posición: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SOY EL MAPA'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Utiles util = Utiles();
            util.removeItem("external_noticia");
            print("object");
            Navigator.pop(context); // Ejemplo: regresar a la pantalla anterior
          },
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(-4.02, -79.1982),
          minZoom: 5,
          maxZoom: 25,
          zoom: 18,
        ),
        nonRotatedChildren: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            additionalOptions: const {
              'attribution':
                  '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            },
          ),
          MarkerLayer(
            markers: puntos.map((punto) {
              // Obtener el comentario correspondiente al punto
              var comentario = comentarios[puntos.indexOf(punto)];

              return Marker(
                point: punto,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      // Mostrar un panel con el usuario y la fecha del comentario
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Comentario'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    'Usuario: ${comentario["persona"]['nombres']} ${comentario["persona"]['apellidos']}'),

                                Text('Fecha: ${comentario["fecha"]}'),
                                // Agrega más información según sea necesario
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cerrar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      child: const Icon(
                        Icons.person_pin,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
