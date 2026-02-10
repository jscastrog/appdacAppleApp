import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/c_integracion/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ControlSesion extends ChangeNotifier {
  static Credenciales? credenciales;
  static RespuestaLogin? datosusuario;

  void login(BuildContext context, String usuario, String clave) async {
    credenciales = Credenciales(username: usuario, password: clave);
    datosusuario = await ClienteLogin().autenticar(credenciales!);
    if (datosusuario!.error == null) {
      context.push('/${datosusuario!.type}');
    }
    else{
      mostrarMensajeInferior(context, 'Usuario o Clave erronea... intente de nuevo ${datosusuario!.error}');
    }

    
  }
}
