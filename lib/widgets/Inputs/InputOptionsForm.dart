import 'package:flutter/material.dart';

class InputOptionsForm extends StatefulWidget {
  final String hintText;
  final Icon icon;
  final Color borderColor;
  final List<String> options;
  final TextEditingController controller;

  const InputOptionsForm({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.options,
    required this.controller,
    this.borderColor = Colors.pinkAccent,
  }) : super(key: key);

  @override
  _InputOptionsForm createState() => _InputOptionsForm();
}

class _InputOptionsForm extends State<InputOptionsForm> {
  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widget.borderColor, width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: widget.options.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.options[index]),
                onTap: () {
                  widget.controller.text = widget.options[index];
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showOptionsBottomSheet,
      child: AbsorbPointer(
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.icon,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.borderColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.borderColor, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
