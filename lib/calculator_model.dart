/**
 * MODELO DE CALCULADORA - CalculatorModel
 * 
 * Esta clase contiene toda la lógica matemática y el estado interno
 * de la calculadora. Es el "cerebro" de la aplicación que realiza
 * los cálculos y maneja los datos.
 * 
 * PRINCIPIO DE SEPARACIÓN DE CONCERNCIOS:
 * - Esta clase se encarga solo de la lógica de negocio
 * - Las pantallas (UI) se encargan solo de mostrar los datos
 * - Esto permite cambiar la interfaz sin afectar los cálculos
 */
class CalculatorModel {
  // =============================================
  // VARIABLES DE ESTADO INTERNO (PRIVADAS)
  // =============================================
  
  /**
   * _currentInput - Entrada actual del usuario
   * Almacena el número que el usuario está escribiendo actualmente
   * Valor inicial: '0' (calculadora comienza en cero)
   */
  String _currentInput = '0';
  
  /**
   * _previousInput - Entrada anterior
   * Almacena el primer número de una operación (ej: cuando se presiona 5 + ...)
   */
  String _previousInput = '';
  
  /**
   * _operation - Operación seleccionada
   * Almacena la operación matemática actual (+, -, ×, ÷, %)
   * Cadena vacía significa que no hay operación activa
   */
  String _operation = '';
  
  /**
   * _shouldResetInput - Bandera para resetear entrada
   * Indica si la próxima entrada debe comenzar desde cero
   * Se activa después de una operación o cuando se presiona un operador
   */
  bool _shouldResetInput = false;
  
  /**
   * _hasError - Indicador de error
   * Se activa cuando ocurre un error matemático (como división por cero)
   * Cuando hay error, la calculadora necesita ser reseteada
   */
  bool _hasError = false;

  // =============================================
  // GETTERS PÚBLICOS (ACCESO DESDE LA INTERFAZ)
  // =============================================
  
  /**
   * Los getters permiten que la interfaz lea el estado actual
   * pero no puede modificarlo directamente (encapsulación)
   */
  String get currentInput => _currentInput;    // Número actual en display
  String get previousInput => _previousInput;  // Número anterior para operaciones
  String get operation => _operation;          // Operación actual seleccionada
  bool get hasError => _hasError;              // Estado de error

  // =============================================
  // MÉTODO: RESET COMPLETO
  // =============================================
  
  /**
   * reset - Reinicia toda la calculadora al estado inicial
   * 
   * Se ejecuta cuando:
   * - El usuario presiona el botón 'C' (Clear)
   * - Ocurre un error y se necesita limpiar
   * - La aplicación inicia
   */
  void reset() {
    _currentInput = '0';      // Vuelve a cero
    _previousInput = '';      // Limpia entrada anterior
    _operation = '';          // Elimina operación actual
    _shouldResetInput = false; // Desactiva bandera de reset
    _hasError = false;        // Limpia cualquier error
  }

  // =============================================
  // MÉTODO: AGREGAR DÍGITO
  // =============================================
  
  /**
   * addDigit - Agrega un dígito o punto decimal a la entrada actual
   * 
   * @param digit: El dígito a agregar ('0'-'9' o '.')
   * 
   * Lógica de manejo:
   * - Si hay error, primero resetea la calculadora
   * - Si debe resetear, comienza nueva entrada desde cero
   * - Evita múltiples puntos decimales
   * - Limita la longitud máxima a 15 caracteres
   */
  void addDigit(String digit) {
    // Si hay error, reiniciar antes de agregar dígito
    if (_hasError) reset();
    
    // Si se debe resetear la entrada (después de operación)
    if (_shouldResetInput) {
      _currentInput = '0';
      _shouldResetInput = false;
    }

    // Manejo especial para el primer dígito
    if (_currentInput == '0' && digit != '.') {
      _currentInput = digit; // Reemplaza el cero inicial
    } 
    // Evitar múltiples puntos decimales
    else if (digit == '.' && _currentInput.contains('.')) {
      return; // Ignora el punto adicional
    } 
    // Limitar longitud máxima para evitar desbordamiento
    else if (_currentInput.length < 15) {
      _currentInput += digit; // Agrega el dígito al final
    }
  }

