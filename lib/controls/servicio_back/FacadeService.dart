import 'dart:convert';
import 'dart:math';

import 'package:buenos/controls/Conexion.dart';
import 'package:buenos/controls/servicio_back/RespuestaGenerica.dart';
import 'package:buenos/controls/servicio_back/modelo/InicioSesionSW.dart';
import 'package:http/http.dart' as http;

class FacadeService {
  Conexion c = Conexion();
  Future<InicioSesionSw> inicioSesion(Map<String, String> mapa) async {
    Map<String, String> header = {'Content-Type': 'application/json'};

    final String url = '${c.URL}admin/inicio_sesion';
    final uri = Uri.parse(url);
    InicioSesionSw isws = InicioSesionSw();
    try {
      final response =
          await http.post(uri, headers: header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 400) {
          isws.code = 404;
          isws.tag = 'Error';
          isws.msg = 'Recurso No Encontrado';
          isws.data = {};
          return isws;
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isws.code = mapa['code'];
        isws.tag = mapa['tag'];
        isws.msg = mapa['msg'];
        isws.data = mapa['data'];
        return isws;
      }
    } catch (e) {
      isws.code = 500;
      isws.tag = 'Error Interno';
      isws.msg = 'Error Inesperado';
      isws.data = {};
      return isws;
    }
    return isws;
  }

  Future<RespuestaGenerica> registro(Map<String, String> mapa) async {
    Map<String, String> header = {'Content-Type': 'application/json'};

    final String url = '${c.URL}admin/usuarioC/save';

    final uri = Uri.parse(url);
    RespuestaGenerica isws = RespuestaGenerica();
    print(mapa);
    print(uri);
    try {
      print("entra try");
      final response =
          await http.post(uri, headers: header, body: jsonEncode(mapa));
      print("medio tryu");
      if (response.statusCode != 200) {
        if (response.statusCode == 400) {
          isws.code = 404;
          isws.msg = 'Recurso No Encontrado';
          isws.data = {};
          return isws;
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isws.code = mapa['code'];
        isws.msg = mapa['msg'];
        isws.data = mapa['data'];
        return isws;
      }
    } catch (e) {
      isws.code = 500;
      isws.msg = 'Error Inesperado';
      isws.data = {};
      return isws;
    }
    return isws;
  }

  Future<RespuestaGenerica> listarAutos() async {
    return await c.solicitudGet('admin/noticias', false);
  }

  Future<RespuestaGenerica> obtenerNoticia(dynamic external) async {
    return await c.solicitudGet('admin/noticia/$external', false);
  }

  Future<RespuestaGenerica> listarComentarios() async {
    return await c.solicitudGet('admin/comentarios', false);
  }

  Future<RespuestaGenerica> obtenerComentarios(dynamic external) async {
    return await c.solicitudGet('admin/comentario/$external', false);
  }

  Future<RespuestaGenerica> guardarComentario(Map<String, String> mapa) async {
    return await c.solicitudPost('admin/comentarios/save', false, mapa);
  }

  Future<RespuestaGenerica> validarRol() async {
    return await c.solicitudGet('/admin/validarRol', true);
  }

  Future<RespuestaGenerica> obtenerComentario(dynamic external) async {
    return await c.solicitudGet('/admin/comentario/$external', false);
  }

  Future<RespuestaGenerica> obtenerUsuario(dynamic external) async {
    return await c.solicitudGet('/admin/usuario/$external', false);
  }

  Future<RespuestaGenerica> obtenerComentariosUsuario(dynamic external) async {
    return await c.solicitudGet('/admin/comentarioUsuario/$external', false);
  }

  Future<RespuestaGenerica> actualizarDatos(
      dynamic external, Map<String, String> mapa) async {
    return await c.solicitudPut('admin/persona/update/$external', false, mapa);
  }

  Future<RespuestaGenerica> actualizarComentario(
      dynamic external, Map<String, String> mapa) async {
    return await c.solicitudPut(
        'admin/comentario/update/$external', false, mapa);
  }

  Future<RespuestaGenerica> banear(
      dynamic external, Map<String, String> mapa) async {
    return await c.solicitudPut('admin/persona/baneo/$external', false, mapa);
  }
}
