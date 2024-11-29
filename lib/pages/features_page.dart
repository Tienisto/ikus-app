import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/feature_button.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/info_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/feature.dart';
import 'package:ikus_app/service/app_config_service.dart';
import 'package:ikus_app/utility/ui.dart';

class FeaturesPage extends StatefulWidget {
  @override
  _FeaturesPageState createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {

  late List<Feature> features;

  @override
  void initState() {
    super.initState();
    features = AppConfigService.instance.getFeatures();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MainListView(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: IconText(
              size: OvguPixels.headerSize,
              distance: OvguPixels.headerDistance,
              icon: Icons.apps,
              text: t.main.features.title,
            ),
          ),
          SizedBox(height: 30),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: FeatureButton(
              feature: feature,
              favorite: AppConfigService.instance.isFavorite(feature),
              selectCallback: () async {
                await feature.onOpen(context);
              },
              favoriteCallback: () {
                setState(() {
                  AppConfigService.instance.toggleFavorite(feature);
                  features = AppConfigService.instance.getFeatures();
                });
              },
            ),
          )),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InfoText(t.main.features.info)
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
