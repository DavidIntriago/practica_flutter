import 'package:flutter/material.dart';

class ConfirmacionDialog extends StatelessWidget {
  final String titulo;
  final String mensaje;
  final VoidCallback onAceptar;

  ConfirmacionDialog({
    required this.titulo,
    required this.mensaje,
    required this.onAceptar,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cerrar el cuadro de diálogo
            onAceptar(); // Ejecutar la acción de aceptar
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}
