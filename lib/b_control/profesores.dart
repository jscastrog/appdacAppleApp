import 'package:appdac/c_integracion/profesores.dart';
import 'package:flutter/material.dart';

class ControlListaProfesores extends ChangeNotifier {
  List<Profesor> profesores = [];

  void cargarProfesores(String idAdministrador) async {
    profesores.clear();
    RespuestaProfesores rprofesores= await ClienteProfesores().consultarProfesores(idAdministrador);
    for (Profesor profesor in rprofesores.profesores!) {
      profesores.add(profesor);
    }
    notifyListeners();
  }
}
