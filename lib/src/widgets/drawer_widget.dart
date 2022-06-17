import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet/src/services/auth_service.dart';
import 'package:mywallet/src/state/user_state.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserState>().user;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: CachedNetworkImageProvider(
                        user!.photoURL!,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      user.displayName!,
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () => _logout(context),
            color: Colors.red,
            child: const Text('Cerrar sesión'),
          )
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    AuthService.instance.logout();
    context.push('/login');
  }
}
