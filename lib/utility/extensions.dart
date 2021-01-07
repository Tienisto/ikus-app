extension ExtendedIterable<E> on Iterable<E> {

  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }

  void forEachIndexed(void f(E e, int i)) {
    var i = 0;
    this.forEach((e) => f(e, i++));
  }
}

extension ExtendedDateTime on DateTime {

  bool isSameDay(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }

  bool hasTime() {
    return this.hour != 0 || this.minute != 0;
  }
}