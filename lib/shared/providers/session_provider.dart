import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/ambience.dart';

/// Possible states for the player session.
enum SessionState { idle, playing, paused, completed }

/// Manages the active meditation session: timer, audio, and state.
class SessionProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // ── Session State ──
  Ambience? _currentAmbience;
  SessionState _sessionState = SessionState.idle;
  int _totalDurationSeconds = 0;
  int _elapsedSeconds = 0;
  Timer? _timer;

  // ── Getters ──
  Ambience? get currentAmbience => _currentAmbience;
  SessionState get sessionState => _sessionState;
  int get totalDurationSeconds => _totalDurationSeconds;
  int get elapsedSeconds => _elapsedSeconds;
  int get remainingSeconds => _totalDurationSeconds - _elapsedSeconds;
  bool get isActive =>
      _sessionState == SessionState.playing ||
      _sessionState == SessionState.paused;
  bool get isPlaying => _sessionState == SessionState.playing;

  double get progress {
    if (_totalDurationSeconds == 0) return 0;
    return _elapsedSeconds / _totalDurationSeconds;
  }

  String get elapsedFormatted => _formatTime(_elapsedSeconds);
  String get remainingFormatted => _formatTime(remainingSeconds);
  String get totalFormatted => _formatTime(_totalDurationSeconds);

  // ── Start Session ──
  Future<void> startSession(Ambience ambience) async {
    _currentAmbience = ambience;
    _totalDurationSeconds = ambience.duration;
    _elapsedSeconds = 0;
    _sessionState = SessionState.playing;
    notifyListeners();

    // Try to load and play audio
    try {
      await _audioPlayer.setAsset('assets/audio/${ambience.audioFile}');
      _audioPlayer.setLoopMode(LoopMode.all);
      _audioPlayer.play();
    } catch (e) {
      // Audio file may not exist — session still works via timer
      debugPrint('Audio not available: $e');
    }

    _startTimer();
  }

  // ── Play / Pause ──
  void togglePlayPause() {
    if (_sessionState == SessionState.playing) {
      _sessionState = SessionState.paused;
      _timer?.cancel();
      _audioPlayer.pause();
    } else if (_sessionState == SessionState.paused) {
      _sessionState = SessionState.playing;
      _audioPlayer.play();
      _startTimer();
    }
    notifyListeners();
  }

  // ── End Session ──
  Future<void> endSession() async {
    _timer?.cancel();
    _sessionState = SessionState.completed;
    await _audioPlayer.stop();
    notifyListeners();
  }

  // ── Reset (after reflection) ──
  void resetSession() {
    _timer?.cancel();
    _currentAmbience = null;
    _sessionState = SessionState.idle;
    _totalDurationSeconds = 0;
    _elapsedSeconds = 0;
    try {
      _audioPlayer.stop();
    } catch (_) {}
    notifyListeners();
  }

  // ── Timer Logic ──
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      if (_elapsedSeconds >= _totalDurationSeconds) {
        endSession();
      } else {
        notifyListeners();
      }
    });
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
