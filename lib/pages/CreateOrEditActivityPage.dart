import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Button/ElevatedButton.dart';
import 'package:frontend_flutter/Widgets/Inputs/DateTimeInputForm.dart';
import 'package:frontend_flutter/Widgets/Inputs/InputForm.dart';
import 'package:frontend_flutter/Widgets/Inputs/InputOptionsForm.dart';
import 'package:frontend_flutter/Widgets/Inputs/MultilineInputForm.dart';
import 'package:frontend_flutter/Widgets/LocationMap.dart';
import 'package:frontend_flutter/Widgets/Navigation/BottomNavigationBar.dart';
import 'package:frontend_flutter/utils/location_service.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateOrEditActivityPage extends StatefulWidget {
  final Activity? activity; // Si se pasa, es para editar. Si no, es para crear.

  const CreateOrEditActivityPage({Key? key, this.activity}) : super(key: key);

  @override
  _CreateOrEditActivityPageState createState() =>
      _CreateOrEditActivityPageState();
}

class _CreateOrEditActivityPageState extends State<CreateOrEditActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _maxVolunteersController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  GeoPoint? _selectedLocation;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      _titleController.text = widget.activity!.titulo;
      _descriptionController.text = widget.activity!.descripcion;
      _categoryController.text = widget.activity!.categoria;
      _maxVolunteersController.text = widget.activity!.maxVoluntarios.toString();
      _imageUrlController.text = widget.activity!.imageUrl ?? '';
      _selectedDateTime = widget.activity!.fechahora;
      _dateTimeController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(widget.activity!.fechahora);
      _selectedLocation = widget.activity!.ubicacion;
      _durationController.text = widget.activity!.duracion.toString();

      _updateLocationText();
    }
  }

  Future<void> _updateLocationText() async {
    if (_selectedLocation != null) {
      final address = await LocationService.getAddressFromGeoPoint(_selectedLocation!);
      setState(() {
        _locationController.text = address;
      });
    }
  }

Future<void> _saveActivity() async {
  if (_formKey.currentState!.validate()) {
    final activity = Activity(
      id: widget.activity?.id ?? '',
      titulo: _titleController.text,
      descripcion: _descriptionController.text,
      fechahora: _selectedDateTime!,
      ubicacion: _selectedLocation!,
      categoria: _categoryController.text,
      maxVoluntarios: int.parse(_maxVolunteersController.text),
      imageUrl: _imageUrlController.text,
      voluntarios: widget.activity?.voluntarios ?? [],
      duracion: int.parse(_durationController.text),
      asistencia: widget.activity?.asistencia ?? {},
    );

    final activitiesProvider = Provider.of<ActivitiesProvider>(context, listen: false);

    if (widget.activity == null) {
      await activitiesProvider.addActivity(activity);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Actividad creada con éxito")),
      );
    } else {
      await activitiesProvider.updateActivity(activity);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Actividad actualizada con éxito")),
      );
    }

    // Notificar al proveedor que los datos han cambiado
    await activitiesProvider.refreshActivities();

    // Volver al Home
    Navigator.pop(context, true);
  }
}
  Future<void> _openLocationPicker() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerMap(),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = GeoPoint(
          selectedLocation.latitude,
          selectedLocation.longitude,
        );
        _updateLocationText(); // Actualizar el texto de la ubicación
      });
    }
  }
    final List<String> categories = [
        "Medio Ambiente",
        "Educación",
        "Salud",
        "Cultura",
        "Deportes",
        "Protección Animal",
        "Asistencia Social",
        "Tecnología",
        "Construcción y Vivienda",
        "Alimentación",
        "Capacitación Laboral",
        "Empoderamiento de la Mujer",
        "Inclusión Social",
        "Atención a Personas Mayores",
        "Infancia y Juventud",
        "Ayuda Social",
        "Derechos Humanos",
        "Arte y Música",
        "Desastres Naturales",
        "Desarrollo Comunitario",
        "Turismo Responsable",
        "Reciclaje y Gestión de Residuos",
        "Apoyo Psicológico",
        "Seguridad Alimentaria",
        "Campañas de Sensibilización",
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity == null ? "Crear Actividad" : "Editar Actividad", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              InputForm(
                hintext: 'Título',
                icon: const Icon(Icons.title),
                controller: _titleController,
                bgColor: Colors.white,
                borderColor: Colors.pinkAccent,
              ),
              const SizedBox(height: 10),
              MultilineInputForm(
                hintText: 'Descripción',
                controller: _descriptionController,
                bgColor: Colors.white,
                borderColor: Colors.pinkAccent,
              ),
              const SizedBox(height: 10),
              DateTimeInputForm(
                hintText: "Seleccione Fecha y Hora",
                icon: const Icon(Icons.calendar_today),
                controller: _dateTimeController,
                bgColor: Colors.white,
                borderColor: Colors.pink,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _selectedDateTime = dateTime;
                    _dateTimeController.text =
                        DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                  });
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InputForm(
                      hintext: 'Ubicacion', 
                      icon: const Icon(Icons.location_on), 
                      controller: _locationController, 
                      bgColor: Colors.white,
                      borderColor: Colors.pinkAccent,
                      )
                  ),
                  IconButton(
                    icon: const Icon(Icons.map, color: Colors.pinkAccent),
                    onPressed: _openLocationPicker,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              InputForm(
                hintext: 'URL de Imagen',
                icon: const Icon(Icons.image),
                controller: _imageUrlController,
                bgColor: Colors.white,
                borderColor: Colors.pinkAccent,
              ),
              const SizedBox(height: 10),
              InputOptionsForm(
                hintText: 'Seleccione Categoría',
                icon: const Icon(Icons.category),
                controller: _categoryController, 
                borderColor: Colors.pinkAccent,
                options: categories,
              ),
              const SizedBox(height: 10),
              InputForm(
                hintext: 'Duracion', 
                icon: const Icon(Icons.lock_clock), 
                bgColor: Colors.white,
                borderColor: Colors.pinkAccent,
                controller: _durationController
                ),
                const SizedBox(height: 10),
              InputForm(
                hintext: 'Número Máximo de Voluntarios',
                icon: const Icon(Icons.numbers),
                controller: _maxVolunteersController,
                inputType: 'number',
                bgColor: Colors.white,
                borderColor: Colors.pinkAccent,
              ),
              const SizedBox(height: 20),
              Button(
                onPressed: _saveActivity,
                text: widget.activity == null ? "Guardar Actividad" : "Actualizar Actividad",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
