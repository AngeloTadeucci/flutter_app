import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculadoraBits extends StatefulWidget {
  @override
  CalculadoraBitsState createState() => CalculadoraBitsState();
}

class CalculadoraBitsState extends State<CalculadoraBits> {
  final _formKey = GlobalKey<FormState>();

  var _valorController = TextEditingController();
  var _base1Controller = TextEditingController();
  var _base2Controller = TextEditingController();

  FocusNode _valorFocus;
  FocusNode _base1Focus;
  FocusNode _base2Focus;

  bool _switchValue = false;
  void _onChangedSwitch(bool value) => {setState(() => _switchValue = value), txtField.text = ""};
  var txtField = TextEditingController();

  @override
  void initState() {
    super.initState();

    _valorFocus = FocusNode();
    _base1Focus = FocusNode();
    _base2Focus = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => _valorFocus.requestFocus());
  }

  @override
  void dispose() {
    _valorFocus.dispose();
    _base1Focus.dispose();
    _base2Focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(),
            TextFormField(
              controller: _valorController,
              focusNode: _valorFocus,
              inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter(RegExp("[A-Fa-f0-9]"))],
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                _fieldFocusChange(context, _valorFocus, _base1Focus);
              },
              decoration: InputDecoration(
                  hintText: "Número a ser transformado",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.blue))),
              validator: (value) {
                if (value.isEmpty) {
                  _valorFocus.requestFocus();
                  return "Porfavor coloque algum número!";
                }
                return null;
              },
            ),
            Divider(),
            TextFormField(
              controller: _base1Controller,
              focusNode: _base1Focus,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                _fieldFocusChange(context, _base1Focus, _base2Focus);
              },
              decoration: InputDecoration(
                  hintText: "Base do número a ser transformado",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.blue))),
              validator: (value) {
                if (value.isEmpty) {
                  _base1Focus.requestFocus();
                  return "Porfavor coloque algum número!";
                }
                return null;
              },
            ),
            Divider(),
            TextFormField(
              controller: _base2Controller,
              textInputAction: TextInputAction.done,
              focusNode: _base2Focus,
              onFieldSubmitted: (value) {
                _base2Focus.unfocus();
                if (_formKey.currentState.validate()) {
                  if (_switchValue) {
                    txtField.text = calcularBase(
                        _valorController.text.toUpperCase().toString().trim(),
                        _base1Controller.text.toUpperCase().toString().trim(),
                        _base2Controller.text.toUpperCase().toString().trim());
                  } else {
                    _showSnackBar(context, _valorController, _base1Controller, _base2Controller);
                  }
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "Base desejada para a transformação",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.blue))),
              validator: (value) {
                if (value.isEmpty) {
                  _base2Focus.requestFocus();
                  return "Porfavor coloque algum número!";
                }
                return null;
              },
            ),
            Divider(),
            Row(
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.blue)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      if (_switchValue) {
                        txtField.text = calcularBase(
                            _valorController.text.toUpperCase().toString().trim(),
                            _base1Controller.text.toUpperCase().toString().trim(),
                            _base2Controller.text.toUpperCase().toString().trim());
                      } else {
                        _showSnackBar(context, _valorController, _base1Controller, _base2Controller);
                      }
                    }
                  },
                  child: Text('Calcular'),
                ),
                Spacer(),
                Text("Toast"),
                Switch(
                  value: _switchValue,
                  onChanged: _onChangedSwitch,
                ),
                Text("Text Area")
              ],
            ),
            Container(
              child: _switchValue
                  ? TextField(
                      controller: txtField,
                      maxLines: 3,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.blue))),
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }
}

void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

void _showSnackBar(BuildContext context, var text1, var text2, var text3) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
        content: Text(calcularBase(
            text1.text.toUpperCase().toString().trim(), text2.text.toString().trim(), text3.text.toString().trim()))),
  );
}

