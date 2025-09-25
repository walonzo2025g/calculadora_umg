import 'package:flutter/material.dart';
import 'scientific_calculator.dart';

class ScientificCalculatorScreen extends StatefulWidget {
  const ScientificCalculatorScreen({super.key});

  @override
  State<ScientificCalculatorScreen> createState() => _ScientificCalculatorScreenState();
}

class _ScientificCalculatorScreenState extends State<ScientificCalculatorScreen> {
  String _display = '0';
  String _expression = '';
  bool _isResult = false;

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _display = '0';
        _expression = '';
        _isResult = false;
      } else if (buttonText == '=') {
        try {
          _display = ScientificCalculator.evaluate(_expression).toString();
          _expression = _display;
          _isResult = true;
        } catch (e) {
          _display = 'Error';
          _expression = '';
        }
      } else if (buttonText == '⌫') {
        if (_display.isNotEmpty && _display != '0') {
          _display = _display.length > 1 ? _display.substring(0, _display.length - 1) : '0';
          _expression = _expression.length > 1 ? _expression.substring(0, _expression.length - 1) : '';
        }
      } else {
        if (_isResult && !'+-×÷'.contains(buttonText)) {
          _display = buttonText;
          _expression = buttonText;
          _isResult = false;
        } else {
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

  Widget _buildButton(String text, {Color color = Colors.white, Color textColor = Colors.black, double fontSize = 18}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(2),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
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
          // Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.black87,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 36, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ),
          
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Primera fila - Funciones avanzadas
                  Row(children: [
                    _buildButton('sin', color: Colors.orange, textColor: Colors.white, fontSize: 16),
                    _buildButton('cos', color: Colors.orange, textColor: Colors.white, fontSize: 16),
                    _buildButton('tan', color: Colors.orange, textColor: Colors.white, fontSize: 16),
                    _buildButton('⌫', color: Colors.red, textColor: Colors.white),
                    _buildButton('C', color: Colors.red, textColor: Colors.white),
                  ]),
                  
                  // Segunda fila - Más funciones
                  Row(children: [
                    _buildButton('√', color: Colors.orange, textColor: Colors.white),
                    _buildButton('log', color: Colors.orange, textColor: Colors.white, fontSize: 16),
                    _buildButton('ln', color: Colors.orange, textColor: Colors.white, fontSize: 16),
                    _buildButton('π', color: Colors.blue, textColor: Colors.white),
                    _buildButton('e', color: Colors.blue, textColor: Colors.white),
                  ]),
                  
                  // Tercera fila - Números y operaciones básicas
                  Row(children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('÷', color: Colors.blue, textColor: Colors.white),
                    _buildButton('(', color: Colors.green, textColor: Colors.white),
                  ]),
                  
                  // Cuarta fila
                  Row(children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('×', color: Colors.blue, textColor: Colors.white),
                    _buildButton(')', color: Colors.green, textColor: Colors.white),
                  ]),
                  
                  // Quinta fila
                  Row(children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('-', color: Colors.blue, textColor: Colors.white),
                    _buildButton('^', color: Colors.orange, textColor: Colors.white),
                  ]),
                  
                  // Sexta fila
                  Row(children: [
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('=', color: Colors.green, textColor: Colors.white),
                    _buildButton('+', color: Colors.blue, textColor: Colors.white),
                    _buildButton('', color: Colors.grey),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}