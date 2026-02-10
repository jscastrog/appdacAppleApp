import 'dart:convert';
import 'dart:io';
import 'package:appdac/config/app_config.dart';
import 'package:appdac/config/log.dart';
import 'package:http/http.dart' as http;

class DeporteEstudiante {
  final String idDeporte;
  final String nombreDeporte;

  DeporteEstudiante({
    required this.idDeporte,
    required this.nombreDeporte,
  });

  factory DeporteEstudiante.fromJson(Map<String, dynamic> json) {
    return DeporteEstudiante(
      idDeporte: json['id_deporte'] ?? '',
      nombreDeporte: json['nombre_deporte'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_deporte': idDeporte,
        'nombre_deporte': nombreDeporte,
      };

  @override
  String toString() {
    return 'Deporte{id: $idDeporte, nombre: $nombreDeporte}';
  }
}

class ConsultaDeportesRequest {
  final String idEstudiante;

  ConsultaDeportesRequest({
    required this.idEstudiante,
  });

  Map<String, dynamic> toJson() => {
        "id_estudiante": idEstudiante,
      };
}

class RespuestaDeportesEstudiante {
  final bool exitoso;
  final List<DeporteEstudiante>? deportes;
  final String? mensaje;
  final int? statusCode;

  RespuestaDeportesEstudiante({
    required this.exitoso,
    this.deportes,
    this.mensaje,
    this.statusCode,
  });

  factory RespuestaDeportesEstudiante.exitoso(List<DeporteEstudiante> deportes) {
    return RespuestaDeportesEstudiante(
      exitoso: true,
      deportes: deportes,
    );
  }

  factory RespuestaDeportesEstudiante.error({String? mensaje, int? statusCode}) {
    return RespuestaDeportesEstudiante(
      exitoso: false,
      mensaje: mensaje ?? 'Error al consultar deportes del estudiante',
      statusCode: statusCode,
      deportes: null,
    );
  }
}

//******************************************************************************************************** */
// deporte_model.dart
class Deporte {
  final String nombreDeporte;
  final bool existe;

  Deporte({
    required this.nombreDeporte,
    required this.existe,
  });

  factory Deporte.fromJson(Map<String, dynamic> json) {
    return Deporte(
      nombreDeporte: json['nombre_deporte'],
      existe: json['existe'],
    );
  }
}

class DeportesResponse {
  final bool ok;
  final List<Deporte> deportes;
  final int total;

  DeportesResponse({
    required this.ok,
    required this.deportes,
    required this.total,
  });

  factory DeportesResponse.fromJson(Map<String, dynamic> json) {
    var deportesList = json['deportes'] as List;
    List<Deporte> deportes = deportesList.map((deporteJson) => Deporte.fromJson(deporteJson)).toList();

    return DeportesResponse(
      ok: json['ok'],
      deportes: deportes,
      total: json['total'],
    );
  }
}

//************************************************************************************
// actualizacion_estudiante_model.dart
class ActualizacionEstudianteRequest {
  final String tipo;
  final String idEstudiante;
  final List<Deporte> deportes;

  ActualizacionEstudianteRequest({
    required this.tipo,
    required this.idEstudiante,
    required this.deportes,
  });

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'id_estudiante': idEstudiante,
      'deportes': deportes
          .map((deporte) => {
                'nombre_deporte': deporte.nombreDeporte,
                'existe': deporte.existe,
              })
          .toList(),
    };
  }
}

//************************************************************************************************************************ */

