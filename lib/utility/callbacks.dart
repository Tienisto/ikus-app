
import 'package:flutter/material.dart';
import 'package:ikus_app/components/ovgu_switch.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/model/post.dart';

typedef void Callback();
typedef void IntCallback(int integer);
typedef void BoolCallback(bool? boolean);
typedef void PostCallback(Post post);
typedef void StringCallback(String string);
typedef void SwitchCallback(SwitchState state);
typedef void EventCallback(Event event);
typedef void MailProgressCallback(int progress, int total);
typedef void AddFutureCallback(FutureCallback callback);
typedef void BackgroundSyncCallback(List<String> services, [String message]);
typedef Future<void> FutureCallback();
typedef Future<void> FutureWithContextCallback(BuildContext context);
typedef Future<void> ChannelBooleanCallback(Channel channel, bool boolean);