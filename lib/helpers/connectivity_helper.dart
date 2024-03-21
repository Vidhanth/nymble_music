import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static final instance = ConnectivityHelper();

  late final StreamSubscription _subscription;
  final Connectivity _connectivity = Connectivity();

  Function(bool)? _onChanged;

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void initialize() async {
    _isConnected = _checkIfConnected(await _connectivity.checkConnectivity());
    _subscription = _connectivity.onConnectivityChanged.listen((connectivityResult) {
      _isConnected = _checkIfConnected(connectivityResult);
      _onChanged?.call(_isConnected);
    });
  }

  void setOnConnectivityChanged(Function(bool) onChanged) {
    _onChanged ??= onChanged;
  }

  void resetOnConnectivityChanged(Function(bool) onChanged) {
    _onChanged = null;
  }

  void dispose() {
    _subscription.cancel();
  }

  bool _checkIfConnected(List<ConnectivityResult> connectivityResult) {
    return connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.ethernet);
  }
}
