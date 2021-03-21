import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teste_app/src/evento.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference collectionReference = Firestore.instance.collection("eventos");

  Future updateEvento(Evento evento) async {
    return await collectionReference.document(uid).setData({
      "nome": evento.getNome,
      "descricao": evento.getDescricao,
      "local": GeoPoint(evento.getLocal.getLatLng().latitude, evento.getLocal.getLatLng().longitude),
      "date": evento.getDateTime,
      "feriado": evento.isFeriado
    });
  }

  Future<List<DocumentSnapshot>> getEventos() async {
    QuerySnapshot resultado = await collectionReference.getDocuments();
    return resultado.documents;
  }

  Future<DocumentSnapshot> getEvento(String id) async {
    DocumentSnapshot resultado = await collectionReference.document(id).get();
    return resultado;

    //   then(doc => {
    //   if (!doc.exists) {
    //     console.log('No such document!');
    //   } else {
    //     console.log('Document data:', doc.data());
    //   }
    // })
    // .catch(err => {
    //   console.log('Error getting document', err);
    // });
  }
}
