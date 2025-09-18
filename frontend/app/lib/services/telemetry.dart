import 'dart:async';

class TelemetryEvent {
  final double? flowRateLpm;
  final int? tankLevelPercent;

  const TelemetryEvent({this.flowRateLpm, this.tankLevelPercent});
}

class TelemetryService {
  TelemetryService._internal();
  static final TelemetryService instance = TelemetryService._internal();

  final StreamController<TelemetryEvent> _controller =
      StreamController<TelemetryEvent>.broadcast();

  Stream<TelemetryEvent> get stream => _controller.stream;

  void publish({double? flowRateLpm, int? tankLevelPercent}) {
    _controller.add(TelemetryEvent(
      flowRateLpm: flowRateLpm,
      tankLevelPercent: tankLevelPercent,
    ));
  }

  void dispose() {
    _controller.close();
  }
}


