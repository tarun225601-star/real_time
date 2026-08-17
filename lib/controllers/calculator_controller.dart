import 'package:calculator_app/models/calculator_model.dart';
import 'package:calculator_app/services/calculator_service.dart';
import 'package:flutter/material.dart';
class CalculatorController with ChangeNotifier {
  CalculatorModel _calculatorModel = CalculatorModel();
  CalculatorService _calculatorService = CalculatorService();
  String? get firstNumber => _calculatorModel.firstNumber;
  String? get secondNumber => _calculatorModel.secondNumber;
  String? get operation => _calculatorModel.operation;
  String? get result => _calculatorModel.result;
  void setFirstNumber(String value) {
    _calculatorModel.firstNumber = value;
    notifyListeners();
  }
  void setSecondNumber(String value) {
    _calculatorModel.secondNumber = value;
    notifyListeners();
  }
  void setOperation(String value) {
    _calculatorModel.operation = value;
    notifyListeners();
  }
  void calculateResult() {
    _calculatorModel.result = _calculatorService.calculate(
      double.parse(_calculatorModel.firstNumber!),
      double.parse(_calculatorModel.secondNumber!),
      _calculatorModel.operation!,
    );
    notifyListeners();
  }
}