import '../../data/local/dao/analyse_dao.dart';
import '../../data/models/analyse_model.dart';

class AnalyseRepository {
  final AnalyseDao _dao = AnalyseDao();

  Future<List<Analyse>> getAllAnalyses() => _dao.getAll();
  Future<Analyse?> getAnalyseById(int id) => _dao.getById(id);
  Future<List<Analyse>> getAnalysesByCategorie(String categorie) => _dao.getByCategorie(categorie);
  Future<int> addAnalyse(Analyse analyse) => _dao.insert(analyse);
  Future<int> updateAnalyse(Analyse analyse) => _dao.update(analyse);
  Future<int> deleteAnalyse(int id) => _dao.delete(id);
}
