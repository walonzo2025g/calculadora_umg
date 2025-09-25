class CalculatorModel {
  String _currentInput = '0';
  String _previousInput = '';
  String _operation = '';
  bool _shouldResetInput = false;
  bool _hasError = false;

  String get currentInput => _currentInput;
  String get previousInput => _previousInput;
  String get operation => _operation;
  bool get hasError => _hasError;

  void reset() {
    _currentInput = '0';
    _previousInput = '';
    _operation = '';
    _shouldResetInput = false;
    _hasError = false;
  }

  void addDigit(String digit) {
    if (_hasError) reset();
    
    if (_shouldResetInput) {
      _currentInput = '0';
      _shouldResetInput = false;
    }

    if (_currentInput == '0' && digit != '.') {
      _currentInput = digit;
    } else if (digit == '.' && _currentInput.contains('.')) {
      return; // Evitar múltiples puntos decimales
    } else if (_currentInput.length < 15) { // Limitar longitud
      _currentInput += digit;
    }
  }

  void setOperation(String operation) {
    if (_hasError) return;
    
    if (_operation.isNotEmpty && !_shouldResetInput) {
      calculate();
    }
    
    _previousInput = _currentInput;
    _operation = operation;
    _shouldResetInput = true;
  }

  void calculate() {
    if (_operation.isEmpty || _previousInput.isEmpty || _hasError) return;

    try {
      final num1 = double.parse(_previousInput);
      final num2 = double.parse(_currentInput);
      double result = 0;

      switch (_operation) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '×':
          result = num1 * num2;
          break;
        case '÷':
          if (num2 == 0) {
            _hasError = true;
            _currentInput = 'Error: División por cero';
            return;
          }
          result = num1 / num2;
          break;
        case '%':
          result = num1 % num2;
          break;
      }

      // Formatear el resultado
      _currentInput = _formatResult(result);
      _previousInput = '';
      _operation = '';
      _shouldResetInput = true;
    } catch (e) {
      _hasError = true;
      _currentInput = 'Error';
    }
  }

  String _formatResult(double result) {
    // Mostrar números enteros sin decimales
    if (result == result.truncateToDouble()) {
      return result.truncate().toString();
    }
    
    // Limitar decimales a 6
    return result.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  void toggleSign() {
    if (_hasError) return;
    
    if (_currentInput != '0') {
      if (_currentInput.startsWith('-')) {
        _currentInput = _currentInput.substring(1);
      } else {
        _currentInput = '-$_currentInput';
      }
    }
  }

  void deleteLast() {
    if (_hasError) {
      reset();
      return;
    }

    if (_currentInput.length > 1) {
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
    } else {
      _currentInput = '0';
    }
  }

  void clearEntry() {
    if (_hasError) {
      reset();
    } else {
      _currentInput = '0';
    }
  }
}