import 'package:connectivity_plus/connectivity_plus.dart';

const String SERVER_FAILURE_MESSAGE = 'Zip code does not exist';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The zip code must be a positive integer and 5 digits long.';

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => Future.value(connectionChecker
      .checkConnectivity()
      .then((value) => value != ConnectivityResult.none));
}

abstract class NetworkInfo {
  Future<bool> get isConnected;
}
