// Importación de paquetes necesarios de Flutter
import 'package:flutter/material.dart';
// Importación del modelo que contiene la lógica de la calculadora
import 'calculator_model.dart';
// Importación de la pantalla de calculadora científica
import 'scientific_calculator_screen.dart';

/**
 * PANTALLA DE CALCULADORA BÁSICA - CalculatorScreen
 * 
 * Esta clase representa la pantalla principal de la calculadora básica.
 * Es un StatefulWidget porque necesita mantener y actualizar su estado
 * (los números y operaciones ingresadas).
 */
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  /**
   * MÉTODO createState - Crea el estado de la pantalla
   * 
   * Este método es requerido por los StatefulWidget y devuelve
   * la clase que manejará el estado de esta pantalla.
   */
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

/**
 * ESTADO DE LA CALCULADORA BÁSICA - _CalculatorScreenState
 * 
 * Esta clase maneja todo el estado y la lógica de la interfaz
 * de la calculadora básica.
 */
class _CalculatorScreenState extends State<CalculatorScreen> {
  // Instancia del modelo que contiene la lógica matemática
  final CalculatorModel _calculator = CalculatorModel();

  /**
   * MÉTODO _onButtonPressed - Maneja las pulsaciones de botones
   * 
   * Este método se ejecuta cada vez que el usuario presiona un botón
   * de la calculadora. Determina qué acción tomar según el texto del botón.
   * 
   * @param buttonText: El texto del botón presionado (ej: '1', '+', 'C', etc.)
   */
  void _onButtonPressed(String buttonText) {
    setState(() {
      // setState() indica a Flutter que debe redibujar la interfaz
      
      // =============================================
      // LÓGICA DE MANEJO DE BOTONES
      // =============================================
      
      if (buttonText == 'C') {
        // BOTÓN C: Reset completo - Borra todo
        _calculator.reset();
      } else if (buttonText == 'CE') {
        // BOTÓN CE: Clear Entry - Borra la entrada actual
        _calculator.clearEntry();
      } else if (buttonText == '⌫') {
        // BOTÓN ⌫: Delete Last - Elimina el último dígito
        _calculator.deleteLast();
      } else if (buttonText == '±') {
        // BOTÓN ±: Toggle Sign - Cambia entre positivo y negativo
        _calculator.toggleSign();
      } else if (buttonText == '=') {
        // BOTÓN =: Calculate - Realiza el cálculo
        _calculator.calculate();
      } else if (buttonText == 'Sci') {
        // BOTÓN Sci: Navegar a calculadora científica
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScientificCalculatorScreen()),
        );
        return; // Sale sin actualizar el estado actual
      } else if (['+', '-', '×', '÷', '%'].contains(buttonText)) {
        // BOTONES DE OPERACIÓN: +, -, ×, ÷, %
        _calculator.setOperation(buttonText);
      } else {
        // BOTONES NUMÉRICOS: 0-9 y punto decimal
        _calculator.addDigit(buttonText);
      }
    });
  }

  /**
   * MÉTODO build - Construye la interfaz de usuario
   * 
   * Este método define cómo se ve la pantalla de la calculadora.
   * Contiene el display y el teclado de botones.
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fondo gris claro
      body: SafeArea(
        child: Stack(
          children: [
            // =============================================
            // MARCA DE AGUA CON LOGO (FONDO DECORATIVO)
            // =============================================
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.1, // Muy transparente
                child: Image.asset(
                  'assets/umg_logo.png', // Ruta del logo
                  width: 150,
                  height: 480,
                  errorBuilder: (context, error, stackTrace) {
                    // Si falla la carga de la imagen, muestra un icono
                    return const Icon(
                      Icons.school,
                      size: 100,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),

            // =============================================
            // CONTENIDO PRINCIPAL DE LA CALCULADORA
            // =============================================
            Column(
              children: [
                // =============================================
                // DISPLAY DE LA CALCULADORA (PARTE SUPERIOR)
                // =============================================
                Expanded(
                  flex: 1, // Ocupa 1 parte del espacio disponible
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // LÍNEA SUPERIOR: Muestra la operación anterior
                        if (_calculator.previousInput.isNotEmpty)
                          Text(
                            '${_calculator.previousInput} ${_getOperationSymbol()}',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey[600],
                            ),
                          ),
                        
                        // LÍNEA PRINCIPAL: Muestra el número actual
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal, // Permite desplazamiento horizontal
                          child: Text(
                            _calculator.currentInput,
                            style: TextStyle(
                              // Tamaño de fuente adaptable: más pequeño si el número es largo
                              fontSize: _calculator.currentInput.length > 10 ? 36 : 48,
                              fontWeight: FontWeight.bold,
                              // Color rojo si hay error, negro si está bien
                              color: _calculator.hasError ? Colors.red : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // =============================================
                // TECLADO DE BOTONES (PARTE INFERIOR)
                // =============================================
                Expanded(
                  flex: 2, // Ocupa 2 partes del espacio (el doble que el display)
                  child: GridView.count(
                    crossAxisCount: 4, // 4 columnas de botones
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 12, // Espacio vertical entre botones
                    crossAxisSpacing: 12, // Espacio horizontal entre botones
                    children: _buildButtons(), // Construye los botones
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /**
   * MÉTODO _getOperationSymbol - Convierte símbolos de operación
   * 
   * Convierte los símbolos almacenados en el modelo a símbolos
   * visualmente más atractivos para mostrar en el display.
   */
  String _getOperationSymbol() {
    switch (_calculator.operation) {
      case '+': return '+';
      case '-': return '-';
      case '×': return '×';  // Más visual que '*'
      case '÷': return '÷';  // Más visual que '/'
      case '%': return '%';
      default: return '';
    }
  }

  /**
   * MÉTODO _buildButtons - Construye la matriz de botones
   * 
   * Define la disposición de los botones en una cuadrícula 4x4
   * y crea los widgets CalculatorButton para cada celda.
   */
  List<Widget> _buildButtons() {
    // Matriz que define la disposición de los botones
    final buttons = [
      ['C', 'CE', '⌫', '÷'],    // Fila 1: Limpieza y división
      ['7', '8', '9', '×'],     // Fila 2: Números y multiplicación
      ['4', '5', '6', '-'],     // Fila 3: Números y resta
      ['1', '2', '3', '+'],     // Fila 4: Números y suma
      ['±', '0', '.', '='],     // Fila 5: Signo, cero, decimal, igual
      ['Sci', '', '', '']       // Fila 6: Botón científico y espacios vacíos
    ];

    // Convierte la matriz 2D en una lista 1D de widgets
    return buttons.expand((row) => row).map((buttonText) {
      return CalculatorButton(
        text: buttonText,
        onPressed: buttonText.isEmpty ? null : () => _onButtonPressed(buttonText),
      );
    }).toList();
  }
}

