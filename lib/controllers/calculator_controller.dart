import 'package:flutter/material.dart';

abstract class CalculatorController {
  String get displayText;
  void onButtonPressed(String value);
}

class CalculatorControllerImpl implements CalculatorController {
  String _expression = '';
  String _result = '0';

  @override
  String get displayText => _expression.isEmpty ? _result : _expression;

  @override
  void onButtonPressed(String value) {
    if (value == 'C') {
      _expression = '';
      _result = '0';
    } else if (value == '=') {
      try {
        _result = _evaluateExpression(_expression);
        _expression = '';
      } catch (e) {
        _result = 'Error';
      }
    } else {
      if (_result == '0' || _result == 'Error') {
        _result = '';
      }
      _expression += value;
    }
  }

  // साधारण और सुरक्षित कैलकुलेशन लॉजिक (बिना किसी बाहरी पैकेज के)
  String _evaluateExpression(String expr) {
    try {
      // यदि केवल साधारण नंबर और ऑपरेटर्स हैं
      final sanitized = expr.replaceAll('×', '*').replaceAll('÷', '/');
      // बेसिक जोड़-घटाव/गुणा-भाग के लिए सरल पार्सर या नंबर रिटर्न
      if (sanitized.contains('+')) {
        List<String> parts = sanitized.split('+');
        double res = double.parse(parts[0]) + double.parse(parts[1]);
        return res.toString();
      } else if (sanitized.contains('-')) {
        List<String> parts = sanitized.split('-');
        double res = double.parse(parts[0]) - double.parse(parts[1]);
        return res.toString();
      } else if (sanitized.contains('*')) {
        List<String> parts = sanitized.split('*');
        double res = double.parse(parts[0]) * double.parse(parts[1]);
        return res.toString();
      } else if (sanitized.contains('/')) {
        List<String> parts = sanitized.split('/');
        double res = double.parse(parts[0]) / double.parse(parts[1]);
        return res.toString();
      }
      return expr;
    } catch (_) {
      return 'Error';
    }
  }
}
