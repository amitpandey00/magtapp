import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/network/network_info.dart';

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(Connectivity());
});

final networkStatusProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.asyncMap((result) async {
    return result != ConnectivityResult.none;
  });
});
