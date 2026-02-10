import 'package:appdac/c_integracion/profesores.dart';
import 'package:flutter/material.dart';

class ProfesorCard extends StatelessWidget {
  final IconData icon;
  final Profesor profesor;
  final ValueChanged<bool>? onActivoChanged;

  const ProfesorCard({
    required this.icon,
    required this.profesor,
    this.onActivoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Columna izquierda: Icono
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),

            // Columna central: Nombre y ID
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profesor.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${profesor.idProfesor}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                 
                ],
              ),
            ),

            // Columna derecha: Checkbox "Activo"
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: profesor.activo,
                      onChanged: onActivoChanged != null
                          ? (value) {
                              if (value != null) {
                                onActivoChanged!(value);
                              }
                            }
                          : null,
                    ),
                    const Text('Activo'),
                  ],
                ),
                const SizedBox(height: 8),
                // Información adicional
                /*Row(
                  children: [
                    Icon(Icons.email, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 100,
                      child: Text(
                        profesor.email,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
