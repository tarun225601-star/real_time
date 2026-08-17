import 'package:real_time/models/calculator_model.dart';

abstract class CalculatorController {
  String calculate(String expression);
}

class CalculatorControllerImpl implements CalculatorController {
  @override
  String calculate(String expression) {
    try {
      return (eval(expression)).toString();
    } catch (e) {
      return 'Error';
    }
  }
}

class CalculatorController extends CalculatorControllerImpl implements CalculatorController {
  @override
  String calculate(String expression) {
    return super.calculate(expression);
  }
}