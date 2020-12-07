import 'package:emojis/emojis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../stream_chat_flutter.dart';

/// Detail screen for a 1:1 chat correspondence
class ChatInfoScreen extends StatefulWidget {
  /// User in consideration
  final User user;

  const ChatInfoScreen({Key key, this.user}) : super(key: key);

  @override
  _ChatInfoScreenState createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends State<ChatInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe6e6e6),
      body: ListView(
        children: [
          _buildUserHeader(),
          SizedBox(
            height: 8.0,
          ),
          _buildOptionListTiles(),
          SizedBox(
            height: 8.0,
          ),
          _buildDeleteListTile(),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: UserAvatar(
                    user: widget.user,
                    constraints: BoxConstraints(
                      maxWidth: 72.0,
                      maxHeight: 72.0,
                    ),
                    borderRadius: BorderRadius.circular(36.0),
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  widget.user.name,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 7.0),
                Text('Online for 5 minutes'),
                SizedBox(height: 15.0),
                _OptionListTile(
                  title: '@user',
                  trailing: Text(widget.user.name),
                  onTap: () {},
                ),
              ],
            ),
            Positioned(
              top: 21,
              left: 16,
              child: InkWell(
                child: StreamSvgIcon.left(),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionListTiles() {
    var channel = StreamChannel.of(context);

    return Column(
      children: [
        // _OptionListTile(
        //   title: 'Notifications',
        //   leading: StreamSvgIcon.Icon_notification(
        //     size: 24.0,
        //     color: Colors.black.withOpacity(0.5),
        //   ),
        //   trailing: CupertinoSwitch(
        //     value: true,
        //     onChanged: (val) {},
        //   ),
        //   onTap: () {},
        // ),
        StreamBuilder<bool>(
            stream: StreamChannel.of(context).channel.isMutedStream,
            builder: (context, snapshot) {
              return _OptionListTile(
                title: 'Mute user',
                leading: StreamSvgIcon.mute(
                  size: 23.0,
                  color: Colors.black.withOpacity(0.5),
                ),
                trailing: snapshot.data == null
                    ? CircularProgressIndicator()
                    : CupertinoSwitch(
                        value: snapshot.data,
                        onChanged: (val) {
                          if (snapshot.data) {
                            channel.channel.unmute();
                          } else {
                            channel.channel.mute();
                          }
                        },
                      ),
                onTap: () {},
              );
            }),
        _OptionListTile(
          title: 'Block User',
          leading: StreamSvgIcon.Icon_user_delete(
            size: 24.0,
            color: Colors.black.withOpacity(0.5),
          ),
          trailing: CupertinoSwitch(
            value: true,
            onChanged: (val) {},
          ),
          onTap: () {},
        ),
        _OptionListTile(
          title: '615 Photos & Videos',
          leading: StreamSvgIcon.pictures(
            size: 32.0,
            color: Colors.black.withOpacity(0.5),
          ),
          trailing: StreamSvgIcon.right(),
          onTap: () {},
        ),
        _OptionListTile(
          title: '8 Files',
          leading: StreamSvgIcon.files(
            size: 32.0,
            color: Colors.black.withOpacity(0.5),
          ),
          trailing: StreamSvgIcon.right(),
          onTap: () {},
        ),
        StreamBuilder<List<Channel>>(
            stream: StreamChat.of(context).client.queryChannels(
              filter: {
                'members': [StreamChat.of(context).user.id, widget.user.id],
              },
            ),
            builder: (context, snapshot) {
              return _OptionListTile(
                title:
                    '${snapshot.data == null ? '0' : snapshot.data.length} Shared groups',
                leading: StreamSvgIcon.Icon_group(
                  size: 24.0,
                  color: Colors.black.withOpacity(0.5),
                ),
                trailing: StreamSvgIcon.right(),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => _SharedGroupsScreen(
                              StreamChat.of(context).user, widget.user)));
                },
              );
            }),
      ],
    );
  }

  Widget _buildDeleteListTile() {
    return _OptionListTile(
      title: 'Delete',
      leading: StreamSvgIcon.delete(
        color: Colors.red,
        size: 20.0,
      ),
      onTap: () {
        _showDeleteDialog();
      },
      titleColor: Colors.red,
    );
  }

  void _showDeleteDialog() {
    var channel = StreamChannel.of(context).channel;

    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        )),
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 26.0,
              ),
              StreamSvgIcon.delete(
                color: Colors.red,
              ),
              SizedBox(
                height: 26.0,
              ),
              Text(
                'Delete Conversation',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(
                height: 7.0,
              ),
              Text('Are you sure you want to delete this conversation?'),
              SizedBox(
                height: 36.0,
              ),
              Container(
                color: Color(0xffe6e6e6),
                height: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.w400),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'DELETE',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w400),
                    ),
                    onPressed: () {
                      channel.delete().then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}

class _OptionListTile extends StatelessWidget {
  final String title;
  final StreamSvgIcon leading;
  final Widget trailing;
  final VoidCallback onTap;
  final Color titleColor;

  _OptionListTile({
    this.title,
    this.leading,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Color(0xffe6e6e6),
          height: 2.0,
        ),
        Material(
          color: Colors.white,
          child: Container(
            height: 56.0,
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  if (leading != null)
                    Expanded(
                      child: Center(child: leading),
                    ),
                  if (leading == null)
                    SizedBox(
                      width: 16.0,
                    ),
                  Expanded(
                      flex: 4,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: titleColor),
                      )),
                  Expanded(
                    child: Center(
                      child: trailing ?? Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SharedGroupsScreen extends StatefulWidget {
  final User mainUser;
  final User otherUser;

  _SharedGroupsScreen(this.mainUser, this.otherUser);

  @override
  __SharedGroupsScreenState createState() => __SharedGroupsScreenState();
}

class __SharedGroupsScreenState extends State<_SharedGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    var chat = StreamChat.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Shared Groups',
          style: TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        leading: Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: StreamSvgIcon.left(
                color: Colors.black,
                size: 24.0,
              ),
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
        backgroundColor: StreamChatTheme.of(context).primaryColor,
      ),
      body: StreamBuilder<List<Channel>>(
        stream: chat.client.queryChannels(
          filter: {
            'members': [widget.mainUser.id, widget.otherUser.id],
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, position) {
              return StreamChannel(
                channel: snapshot.data[position],
                child: ChannelPreview(
                  channel: snapshot.data[position],
                  onTap: (val) {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}