  // =============================================
  // MÉTODO: ESTABLECER OPERACIÓN
  // =============================================
  
  /**
   * setOperation - Configura una operación matemática
   * 
   * @param operation: La operación a realizar (+, -, ×, ÷, %)
   * 
   * Comportamiento:
   * - Si ya hay una operación pendiente, calcula primero
   * - Guarda el número actual como 'anterior'
   * - Prepara la calculadora para recibir el siguiente número
   */
  void setOperation(String operation) {
    // No permitir operaciones si hay error
    if (_hasError) return;
    
    // Si ya hay una operación y no se ha reseteado, calcular primero
    // Ejemplo: 5 + 3 × 2 → primero calcula 5+3=8, luego 8×2
    if (_operation.isNotEmpty && !_shouldResetInput) {
      calculate();
    }
    
    // Guardar el estado actual para la operación
    _previousInput = _currentInput; // Guarda el primer número
    _operation = operation;         // Almacena la operación
    _shouldResetInput = true;       // Prepara para nuevo número
  }

  // =============================================
  // MÉTODO: REALIZAR CÁLCULO
  // =============================================
  
  /**
   * calculate - Ejecuta la operación matemática
   * 
   * Realiza el cálculo entre _previousInput y _currentInput
   * usando la operación almacenada en _operation.
   * 
   * Manejo de errores:
   * - División por cero → muestra error
   * - Cualquier excepción → muestra error genérico
   */
  void calculate() {
    // Validaciones previas al cálculo
    if (_operation.isEmpty || _previousInput.isEmpty || _hasError) return;

    try {
      // Convertir strings a números decimales
      final num1 = double.parse(_previousInput);
      final num2 = double.parse(_currentInput);
      double result = 0;

      // =============================================
      // LÓGICA DE OPERACIONES MATEMÁTICAS
      // =============================================
      switch (_operation) {
        case '+': // SUMA
          result = num1 + num2;
          break;
        case '-': // RESTA
          result = num1 - num2;
          break;
        case '×': // MULTIPLICACIÓN
          result = num1 * num2;
          break;
        case '÷': // DIVISIÓN (con validación de cero)
          if (num2 == 0) {
            _hasError = true;
            _currentInput = 'Error: División por cero';
            return;
          }
          result = num1 / num2;
          break;
        case '%': // MÓDULO (residuo de división)
          result = num1 % num2;
          break;
      }

      // Formatear y mostrar el resultado
      _currentInput = _formatResult(result);
      _previousInput = '';          // Limpiar entrada anterior
      _operation = '';              // Limpiar operación
      _shouldResetInput = true;     // Preparar para nueva entrada
      
    } catch (e) {
      // Manejo de cualquier error inesperado
      _hasError = true;
      _currentInput = 'Error';
    }
  }

  // =============================================
  // MÉTODO PRIVADO: FORMATEAR RESULTADO
  // =============================================
  
  /**
   * _formatResult - Da formato legible al resultado numérico
   * 
   * @param result: El número resultante del cálculo
   * @return: String formateada para mostrar
   * 
   * Reglas de formato:
   * - Números enteros: mostrar sin decimales (5 en lugar de 5.0)
   * - Números decimales: máximo 6 decimales
   * - Eliminar ceros innecesarios al final (3.140000 → 3.14)
   */
  String _formatResult(double result) {
    // Si es número entero, mostrar sin decimales
    if (result == result.truncateToDouble()) {
      return result.truncate().toString();
    }
    
    // Para decimales: limitar a 6 decimales y limpiar ceros finales
    return result.toStringAsFixed(6)           // Máximo 6 decimales
        .replaceAll(RegExp(r'0+$'), '')        // Eliminar ceros al final
        .replaceAll(RegExp(r'\.$'), '');       // Eliminar punto solo si no hay decimales
  }

