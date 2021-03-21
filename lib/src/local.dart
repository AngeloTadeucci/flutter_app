import 'package:google_maps_flutter/google_maps_flutter.dart';

class Local {
  LatLng _latLng;
  String _nome;

  Local(this._latLng, this._nome);

  void setlatLng(LatLng x) => this._latLng = x;
  void setNome(String x) => this._nome = x;

  LatLng getLatLng() => this._latLng;
  String getNome() => this._nome;
}
