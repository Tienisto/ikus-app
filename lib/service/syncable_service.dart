abstract class SyncableService {

  String getName();
  Future<void> sync();
  DateTime getLastUpdate();
}