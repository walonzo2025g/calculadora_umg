import 'package:flutter/material.dart';
import 'scientific_calculator.dart';

/**
 * CALCULADORA CIENTÍFICA - Pantalla Principal
 * 
 * Esta pantalla ofrece funciones matemáticas avanzadas como:
 * - Trigonometría (sin, cos, tan)
 * - Logaritmos (log, ln)
 * - Raíz cuadrada (√)
 * - Potencias (^)
 * - Constantes (π, e)
 * - Paréntesis para expresiones complejas
 */
class ScientificCalculatorScreen extends StatefulWidget {
  const ScientificCalculatorScreen({super.key});

  @override
  State<ScientificCalculatorScreen> createState() => _ScientificCalculatorScreenState();
}

class _ScientificCalculatorScreenState extends State<ScientificCalculatorScreen> {
  String _display = '0';      // Texto mostrado en pantalla
  String _expression = '';    // Expresión matemática completa
  bool _isResult = false;     // Indica si se muestra un resultado

  /**
   * Maneja las pulsaciones de todos los botones
   */
  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        // LIMPIAR: Reinicia toda la calculadora
        _display = '0';
        _expression = '';
        _isResult = false;
      } else if (buttonText == '=') {
        // CALCULAR: Evalúa la expresión matemática
        try {
          _display = ScientificCalculator.evaluate(_expression).toString();
          _expression = _display;
          _isResult = true;
        } catch (e) {
          _display = 'Error';
          _expression = '';
        }
      } else if (buttonText == '⌫') {
        // BORRAR: Elimina el último carácter
        if (_display.isNotEmpty && _display != '0') {
          _display = _display.length > 1 ? _display.substring(0, _display.length - 1) : '0';
          _expression = _expression.length > 1 ? _expression.substring(0, _expression.length - 1) : '';
        }
      } else {
        // OTROS BOTONES: Agrega a la expresión actual
        if (_isResult && !'+-×÷'.contains(buttonText)) {
          // Si hay resultado y se presiona número, comenzar nueva expresión
          _display = buttonText;
          _expression = buttonText;
          _isResult = false;
        } else {
          // Agregar a la expresión existente
          if (_display == '0' && buttonText != '.') {
            _display = buttonText;
          } else {
            _display += buttonText;
          }
          _expression += buttonText;
        }
      }
    });
  }

  /**
   * Crea un botón personalizado con colores específicos
   */
  Widget _buildButton(String text, {Color color = Colors.white, Color textColor = Colors.black, double fontSize = 18}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(2),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(text, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Científica'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // PANTALLA DE RESULTADOS (fondo negro)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.black87,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(_display, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          
          // TECLADO CIENTÍFICO
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Fila 1: Funciones trigonométricas y limpieza
                  Row(children: [
                    _buildButton('sin', color: Colors.orange, textColor: Colors.white, fontSize: 16),  // Seno
                    _buildButton('cos', color: Colors.orange, textColor: Colors.white, fontSize: 16),  // Coseno
                    _buildButton('tan', color: Colors.orange, textColor: Colors.white, fontSize: 16),  // Tangente
                    _buildButton('⌫', color: Colors.red, textColor: Colors.white),                     // Borrar
                    _buildButton('C', color: Colors.red, textColor: Colors.white),                     // Limpiar todo
                  ]),
                  
                  // Fila 2: Raíz, logaritmos y constantes
                  Row(children: [
                    _buildButton('√', color: Colors.orange, textColor: Colors.white),                  // Raíz cuadrada
                    _buildButton('log', color: Colors.orange, textColor: Colors.white, fontSize: 16),  // Logaritmo base 10
                    _buildButton('ln', color: Colors.orange, textColor: Colors.white, fontSize: 16),   // Logaritmo natural
                    _buildButton('π', color: Colors.blue, textColor: Colors.white),                    // Constante Pi (3.1416)
                    _buildButton('e', color: Colors.blue, textColor: Colors.white),                    // Constante Euler (2.7182)
                  ]),
                  
                  // Filas 3-6: Números, operaciones básicas y funciones avanzadas
                  Row(children: [ _buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('÷', color: Colors.blue), _buildButton('(', color: Colors.green) ]),
                  Row(children: [ _buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('×', color: Colors.blue), _buildButton(')', color: Colors.green) ]),
                  Row(children: [ _buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-', color: Colors.blue), _buildButton('^', color: Colors.orange) ]),
                  Row(children: [ _buildButton('0'), _buildButton('.'), _buildButton('=', color: Colors.green), _buildButton('+', color: Colors.blue), _buildButton('', color: Colors.grey) ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/**
 * COLORES Y SIGNIFICADOS:
 * 
 * 🟠 NARANJA: Funciones científicas (sin, cos, tan, √, log, ln, ^)
 * 🔵 AZUL: Operaciones básicas (+, -, ×, ÷) y constantes (π, e)
 * 🟢 VERDE: Paréntesis y igual (=)
 * 🔴 ROJO: Limpieza (C, ⌫)
 * ⚪ BLANCO: Números y punto decimal
 * 
 * FUNCIONES DISPONIBLES:
 * - sin(90), cos(45), tan(30) → Trigonometría
 * - √(16) → Raíz cuadrada = 4
 * - log(100) → Logaritmo base 10 = 2
 * - ln(e) → Logaritmo natural = 1
 * - 2^3 → Potencia = 8
 * - (5+3)*2 → Expresiones con paréntesis = 16
 */
