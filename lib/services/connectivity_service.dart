import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() {
    return _instance;
  }

  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOffline = false;

  bool get isOffline => _isOffline;

  void initialize() {
    if (_subscription != null) return; // Prevent duplicate listeners

    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _checkStatus(results);
    });

    // Check initial status
    _connectivity.checkConnectivity().then(_checkStatus);
  }

  void _checkStatus(List<ConnectivityResult> results) async {
    final offline = results.every((result) => result == ConnectivityResult.none);
    
    if (_isOffline != offline) {
      _isOffline = offline;
      notifyListeners();
      
      if (_isOffline) {
        // Explicitly disable network for Firestore if needed, 
        // but Firestore handles this automatically usually.
        // await FirebaseFirestore.instance.disableNetwork();
      } else {
        // Trigger sync when back online
        await FirebaseFirestore.instance.enableNetwork();
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
