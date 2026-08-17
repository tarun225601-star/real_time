import 'package:real_time/controllers/calculator_controller.dart';

abstract class CalculatorModel {
  String calculate(String expression);
}

class CalculatorModelImpl implements CalculatorModel {
  final CalculatorController _calculatorController;

  CalculatorModelImpl(this._calculatorController);

  @override
  String calculate(String expression) {
    return _calculatorController.calculate(expression);
  }
}