import 'age_gate_storage.dart';

class AgeGateController {
  final AgeGateStorage _storage;

  AgeGateController(this._storage);

  Future<bool> shouldShowGate() async {
    final confirmed = await _storage.isAdultConfirmed();
    return !confirmed;
  }

  Future<void> confirmAdult() async {
    await _storage.confirmAdult();
  }
}
