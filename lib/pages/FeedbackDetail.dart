import 'package:flutter/material.dart';


class FeedbackDetail extends StatelessWidget {
   final Map<String, dynamic> feedback;

  const FeedbackDetail({Key? key, required this.feedback}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del Feedback"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: feedback != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Calificación",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: feedback['calificacion'].toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: "${feedback['calificacion']}",
                    onChanged: null, // No se puede cambiar, solo lectura
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Comentario",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feedback['comentario'] ?? "No hay comentario",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Fecha de Feedback",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                 Text(
                     feedback['timestamp'].toDate().toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              )
            : const Center(
                child: Text("No hay feedback disponible para este usuario."),
              ),
      ),
    );
  }
}
