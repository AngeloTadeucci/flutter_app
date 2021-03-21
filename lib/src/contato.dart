class Contato {
  String _nome;
  String _sobreNome;
  String _telefone;
  String _email;
  DateTime _aniversario;

  void setNome(String x) => this._nome = x;
  void setsobreNome(String x) => this._sobreNome = x;
  void setTelefone(String x) => this._telefone = x;
  void setEmail(String x) => this._email = x;
  void setAniversario(DateTime x) => this._aniversario = x;

  String getNome() => this._nome;
  String getsobreNome() => this._sobreNome;
  String getTelefone() => this._telefone;
  String getEmail() => this._email;
  DateTime getAniversario() => this._aniversario;
}