  // =============================================
  // MÉTODO: CAMBIAR SIGNO (+/-)
  // =============================================
  
  /**
   * toggleSign - Cambia entre positivo y negativo
   * 
   * Ejemplos:
   * - 5 → -5
   * - -3 → 3
   * - 0 → no hace nada (el cero no tiene signo)
   */
  void toggleSign() {
    if (_hasError) return;
    
    if (_currentInput != '0') {
      if (_currentInput.startsWith('-')) {
        // Si es negativo, quitar el signo -
        _currentInput = _currentInput.substring(1);
      } else {
        // Si es positivo, agregar signo -
        _currentInput = '-$_currentInput';
      }
    }
  }

  // =============================================
  // MÉTODO: ELIMINAR ÚLTIMO DÍGITO (BACKSPACE)
  // =============================================
  
  /**
   * deleteLast - Elimina el último dígito ingresado
   * 
   * Comportamiento:
   * - Si hay error, resetea completamente
   * - Si queda un solo dígito, vuelve a cero
   * - Ejemplo: "123" → "12" → "1" → "0"
   */
  void deleteLast() {
    if (_hasError) {
      reset();
      return;
    }

    if (_currentInput.length > 1) {
      // Eliminar último carácter
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
    } else {
      // Si solo queda un dígito, volver a cero
      _currentInput = '0';
    }
  }

  // =============================================
  // MÉTODO: LIMPIAR ENTRADA ACTUAL (CE)
  // =============================================
  
  /**
   * clearEntry - Limpia solo la entrada actual
   * 
   * Diferencia con reset():
   * - reset(): Limpia TODO (operación pendiente, memoria)
   * - clearEntry(): Solo limpia el número actual, mantiene operación
   * 
   * Ejemplo: 5 + 3 [CE] → 5 + 0 (puedes seguir con la operación)
   */
  void clearEntry() {
    if (_hasError) {
      reset(); // Si hay error, limpiar todo
    } else {
      _currentInput = '0'; // Solo limpiar entrada actual
    }
  }
}

/**
 * RESUMEN DE LA LÓGICA DE LA CALCULADORA:
 * 
 * 🧮 OPERACIONES SOPORTADAS:
 *    - Suma (+), Resta (-), Multiplicación (×), División (÷), Módulo (%)
 * 
 * 🔒 MANEJO DE ERRORES:
 *    - División por cero → Error específico
 *    - Cualquier excepción → Error genérico
 *    - Estado de error bloquea operaciones hasta reset
 * 
 * ⚡ CARACTERÍSTICAS INTELIGENTES:
 *    - Cadena automática de operaciones: 5 + 3 × 2 = 16 (no 11)
 *    - Formateo inteligente de decimales
 *    - Prevención de entradas inválidas
 *    - Límite de longitud para evitar desbordamiento
 * 
 * 🔄 ESTADOS DE LA CALCULADORA:
 *    1. Inactiva: _operation vacía, lista para primer número
 *    2. Esperando segundo número: _operation llena, _shouldResetInput true
 *    3. Mostrando resultado: después de calcular, lista para nueva operación
 *    4. Estado de error: bloqueada hasta reset
 */

/**
 * EJEMPLO DE FLUJO DE USO:
 * 
 * Usuario presiona: 5 + 3 × 2 =
 * 
 * 1. addDigit('5')     → _currentInput = '5'
 * 2. setOperation('+') → _previousInput = '5', _operation = '+'
 * 3. addDigit('3')     → _currentInput = '3'
 * 4. setOperation('×') → calculate() → 5+3=8 → _currentInput = '8'
 * 5. addDigit('2')     → _currentInput = '2'  
 * 6. calculate()       → 8×2=16 → _currentInput = '16'
 * 
 * Resultado final: 16 (no 11 porque calcula 5+3 primero)
 */
