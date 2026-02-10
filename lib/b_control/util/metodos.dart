//import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Función para abrir URL
Future<void> abrirNavegador(String url) async {
  final Uri uri = Uri.parse(url);
  
  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Abre en navegador externo
    );
  } else {
    throw 'No se pudo abrir $url';
  }
}


List<List<String>> parseCSV(String csvData) {
    final List<List<String>> datos = [];
    
    // Separar por saltos de línea
    final lineas = csvData.split('\n');
    
    for (final linea in lineas) {
      if (linea.trim().isEmpty) continue;
      
      // Separar por comas
      final columnas = linea.split(',').map((col) => col.trim()).toList();
      datos.add(columnas);
    }
    
    return datos;
  }
  
  Map<String, dynamic> parseAsistencia(String csvData) {
    final datos = parseCSV(csvData);
    
    if (datos.isEmpty) {
      return {'header': [], 'rows': []};
    }
    
    // La primera fila es el encabezado
    final header = datos.first;
    
    // Las filas siguientes son los datos
    final rows = datos.length > 1 ? datos.sublist(1) : [];
    
    return {'header': header, 'rows': rows};
  }
