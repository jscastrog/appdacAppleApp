import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/a_presentacion/widgetspersonalizados/paneliconoinfo.dart';
import 'package:appdac/b_control/profesores.dart';
import 'package:appdac/b_control/sesion.dart';
import 'package:appdac/config/log.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdministradorScreen extends StatelessWidget {
  const AdministradorScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    ControlListaProfesores controlListaProfesores = context.watch<ControlListaProfesores>();

    final List<Map<String, dynamic>> paneles = [
      {
        'icon': Icons.person,
        'title': S.of(context).label_profesores,
        'onTap': (){
          controlListaProfesores.cargarProfesores(ControlSesion.datosusuario!.idUsuario);
          context.push('/VerProfesoresAdministrador');
        }
      },
      {
        'icon': Icons.sports,
        'title': S.of(context).label_deportes,
        'onTap': () => logear('click en la tarjeta Deportes'),
      },
      {
        'icon': Icons.menu_book,
        'title': S.of(context).label_estudiantes,
        'onTap': () => logear('click en la tarjeta Estudiantes'),
      },
      {
        'icon': Icons.timeline,
        'title': S.of(context).label_metodologos,
        'onTap': () => logear('click en la tarjeta Metodologos'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).label_perfil_administrador),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columnas
            crossAxisSpacing: 16, // Espacio horizontal
            mainAxisSpacing: 16, // Espacio vertical
            childAspectRatio: 1, // Cuadrados perfectos
          ),
          itemCount: paneles.length,
          itemBuilder: (context, index) {
            return PanelIconoInfo(
              icon: paneles[index]['icon'] as IconData,
              info: paneles[index]['title'] as String,
              cardColor: AppColors.verde,
              textColor: AppColors.blanco,
              iconColor: AppColors.blanco,
              onTap: paneles[index]['onTap'] as VoidCallback,
            );
          },
        ),
      ),
    );
  }
}
