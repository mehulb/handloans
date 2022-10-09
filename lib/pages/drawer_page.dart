import 'package:flutter/material.dart';

enum DrawerTileTapAction {
  syncUp,
  syncDown
}

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key, this.callback}) : super(key: key);

  final callback;

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.indigoAccent,
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white24,
              child: FlutterLogo(size: 36.0),
            ),
            accountName: ElevatedButton(
              onPressed: () {},
              child: const Text("Sign In"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent
              ),
            ),
            accountEmail: const Text(
                "Login to your google account",
                style: TextStyle(
                  color: Colors.white54
                ),
            ),
          ),
          ListTile(
            leading: const Icon(
                Icons.cloud_upload_rounded,
              color: Colors.indigoAccent,
            ),
            title: const Text("Sync Up"),
            onTap: () {
              widget.callback(DrawerTileTapAction.syncUp);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
                Icons.cloud_download_rounded,
              color: Colors.indigoAccent,
            ),
            title: const Text("Sync Down"),
            onTap: () {
              widget.callback(DrawerTileTapAction.syncDown);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          const ListTile(
            trailing: Text(
              "v1.0.1",
              style: TextStyle(
                  color: Colors.grey
              ),
            ),
          )
        ],
      ),
    );
  }
}
