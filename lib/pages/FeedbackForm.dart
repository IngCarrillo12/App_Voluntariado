import 'package:flutter/material.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:provider/provider.dart';


class FeedbackForm extends StatefulWidget {
  final String activityId;

  const FeedbackForm({Key? key, required this.activityId}) : super(key: key);

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  int _rating = 5; 
   

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback de la Actividad"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Calificación",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _rating.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: "$_rating",
                onChanged: (value) {
                  setState(() {
                    _rating = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                "Comentario",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Escribe tu opinión sobre la actividad...",
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, escribe un comentario";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = userProvider.user;
                    if (user == null) return;

                    final feedback ={
                      "id": '',
                      "userId": user.userId,
                      "nombreuser": user.nombreCompleto,
                      "comentario": _commentController.text,
                      "calificacion": _rating,
                      "timestamp": DateTime.now(),
                    };

                    await activitiesProvider.addFeedbackToActivity(widget.activityId, feedback);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gracias por tu feedback")),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Enviar Feedback"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}