String calcularBase(String valor, String getBase1, String getBase2) {
  int base = int.parse(getBase1);
  int base2 = int.parse(getBase2);

  if (base == 1 || base > 16 || base2 == 1 || base2 > 16) {
    return "Não é possível realizar operações com bases menores de 2 ou maiores de 16 (no momento)";
  } else if (valor == "0" || base == 0 || base2 == 0) {
    return "Huh?";
  }

  if ((valor.contains("A") && base < 11) ||
      (valor.contains("B") && base < 12) ||
      (valor.contains("C") && base < 13) ||
      (valor.contains("D") && base < 14) ||
      (valor.contains("E") && base < 15) ||
      (valor.contains("F") && base < 16)) {
    return "O número: " + valor + " não existe na base " + base.toString();
  }

  if (base == base2) {
    return valor;
  }
  if (base != 10 && base2 == 10) {
    return outraBaseParaDecimal(valor.length, valor, base).toString();
  } else if (base == 10 && base2 != 10) {
    // switch (base2) {
    //   case 2:
    //     return int.parse(valor, radix: 10).toRadixString(2);
    //   case 8:
    //     return int.parse(valor, radix: 10).toRadixString(8);
    //   case 16:
    //     return int.parse(valor, radix: 10).toRadixString(16).toUpperCase();
    //   case 3:
    //   case 4:
    //   case 5:
    //   case 6:
    //   case 7:
    //   case 9:
    //   case 11:
    //   case 12:
    //   case 13:
    //   case 14:
    //   case 15:
    return printResultado(int.parse(valor), base2);
    // }
  } else {
    var resultado = outraBaseParaDecimal(valor.length, valor, base).toString();
    // switch (base2) {
    //   case 2:
    //     return int.parse(resultado, radix: 10).toRadixString(2);
    //   case 8:
    //     return int.parse(resultado, radix: 10).toRadixString(8);
    //   case 16:
    //     return int.parse(resultado, radix: 10).toRadixString(16).toUpperCase();
    //   case 3:
    //   case 4:
    //   case 5:
    //   case 6:
    //   case 7:
    //   case 9:
    //   case 11:
    //   case 12:
    //   case 13:
    //   case 14:
    //   case 15:
    return printResultado(int.parse(resultado), base2);
    // }
  }
}

int translateCharacterToDec(var character) {
  switch (character) {
    case "A":
      return 10;
    case "B":
      return 11;
    case "C":
      return 12;
    case "D":
      return 13;
    case "E":
      return 14;
    case "F":
      return 15;
    default:
      return null;
  }
}

String translateDecToCharacter(var x) {
  switch (x) {
    case 10:
      return "A";
    case 11:
      return "B";
    case 12:
      return "C";
    case 13:
      return "D";
    case 14:
      return "E";
    case 15:
      return "F";
    default:
      return null;
  }
}

var resultadoString = "";

void metodoDasDivisoesSucessivas(int resultado, int base) {
  if (resultado > 1) {
    metodoDasDivisoesSucessivas(resultado ~/ base, base);
    int quociente = resultado % base;
    if (quociente > 9) {
      resultadoString += translateDecToCharacter(quociente);
    } else {
      resultadoString += quociente.toString();
    }
  } else {
    resultadoString += resultado.toString();
  }
}

String printResultado(int resultado, int base2) {
  metodoDasDivisoesSucessivas(resultado, base2);
  var temp = resultadoString;
  resultadoString = "";
  return temp;
}

int outraBaseParaDecimal(int n, var valor, int base) {
  int i = 0;
  var resultado = 0;
  while (i < n) {
    var character = valor[i];
    var e = pow(base, n - (i + 1));
    var num;
    if (character == "A" ||
        character == "B" ||
        character == "C" ||
        character == "D" ||
        character == "E" ||
        character == "F") {
      num = translateCharacterToDec(character);
    } else {
      num = int.parse(valor[i]);
    }
    resultado += (num * e);
    i++;
  }
  return resultado;
}
