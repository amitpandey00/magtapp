import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/download_service.dart';
import '../../../../core/network/dio_client.dart';

/// Download Service Provider
final downloadServiceProvider = Provider<DownloadService>((ref) {
  final dio = DioClient().dio;
  return DownloadService(dio);
});

/// Download State
class DownloadState {
  final bool isDownloading;
  final double progress;
  final String? fileName;
  final String? error;

  DownloadState({this.isDownloading = false, this.progress = 0.0, this.fileName, this.error});

  DownloadState copyWith({bool? isDownloading, double? progress, String? fileName, String? error}) {
    return DownloadState(isDownloading: isDownloading ?? this.isDownloading, progress: progress ?? this.progress, fileName: fileName ?? this.fileName, error: error ?? this.error);
  }
}

/// Download State Notifier
class DownloadNotifier extends StateNotifier<DownloadState> {
  DownloadNotifier() : super(DownloadState());

  void startDownload(String fileName) {
    state = state.copyWith(isDownloading: true, progress: 0.0, fileName: fileName, error: null);
  }

  void updateProgress(double progress) {
    state = state.copyWith(progress: progress);
  }

  void completeDownload() {
    state = state.copyWith(isDownloading: false, progress: 100.0);
  }

  void setError(String error) {
    state = state.copyWith(isDownloading: false, error: error);
  }

  void reset() {
    state = DownloadState();
  }
}

/// Download Provider
final downloadProvider = StateNotifierProvider<DownloadNotifier, DownloadState>((ref) {
  return DownloadNotifier();
});
