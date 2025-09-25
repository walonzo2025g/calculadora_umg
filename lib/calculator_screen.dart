import 'package:flutter/material.dart';
import 'calculator_model.dart';
import 'scientific_calculator_screen.dart'; // Importar la pantalla científica

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorModel _calculator = CalculatorModel();

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _calculator.reset();
      } else if (buttonText == 'CE') {
        _calculator.clearEntry();
      } else if (buttonText == '⌫') {
        _calculator.deleteLast();
      } else if (buttonText == '±') {
        _calculator.toggleSign();
      } else if (buttonText == '=') {
        _calculator.calculate();
      } else if (buttonText == 'Sci') {
        // Navegar a la calculadora científica
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScientificCalculatorScreen()),
        );
        return; // Salir sin actualizar el estado de la calculadora actual
      } else if (['+', '-', '×', '÷', '%'].contains(buttonText)) {
        _calculator.setOperation(buttonText);
      } else {
        _calculator.addDigit(buttonText);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ MARCA DE AGUA CON LOGO - CORREGIDO
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/umg_logo.png',
                  width: 150,
                  height: 480,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.school,
                      size: 100,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),

            // CONTENIDO PRINCIPAL
            Column(
              children: [
                // Display
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (_calculator.previousInput.isNotEmpty)
                          Text(
                            '${_calculator.previousInput} ${_getOperationSymbol()}',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey[600],
                            ),
                          ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            _calculator.currentInput,
                            style: TextStyle(
                              fontSize: _calculator.currentInput.length > 10 ? 36 : 48,
                              fontWeight: FontWeight.bold,
                              color: _calculator.hasError ? Colors.red : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Teclado
                Expanded(
                  flex: 2,
                  child: GridView.count(
                    crossAxisCount: 4,
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: _buildButtons(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getOperationSymbol() {
    switch (_calculator.operation) {
      case '+': return '+';
      case '-': return '-';
      case '×': return '×';
      case '÷': return '÷';
      case '%': return '%';
      default: return '';
    }
  }

  List<Widget> _buildButtons() {
    // Modificamos el array para reemplazar '%' por 'Sci' y mantener 4 columnas
    final buttons = [
      ['C', 'CE', '⌫', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['±', '0', '.', '='],
      ['Sci', '', '', ''] // Fila adicional para el botón Sci
    ];

    return buttons.expand((row) => row).map((buttonText) {
      return CalculatorButton(
        text: buttonText,
        onPressed: buttonText.isEmpty ? null : () => _onButtonPressed(buttonText),
      );
    }).toList();
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return Container(); // Botón vacío invisible
    }

    final bool isNumber = double.tryParse(text) != null || text == '.';
    final bool isOperation = ['+', '-', '×', '÷', '%'].contains(text);
    final bool isSpecial = ['C', 'CE', '⌫', '±'].contains(text);
    final bool isEquals = text == '=';
    final bool isScientific = text == 'Sci';

    Color backgroundColor;
    Color textColor;

    if (isEquals) {
      backgroundColor = Colors.blue;
      textColor = Colors.white;
    } else if (isScientific) {
      backgroundColor = Colors.purple; // Color distintivo para el botón Sci
      textColor = Colors.white;
    } else if (isOperation) {
      backgroundColor = Colors.orange;
      textColor = Colors.white;
    } else if (isSpecial) {
      backgroundColor = Colors.grey[300]!;
      textColor = Colors.black;
    } else if (isNumber) {
      backgroundColor = Colors.white;
      textColor = Colors.black;
    } else {
      backgroundColor = Colors.grey[200]!;
      textColor = Colors.black;
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        padding: const EdgeInsets.all(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: text == 'Sci' ? 20 : 24, // Tamaño ajustado para 'Sci'
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}