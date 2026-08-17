class CalculatorService {
  String calculate(double firstNumber, double secondNumber, String operation) {
    switch (operation) {
      case '+':
        return (firstNumber + secondNumber).toString();
      case '-':
        return (firstNumber - secondNumber).toString();
      case '*':
        return (firstNumber * secondNumber).toString();
      case '/':
        if (secondNumber == 0) {
          return 'Error: Division by zero';
        }
        return (firstNumber / secondNumber).toString();
      default:
        return 'Error: Invalid operation';
    }
  }
}