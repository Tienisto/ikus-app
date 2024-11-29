import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/quadratic_button.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/event_card.dart';
import 'package:ikus_app/components/cards/post_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/popups/channel_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/model/feature.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/screens/event_screen.dart';
import 'package:ikus_app/screens/post_screen.dart';
import 'package:ikus_app/service/app_config_service.dart';
import 'package:ikus_app/service/calendar_service.dart';
import 'package:ikus_app/service/news_service.dart';
import 'package:ikus_app/utility/extensions.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/popups.dart';
import 'package:ikus_app/utility/ui.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  int _currentEventIndex = 0;
  late List<Feature> _favorites;
  late List<Event> _nextEvents;
  late List<Post> _posts;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  void _updateData() {
    _favorites = AppConfigService.instance.getFavoriteFeatures();
    _nextEvents = CalendarService.instance.getMyNextEvents();
    _posts = NewsService.instance.getPosts();
  }

  @override
  Widget build(BuildContext context) {

    double width = min(MediaQuery.of(context).size.width, OvguPixels.maxWidth);
    double favoriteMargin = _favorites.length <= 3 ? 20 : 10;
    double favoriteFontSize = _favorites.length <= 3 ? 14 : 12;
    double favoriteWidth = (width - favoriteMargin * (_favorites.length - 1) - OvguPixels.mainScreenPadding.horizontal) / _favorites.length;

    return SafeArea(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: OvguColor.primary,
        onRefresh: () async {
          await NewsService.instance.sync(useNetwork: true);
          await CalendarService.instance.sync(useNetwork: true);
          if (mounted) {
            setState(() {
              _updateData();
            });
          }
        },
        child: MainListView(
          children: [
            if (_favorites.isNotEmpty)
              Padding(
                padding: OvguPixels.mainScreenPadding.copyWith(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _favorites.map((Feature feature) {
                    return QuadraticButton(
                        icon: feature.icon,
                        text: feature.shortName,
                        width: favoriteWidth,
                        fontSize: favoriteFontSize,
                        callback: () async {
                          await feature.onOpen(context);
                          setState(() {
                            _updateData();
                          });
                        }
                    );
                  }).toList(),
                ),
              ),
            SizedBox(height: 30),
            if (_nextEvents.isNotEmpty)
              ...[
                Padding(
                  padding: OvguPixels.mainScreenPadding,
                  child: IconText(
                    size: OvguPixels.headerSize,
                    distance: OvguPixels.headerDistance,
                    icon: Icons.today,
                    text: t.main.home.nextEvents(n: _nextEvents.length),
                  ),
                ),
                SizedBox(height: 20),
                CarouselSlider(
                  options: CarouselOptions(
                      height: 100,
                      viewportFraction: 1,
                      autoPlay: true,
                      onPageChanged: (index, _) {
                        setState(() {
                          _currentEventIndex = index;
                        });
                      }
                  ),
                  items: _nextEvents.map((event) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: EventCard(event: event, callback: () async {
                            await pushScreen(context, () => EventScreen(event));
                            setState(() {
                              _updateData();
                            });
                          }),
                        );
                      },
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _nextEvents.mapIndexed((event, index) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentEventIndex == index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
              ],
            Padding(
              padding: OvguPixels.mainScreenPadding,
              child: Row(
                children: [
                  Expanded(
                    child: IconText(
                      size: OvguPixels.headerSize,
                      distance: OvguPixels.headerDistance,
                      icon: Icons.announcement,
                      text: t.main.home.news,
                    ),
                  ),
                  OvguButton(
                    flat: true,
                    callback: () {
                      List<Channel> channels = NewsService.instance.getChannels();
                      List<Channel> selected = NewsService.instance.getSubscribed();
                      Popups.generic(
                          context: context,
                          height: ChannelPopup.calculateHeight(context),
                          body: ChannelPopup(
                            available: channels,
                            selected: selected,
                            callback: (channel, selected) async {
                              if (selected)
                                NewsService.instance.subscribe(channel);
                              else
                                NewsService.instance.unsubscribe(channel);
                              setState(() {
                                _updateData();
                              });
                            },
                          )
                      );
                    },
                    child: Icon(Icons.filter_list),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            ..._posts.map((post) => Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: PostCard(
                post: post,
                callback: () {
                  pushScreen(context, () => PostScreen(post));
                }
              ),
            )),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
