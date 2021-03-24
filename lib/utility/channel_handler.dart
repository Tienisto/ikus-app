import 'package:ikus_app/model/channel.dart';

typedef int IdSelector<T>(T item);

class ChannelHandler<T> {

  List<Channel> _available;
  List<Channel> _subscribed;

  ChannelHandler(List<Channel> available, List<Channel> subscribed)
      : _available = available, _subscribed = subscribed;

  /// returns a new list which contains only items whose channel is subscribed
  List<T> onlySubscribed(List<T> items, IdSelector<T> selector) {
    return items.where((item) => _subscribed.any((channel) => selector(item) == channel.id)).toList();
  }

  List<Channel> getAvailable() {
    return _available;
  }

  List<Channel> getSubscribed() {
    return _subscribed;
  }

  void unsubscribe(Channel channel) async {
    _subscribed = _subscribed.where((subscribed) => subscribed.id != channel.id).toList();
  }

  void subscribe(Channel channel) async {
    if (_subscribed.any((subscribed) => subscribed.id == channel.id))
      return;

    _subscribed.add(channel);
  }
}