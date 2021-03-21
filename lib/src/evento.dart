import 'package:flutter/cupertino.dart';

import 'contato.dart';
import 'local.dart';

class Evento {
  String nome;
  String descricao;
  Local local;
  List<Contato> convidados;
  DateTime dateTime;
  Icon _icone;
  bool _feriado = false;

  Evento(this.nome, this.dateTime, {this.convidados, this.descricao, this.local});
  Evento.feriado(String nome, {DateTime data}) {
    this.dateTime = data;
    this.nome = nome;
    this._feriado = true;
  }

  set setNome(String x) => this.nome = x;
  set setDescricao(String x) => this.descricao = x;
  set setLocal(Local x) => this.local = x;
  set setConvidados(List x) => this.convidados = x;
  set setDateTime(DateTime x) => this.dateTime = x;
  set setIcone(Icon x) => this._icone = x;

  String get getNome => this.nome;
  String get getDescricao => this.descricao;
  Local get getLocal => this.local;
  List<Contato> get getConvidados => this.convidados;
  DateTime get getDateTime => this.dateTime;
  Icon get getIcone => this._icone;
  bool get isFeriado => this._feriado;

  @override
  String toString() {
    return this.nome;
  }
}