/**
 * BOTÓN DE CALCULADORA PERSONALIZADO - CalculatorButton
 * 
 * Widget reutilizable que representa un botón de la calculadora
 * con estilos específicos según su función.
 */
class CalculatorButton extends StatelessWidget {
  final String text;           // Texto que muestra el botón
  final VoidCallback? onPressed; // Función a ejecutar al presionar

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  /**
   * MÉTODO build - Construye el botón con estilo condicional
   * 
   * Asigna colores diferentes según el tipo de botón:
   * - Números: Fondo blanco
   * - Operaciones: Fondo naranja
   * - Igual: Fondo azul
   * - Científico: Fondo morado
   * - Especiales: Fondo gris
   */
  @override
  Widget build(BuildContext context) {
    // Botones vacíos son invisibles (para mantener la cuadrícula)
    if (text.isEmpty) {
      return Container();
    }

    // =============================================
    // DETERMINACIÓN DEL TIPO DE BOTÓN
    // =============================================
    final bool isNumber = double.tryParse(text) != null || text == '.';
    final bool isOperation = ['+', '-', '×', '÷', '%'].contains(text);
    final bool isSpecial = ['C', 'CE', '⌫', '±'].contains(text);
    final bool isEquals = text == '=';
    final bool isScientific = text == 'Sci';

    // =============================================
    // ASIGNACIÓN DE COLORES SEGÚN TIPO
    // =============================================
    Color backgroundColor;
    Color textColor;

    if (isEquals) {
      backgroundColor = Colors.blue;      // Igual: Azul
      textColor = Colors.white;
    } else if (isScientific) {
      backgroundColor = Colors.purple;    // Científico: Morado
      textColor = Colors.white;
    } else if (isOperation) {
      backgroundColor = Colors.orange;    // Operaciones: Naranja
      textColor = Colors.white;
    } else if (isSpecial) {
      backgroundColor = Colors.grey[300]!; // Especiales: Gris claro
      textColor = Colors.black;
    } else if (isNumber) {
      backgroundColor = Colors.white;     // Números: Blanco
      textColor = Colors.black;
    } else {
      backgroundColor = Colors.grey[200]!; // Por defecto: Gris
      textColor = Colors.black;
    }

    // =============================================
    // CONSTRUCCIÓN DEL BOTÓN CON ESTILOS
    // =============================================
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordes redondeados
        ),
        elevation: 2, // Sombra suave
        padding: const EdgeInsets.all(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: text == 'Sci' ? 20 : 24, // Tamaño especial para 'Sci'
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/**
 * RESUMEN DE FUNCIONALIDADES:
 * 
 * ✅ DISPLAY INTELIGENTE:
 *    - Muestra operación anterior y actual
 *    - Tamaño de fuente adaptable
 *    - Color rojo para errores
 *    - Desplazamiento horizontal para números largos
 * 
 * ✅ BOTONES ORGANIZADOS:
 *    - 4 columnas × 6 filas
 *    - Colores por categoría (números, operaciones, especiales)
 *    - Botón 'Sci' para ir a calculadora científica
 * 
 * ✅ EXPERIENCIA DE USUARIO:
 *    - Marca de agua decorativa
 *    - Bordes redondeados
 *    - Feedback visual con colores
 *    - Navegación fluida entre calculadoras
 * 
 * ✅ MANEJO DE ERRORES:
 *    - Imagen de respaldo si el logo no carga
 *    - Validación de operaciones matemáticas
 */
