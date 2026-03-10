import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;
  bool _isChecking = false;
  bool _initialCheckDone = false;

  bool get isConnected => _isConnected;
  bool get isChecking => _isChecking;
  bool get initialCheckDone => _initialCheckDone;

  ConnectivityProvider() {
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    await checkConnectivity();
    _listenToConnectivityChanges();
  }

  // Check current connectivity status
  Future<void> checkConnectivity() async {
    _isChecking = true;
    notifyListeners();

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      _updateConnectionStatus(connectivityResult);
    } catch (e) {
      _isConnected = false;
    } finally {
      _isChecking = false;
      _initialCheckDone = true;
      notifyListeners();
    }
  }

  // Listen to connectivity changes in real-time
  void _listenToConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    // Check if any connection type is available
    final hadConnection = _isConnected;
    
    if (connectivityResults.contains(ConnectivityResult.none)) {
      _isConnected = false;
    } else {
      _isConnected = true;
    }
    
    // Only notify if the status actually changed
    if (hadConnection != _isConnected) {
      notifyListeners();
    }
  }
}