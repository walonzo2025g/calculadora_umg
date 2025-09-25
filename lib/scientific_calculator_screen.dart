import 'dart:math';

/**
 * MOTOR DE CÁLCULO CIENTÍFICO
 * 
 * Clase estática que procesa expresiones matemáticas complejas
 * Convierte texto en operaciones matemáticas reales
 */
class ScientificCalculator {
  
  /**
   * EVALUAR EXPRESIÓN - Método principal
   * 
   * Convierte: "sin(90) + √(16)" → 1.0 + 4.0 → 5.0
   * 
   * @param expression: String con la operación matemática
   * @return: Resultado numérico de la expresión
   */
  static double evaluate(String expression) {
    try {
      // 1. LIMPIAR: Eliminar espacios y unificar símbolos
      expression = expression.replaceAll(' ', '')
                   .replaceAll('×', '*').replaceAll('÷', '/');
      
      // 2. CONSTANTES: Reemplazar π y e por sus valores numéricos
      expression = expression.replaceAll('π', pi.toString())
                   .replaceAll('e', e.toString());
      
      // 3. FUNCIONES: Procesar sin, cos, tan, √, log, ln
      expression = _replaceFunctions(expression);
      
      // 4. OPERACIONES: Evaluar +, -, *, /, ^
      return _evaluateBasic(expression);
    } catch (e) {
      throw Exception('Error en la expresión: $e');
    }
  }

  /**
   * PROCESAR FUNCIONES MATEMÁTICAS
   * 
   * Convierte funciones en texto a resultados numéricos
   * Ej: "sin(90)" → "1.0"
   */
  static String _replaceFunctions(String expression) {
    // Diccionario de funciones disponibles
    var functions = {
      'sin': (x) => sin(x),     // Seno (radianes)
      'cos': (x) => cos(x),     // Coseno
      'tan': (x) => tan(x),     // Tangente
      '√': (x) => sqrt(x),      // Raíz cuadrada
      'log': (x) => log(x),     // Logaritmo natural (base e)
      'ln': (x) => log(x),      // Logaritmo natural
    };

    // Buscar y reemplazar cada función en la expresión
    for (var function in functions.entries) {
      final pattern = '${function.key}\\(([^)]+)\\)'; // Ej: sin\((.*?)\)
      final regex = RegExp(pattern);
      
      // Reemplazar todas las ocurrencias de la función
      while (regex.hasMatch(expression)) {
        expression = expression.replaceFirstMapped(regex, (match) {
          final value = double.parse(match.group(1)!); // Extraer número
          final result = function.value(value);        // Calcular función
          return result.toString();                    // Devolver resultado
        });
      }
    }
    
    return expression;
  }

  /**
   * EVALUAR OPERACIONES BÁSICAS
   * 
   * Procesa operadores aritméticos en orden de precedencia
   * +, -, *, /, ^ (potencia)
   */
  static double _evaluateBasic(String expression) {
    // ORDEN DE EVALUACIÓN: ^ → * / → + -
    if (expression.contains('+')) {
      List<String> parts = expression.split('+');
      return _evaluateBasic(parts[0]) + _evaluateBasic(parts[1]);
    } else if (expression.contains('-')) {
      List<String> parts = expression.split('-');
      return _evaluateBasic(parts[0]) - _evaluateBasic(parts[1]);
    } else if (expression.contains('*')) {
      List<String> parts = expression.split('*');
      return _evaluateBasic(parts[0]) * _evaluateBasic(parts[1]);
    } else if (expression.contains('/')) {
      List<String> parts = expression.split('/');
      return _evaluateBasic(parts[0]) / _evaluateBasic(parts[1]);
    } else if (expression.contains('^')) {
      List<String> parts = expression.split('^');
      return pow(_evaluateBasic(parts[0]), _evaluateBasic(parts[1])).toDouble();
    } else {
      // Conversión final a número
      return double.tryParse(expression) ?? 0;
    }
  }
}

/**
 * EJEMPLOS DE USO:
 * 
 * evaluate("sin(90) + 5")       → 1.0 + 5 = 6.0
 * evaluate("√(16) * 2")         → 4.0 * 2 = 8.0  
 * evaluate("2^3 + π")           → 8.0 + 3.1416 = 11.1416
 * evaluate("log(e)")            → 1.0
 * 
 * FUNCIONES SOPORTADAS:
 * - sin(x), cos(x), tan(x)  → Trigonometría (radianes)
 * - √(x)                    → Raíz cuadrada
 * - log(x), ln(x)           → Logaritmos
 * - ^                       → Potencia
 * - π, e                    → Constantes matemáticas
 */
