/*
  Represents a sleep.
 */
class Sleep {
  final int id;
  final int start;
  final int end;

  Sleep({this.id, this.start, this.end});

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
    };
  }

  get duration => end - start;
}