import 'package:buenos/controls/servicio_back/RespuestaGenerica.dart';
import 'package:buenos/controls/utiles/Utiles.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Conexion {
  final String URL = "http://192.168.1.4:3000/use/";
  final String URL_MEDIA = "http://192.168.1.4:3000/images/";
  //final String URL = "http://10.20.136.53:3000/use/";
  //final String URL_MEDIA = "http://10.20.136.53:3000/images/";

  static bool NO_TOKEN = false;

  Future<RespuestaGenerica> solicitudGet(String recurso, bool token) async {
    //print(recurso);
    Map<String, String> _header = {'Content-Type': 'application/json'};
    if (token) {
      Utiles util = Utiles();
      String? tokenA = await util.getValue('token');
      _header = {
        'Content-Type': 'application/json',
        'token-key': tokenA.toString()
      };
    }
    final String _url = URL + recurso;
    final uri = Uri.parse(_url);
    try {
      final response = await http.get(uri, headers: _header);
      if (response.statusCode != 200) {
        if (response.statusCode == 400) {
          return _response(404, "Data no ecnontrada", []);
        }

        log("no hay page");
        return _response(404, "Data no ecnontrada", []);
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        //log(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['data']);
      }
    } catch (e) {
      return _response(500, "error inesperad", []);
    }
  }

  Future<RespuestaGenerica> solicitudPost(
      String recurso, bool token, Map<dynamic, dynamic> mapa) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    if (token) {
      Utiles util = Utiles();
      String? tokenA = await util.getValue('token');
      _header = {
        'Content-Type': 'application/json',
        'news-token': tokenA.toString()
      };
    }
    final String _url = URL + recurso;
    final uri = Uri.parse(_url);
    try {
      final response =
          await http.post(uri, headers: _header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 400) {
          return _response(404, "Data no ecnontrada", []);
        }

        log("no hay page");
        return _response(404, "Data no ecnontrada", []);
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        //log(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['data']);
      }
    } catch (e) {
      return _response(500, "error inesperad", []);
    }
  }

  Future<RespuestaGenerica> solicitudPut(
      String recurso, bool token, Map<dynamic, dynamic> mapa) async {
    Map<String, String> _header = {'Content-Type': 'application/json'};
    if (token) {
      Utiles util = Utiles();
      String? tokenA = await util.getValue('token');
      _header = {
        'Content-Type': 'application/json',
        'news-token': tokenA.toString()
      };
    }
    final String _url = URL + recurso;
    final uri = Uri.parse(_url);
    try {
      final response =
          await http.put(uri, headers: _header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 400) {
          return _response(404, "Data no ecnontrada", []);
        }

        log("no hay page");
        return _response(404, "Data no ecnontrada", []);
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        //log(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['data']);
      }
    } catch (e) {
      return _response(500, "error inesperad", []);
    }
  }

  RespuestaGenerica _response(int code, String msg, dynamic data) {
    var respuesta = RespuestaGenerica();
    respuesta.code = code;
    respuesta.data = data;
    respuesta.msg = msg;
    return respuesta;
  }
}
