/// A run time as it is printed on a readout.
///
/// Minutes and seconds, with hours only once there are any, so a chapter
/// counter stays two fields wide and does not shuffle sideways as it ticks.
/// Set in the mono readout face wherever it is shown, so the Library, the
/// player, and the Now Playing bar all print a time the same way.
String formatPlaybackDuration(Duration duration) {
  final safe = duration.isNegative ? Duration.zero : duration;
  final hours = safe.inHours;
  final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
}
