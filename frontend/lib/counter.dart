import 'package:agent_dart/agent_dart.dart';

abstract class CounterMethod {
  static const increment = "increment";
  static const getValue = "getValue";

  static final Service idl = IDL.Service({
    getValue: IDL.Func([], [IDL.Nat], ['query']),
    increment: IDL.Func([], [], []),
  });
}

class Counter {
  AgentFactory? _agentFactory;
  CanisterActor? get actor => _agentFactory?.actor;

  final String canisterId;
  final String url;

  Counter({required this.canisterId, required this.url});

  Future<void> setAgent({
    String? newCanisterId,
    Service? newIdl,
    String? newUrl,
    Identity? newIdentity,
    bool? debug,
  }) async {
    _agentFactory = await AgentFactory.createAgent(
      canisterId: newCanisterId ?? canisterId,
      url: newUrl ?? url,
      idl: newIdl ?? CounterMethod.idl,
      identity: newIdentity ?? const AnonymousIdentity(),
      debug: debug ?? true,
    );
  }

  Future<void> increment() async {
    try {
      final incrementFunc = actor?.getFunc(CounterMethod.increment);
      if (incrementFunc == null) throw Exception('Increment function not found');
      await incrementFunc([]);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getValue() async {
    try {
      final getValueFunc = actor?.getFunc(CounterMethod.getValue);
      if (getValueFunc == null) throw Exception('GetValue function not found');
      final res = await getValueFunc([]);
      if (res != null) {
        return (res as BigInt).toInt();
      }
      throw "Cannot get count, got $res";
    } catch (e) {
      rethrow;
    }
  }
}