class ClienteEstudiantes {
  Future<RespuestaDeportesEstudiante> consultarDeportes(String idEstudiante) async {
    try {
      final request = ConsultaDeportesRequest(
        idEstudiante: idEstudiante,
      );

      final String urlVerEstudianteDeportes = AppConfig.instance.parametros['urlverDeportesEstudiante'];

      final respuesta = await http.post(
        Uri.parse(urlVerEstudianteDeportes),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      return _procesarRespuesta(respuesta);
    } catch (e) {
      // Error de conexión u otro error
      return RespuestaDeportesEstudiante.error(
        mensaje: 'Error de conexión: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  RespuestaDeportesEstudiante _procesarRespuesta(http.Response respuesta) {
    try {
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        final dynamic datos = jsonDecode(respuesta.body);

        if (datos is List) {
          final deportes = datos.map<DeporteEstudiante>((json) {
            return DeporteEstudiante.fromJson(json);
          }).toList();

          return RespuestaDeportesEstudiante.exitoso(deportes);
        } else {
          return RespuestaDeportesEstudiante.error(
            mensaje: 'Formato de respuesta inválido',
            statusCode: respuesta.statusCode,
          );
        }
      } else if (respuesta.statusCode == 401) {
        return RespuestaDeportesEstudiante.error(
          mensaje: 'No autorizado. Verifique sus credenciales',
          statusCode: respuesta.statusCode,
        );
      } else if (respuesta.statusCode >= 400 && respuesta.statusCode < 500) {
        return RespuestaDeportesEstudiante.error(
          mensaje: 'Error en la solicitud (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      } else if (respuesta.statusCode >= 500) {
        return RespuestaDeportesEstudiante.error(
          mensaje: 'Error del servidor (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      } else {
        return RespuestaDeportesEstudiante.error(
          mensaje: 'Error desconocido (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      }
    } catch (e) {
      return RespuestaDeportesEstudiante.error(
        mensaje: 'Error procesando respuesta: ${e.toString()}',
        statusCode: respuesta.statusCode,
      );
    }
  }

  /// Método para enviar documentación PDF de un estudiante
  /// [idestudiante]: ID del estudiante (String)
  /// [documento]: Archivo PDF a subir (File)
  /// Retorna un Future<Map<String, dynamic>> con la respuesta del servidor

  static Future<Map<String, dynamic>> enviarDocumentacion(String idestudiante, File documento, File eps, File consentimiento) async {
    try {
      // Validar que el archivo sea PDF
      if (!_esArchivoPDF(documento) || !_esArchivoPDF(eps) || !_esArchivoPDF(consentimiento)) {
        return {'success': false, 'error': 'El archivo debe ser un PDF (.pdf)', 'actualizado': 'ERROR', 'mensaje': 'Solo se permiten archivos PDF'};
      }

      List<int> pdfBytesDocumento = await documento.readAsBytes();
      String pdfBase64Documento = base64Encode(pdfBytesDocumento);

      List<int> pdfBytesEps = await eps.readAsBytes();
      String pdfBase64Eps = base64Encode(pdfBytesEps);

      List<int> pdfBytesConsentimiento = await consentimiento.readAsBytes();
      String pdfBase64Consentimiento = base64Encode(pdfBytesConsentimiento);

      // 3. Crear el cuerpo JSON según especificaciones
      Map<String, dynamic> requestBody = {
        'idestudiante': idestudiante,
        'documento': pdfBase64Documento,
        'eps': pdfBase64Eps,
        'consentimiento': pdfBase64Consentimiento,
      };

      print("************************************************");
      print(json.encode(requestBody));
      print("************************************************");

      final String endpointUrl = AppConfig.instance.parametros['urlestudianteEnviarDocumentos'];

      final response = await http.post(
        Uri.parse(endpointUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // 5. Procesar la respuesta
      print('Código de respuesta: ${response.statusCode}');
      print('Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          Map<String, dynamic> jsonResponse = json.decode(response.body);

          return {
            'success': true,
            'actualizado': jsonResponse['actualizado'] ?? 'OK',
            'mensaje': jsonResponse['mensaje'] ?? 'Documento actualizado exitosamente',
            'statusCode': response.statusCode,
            'responseData': jsonResponse,
          };
        } catch (e) {
          // Si no se puede parsear como JSON
          return {
            'success': false,
            'error': 'Error al procesar respuesta del servidor: $e',
            'statusCode': response.statusCode,
            'rawResponse': response.body,
          };
        }
      } else {
        // Error HTTP
        return {
          'success': false,
          'error': 'Error HTTP ${response.statusCode}',
          'statusCode': response.statusCode,
          'responseBody': response.body,
        };
      }
    } on SocketException {
      // Error de conexión
      return {'success': false, 'error': 'Error de conexión. Verifica tu internet.', 'actualizado': 'ERROR', 'mensaje': 'No se pudo conectar al servidor'};
    } on http.ClientException catch (e) {
      // Error del cliente HTTP
      return {'success': false, 'error': 'Error del cliente HTTP: $e', 'actualizado': 'ERROR', 'mensaje': 'Error en la comunicación'};
    } catch (e) {
      // Error general
      return {'success': false, 'error': 'Error inesperado: $e', 'actualizado': 'ERROR', 'mensaje': 'Error al enviar el documento'};
    }
  }

  /// Método auxiliar para validar que el archivo sea PDF
  static bool _esArchivoPDF(File file) {
    String extension = file.path.toLowerCase().split('.').last;
    return extension == 'pdf';
  }

  /// Método alternativo con validación más estricta
  /* static Future<Map<String, dynamic>> enviarDocumentacionConValidacion(
    String idestudiante,
    File documento,
  ) async {
    // Validaciones previas
    if (idestudiante.isEmpty) {
      return {'success': false, 'error': 'El ID del estudiante es requerido', 'actualizado': 'ERROR', 'mensaje': 'ID de estudiante vacío'};
    }

    if (!await documento.exists()) {
      return {'success': false, 'error': 'El archivo no existe', 'actualizado': 'ERROR', 'mensaje': 'Archivo no encontrado'};
    }

    // Validar tamaño máximo (ej: 10MB)
    const maxSizeBytes = 10 * 1024 * 1024; // 10MB
    final fileSize = await documento.length();

    if (fileSize > maxSizeBytes) {
      return {'success': false, 'error': 'El archivo excede el tamaño máximo permitido (10MB)', 'actualizado': 'ERROR', 'mensaje': 'Archivo demasiado grande'};
    }

    // Llamar al método principal
    return await enviarDocumentacion(idestudiante, documento);
  }*/

  Future<String?> consultarAsistenciaCSV({
    required String idDeporte,
    required String idEstudiante,
  }) async {
    try {
      final String urlVerAsistenciaEstudiante = AppConfig.instance.parametros['urlestudianteVerAsistencia'];
      final respuesta = await http.post(
        Uri.parse(urlVerAsistenciaEstudiante),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'id_deporte': idDeporte,
          'id_estudiante': idEstudiante,
        }),
      );

      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        final datos = jsonDecode(respuesta.body);
        return datos['csv'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> consultarComunicadosCSV({required String idDeporte}) async {
    try {
      String url = AppConfig.instance.parametros['urlestudianteVerComunicados'];

      // Headers para la petición
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Body de la petición
      final Map<String, String> body = {
        'id_deporte': idDeporte,
      };

      // Realizar la petición POST
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      // Verificar el código de estado
      if (response.statusCode == 200) {
        // Decodificar la respuesta
        final List<dynamic> responseData = json.decode(response.body);
        logear('********************************************');
        print(responseData);
        logear('********************************************');

        if (responseData.isNotEmpty) {
          final Map<String, dynamic> data = responseData[0];

          // Verificar si la respuesta es exitosa
          if (data['ok'] == true) {
            // Retornar los comunicados en formato CSV
            return data['comunicados'] as String?;
          } else {
            // El servidor respondió con ok: false
            print('Error en la respuesta del servidor: ok = false');
            return null;
          }
        } else {
          // Respuesta vacía
          print('Respuesta vacía del servidor');
          return null;
        }
      } else {
        // Error en la petición HTTP
        print('Error HTTP ${response.statusCode}: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      // Manejo de excepciones
      print('Error al consultar comunicados CSV: $e');
      return null;
    }
  }

  static Future<DeportesResponse> consultarDeportesDisponibles(String idEstudiante) async {
    try {
      String baseUrl = 'https://n8n.nextgonsas.com.co/webhook/deportes/ofrecidos/estudiantes';

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id_estudiante': idEstudiante,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return DeportesResponse.fromJson(jsonResponse);
      } else {
        // Manejo de errores HTTP
        throw Exception('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de errores de conexión
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

// Método para actualizar la inscripción del estudiante
  static Future<bool> actualizarInscripcionEstudiante({
    required String idEstudiante,
    required List<Deporte> deportes,
  }) async {
    try {
      // Crear el objeto de solicitud
      final request = ActualizacionEstudianteRequest(
        tipo: 'estudiante',
        idEstudiante: idEstudiante,
        deportes: deportes,
      );

      String baseUrl = 'https://n8n.nextgonsas.com.co/webhook/actualizar/elementos/administrador/estudiante';

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      // Log para debugging
      print('Status Code: ${response.statusCode}');
      print('Request Body: ${jsonEncode(request.toJson())}');

      if (response.statusCode == 200) {
        print('Actualización exitosa para estudiante: $idEstudiante');
        return true;
      } else {
        print('Error en la actualización: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      return false;
    }
  }
}
