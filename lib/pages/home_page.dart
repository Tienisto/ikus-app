import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/favorite_button.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/event_card.dart';
import 'package:ikus_app/components/cards/post_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/popups/channel_popup.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/model/feature.dart';
import 'package:ikus_app/screens/event_screen.dart';
import 'package:ikus_app/screens/post_screen.dart';
import 'package:ikus_app/service/event_service.dart';
import 'package:ikus_app/service/favorite_service.dart';
import 'package:ikus_app/service/post_service.dart';
import 'package:ikus_app/utility/extensions.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/popups.dart';
import 'package:ikus_app/utility/ui.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentEventIndex = 0;
  List<Event> _events;

  @override
  void initState() {
    super.initState();

    _events = EventService.getNextEvents();
  }

  @override
  Widget build(BuildContext context) {

    List<Feature> favorites = FavoriteService.getFavorites();
    double width = min(MediaQuery.of(context).size.width, MainListView.MAX_WIDTH);
    double favoriteMargin = favorites.length <= 3 ? 20 : 10;
    double favoriteFontSize = favorites.length <= 3 ? 14 : 12;
    double favoriteWidth = (width - favoriteMargin * (favorites.length - 1) - OvguPixels.mainScreenPadding.horizontal) / favorites.length;

    return SafeArea(
      child: MainListView(
        children: [
          if (favorites.isNotEmpty)
            SizedBox(height: 30),
          if (favorites.isNotEmpty)
            Padding(
              padding: OvguPixels.mainScreenPadding,
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: favorites.map((Feature feature) {
                    return FavoriteButton(
                        icon: feature.icon,
                        text: feature.name,
                        width: favoriteWidth,
                        fontSize: favoriteFontSize,
                        callback: () {
                          pushScreen(context, () => feature.widget);
                        }
                    );
                  }).toList(),
                ),
              ),
            ),
          SizedBox(height: 30),
          if (_events.isNotEmpty)
            ...[
              Padding(
                padding: OvguPixels.mainScreenPadding,
                child: IconText(
                  size: OvguPixels.headerSize,
                  distance: OvguPixels.headerDistance,
                  icon: Icons.today,
                  text: t.main.home.nextEvents,
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
                items: _events.map((event) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: EventCard(event: event, callback: () {
                          pushScreen(context, () => EventScreen(event));
                        }),
                      );
                    },
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _events.mapIndexed((event, index) {
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
                SizedBox(
                  width: 60,
                  child: OvguButton(
                    flat: true,
                    callback: () {
                      List<Channel> channels = PostService.getChannels();
                      List<Channel> selected = PostService.getSubscribed();
                      Popups.generic(
                          context: context,
                          height: ChannelPopup.calculateHeight(context),
                          body: ChannelPopup(
                            available: channels,
                            selected: selected,
                            callback: (channel, selected) async {
                              if (selected)
                                await PostService.subscribe(channel);
                              else
                                await PostService.unsubscribe(channel);
                              setState(() {});
                            },
                          )
                      );
                    },
                    child: Icon(Icons.filter_list),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          ...PostService.getPosts().map((post) => Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: PostCard(post: post, callback: () {
              pushScreen(context, () => PostScreen(post));
            }),
          )),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
