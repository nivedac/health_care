import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

class OfflineBannerWrapper extends StatefulWidget {
  final Widget? child;

  const OfflineBannerWrapper({super.key, required this.child});

  @override
  State<OfflineBannerWrapper> createState() => _OfflineBannerWrapperState();
}

class _OfflineBannerWrapperState extends State<OfflineBannerWrapper> {
  late final ConnectivityService _connectivityService;

  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();
    _connectivityService.initialize();
    _connectivityService.addListener(_onConnectivityChanged);
  }

  void _onConnectivityChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _connectivityService.removeListener(_onConnectivityChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.child != null)
          Expanded(child: widget.child!),
        if (_connectivityService.isOffline)
          Material(
            elevation: 8,
            color: Theme.of(context).colorScheme.error,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 8,
                bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 8,
                left: 16,
                right: 16,
              ),
              child: const Text(
                'No Internet Connection. Working Offline.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}
