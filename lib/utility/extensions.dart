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