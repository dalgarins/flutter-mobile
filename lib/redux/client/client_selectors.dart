import 'package:memoize/memoize.dart';
import 'package:built_collection/built_collection.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:invoiceninja/redux/ui/list_ui_state.dart';

var memoizedClientList = memo3((
    BuiltMap<int, ClientEntity> clientMap,
    BuiltList<int> clientList,
    ListUIState clientListState) => visibleClientsSelector(clientMap, clientList, clientListState)
);

List<int> visibleClientsSelector(
    BuiltMap<int, ClientEntity> clientMap,
    BuiltList<int> clientList,
    ListUIState clientListState) {

  var list = clientList.where((clientId) {
    var client = clientMap[clientId];
    if (! client.matchesStates(clientListState.stateFilters)) {
      return false;
    }
    if (! client.matchesSearch(clientListState.search)) {
      return false;
    }
    return true;
  }).toList();

  list.sort((clientAId, clientBId) {
    var clientA = clientMap[clientAId];
    var clientB = clientMap[clientBId];
    return clientA.compareTo(clientB, clientListState.sortField, clientListState.sortAscending);
  });

  return list;
}