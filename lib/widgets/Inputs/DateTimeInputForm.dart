import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeInputForm extends StatefulWidget {
  final String hintText;
  final Color bgColor;
  final Color placeholderColor;
  final Color textColor;
  final Color borderColor;
  final TextEditingController? controller;
  final Icon icon;
  final Function(DateTime) onDateTimeChanged;

  const DateTimeInputForm({
    Key? key,
    required this.hintText,
    this.placeholderColor = Colors.grey,
    this.bgColor = Colors.black26,
    this.textColor = Colors.black,
    this.borderColor = Colors.pinkAccent,
    required this.icon,
    required this.onDateTimeChanged,
    this.controller,
  }) : super(key: key);

  @override
  _DateTimeInputFormState createState() => _DateTimeInputFormState();
}

class _DateTimeInputFormState extends State<DateTimeInputForm> {
  DateTime? selectedDateTime;

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (selectedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );

          // Formatear la fecha y la hora
          String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!);

          // Actualizar el controlador con el valor formateado
          widget.controller?.text = formattedDateTime;

          // Llamar a la función de callback
          widget.onDateTimeChanged(selectedDateTime!);
        });
      }
    }
  }

  @override
Widget build(BuildContext context) {
  return TextField(
    controller: widget.controller,
    readOnly: true,
    onTap: () => _selectDateTime(context),
    decoration: InputDecoration(
      hintText: widget.hintText,
      hintStyle: TextStyle(color: widget.placeholderColor),
      filled: true,
      fillColor: widget.bgColor,
      prefixIcon: widget.icon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: widget.borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: widget.borderColor, width: 1),
      ),
    ),
    style: TextStyle(color: widget.textColor),
  );
}
}
