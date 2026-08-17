import 'package:flutter/material.dart';
import 'package:calculator_app/models/calculator_model.dart';
import 'package:calculator_app/services/calculator_service.dart';

class CalculatorProvider with ChangeNotifier {
  CalculatorService _calculatorService = CalculatorService();
  CalculatorModel _calculatorModel = CalculatorModel(expression: '', result: '');

  CalculatorModel get calculatorModel => _calculatorModel;

  void calculateExpression(String expression) async {
    final result = await _calculatorService.calculateExpression(expression);
    _calculatorModel = CalculatorModel(expression: expression, result: result);
    notifyListeners();
  }
}