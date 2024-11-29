import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/faq_group_card.dart';
import 'package:ikus_app/components/cards/faq_result_item.dart';
import 'package:ikus_app/components/inputs/ovgu_text_field.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/post.dart';
import 'package:ikus_app/model/post_group.dart';
import 'package:ikus_app/screens/post_screen.dart';
import 'package:ikus_app/service/faq_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class FAQScreen extends StatefulWidget {

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {

  List<PostGroup> faq = [];

  String query = '';
  late List<Post> pool; // flatten PostGroup
  late List<Post> results;

  @override
  void initState() {
    super.initState();

    faq = FAQService.instance.getFAQ();
    pool = faq.expand((i) => i.posts).toList();
    results = [];
  }

  void updateResults() {
    String queryLowerCase = query.toLowerCase();
    results = pool.where((post) => post.title.toLowerCase().contains(queryLowerCase)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.faq.title),
      ),
      body: MainListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: OvguPixels.mainScreenPadding,
                  child: OvguTextField(
                    hint: t.faq.search,
                    onChange: (value) {
                      setState(() {
                        query = value;
                        updateResults();
                      });
                    },
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),

          if (query.isEmpty)
            // normal state
            ...faq.map((group) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: FAQGroupCard(
                postGroup: group,
                postCallback: (post) {
                  pushScreen(context, () => PostScreen(post));
                },
              ),
            )),
          if (query.isNotEmpty)
            // search state
            ...[
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 10),
                child: Text(t.faq.suggestions, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              ...results.map((post) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: FAQResultItem(
                    post: post,
                    callback: () {
                      pushScreen(context, () => PostScreen(post));
                    },
                  ),
                );
              }).toList(),
              if (results.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 20),
                  child: Text(t.faq.noResults),
                )
            ],
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
