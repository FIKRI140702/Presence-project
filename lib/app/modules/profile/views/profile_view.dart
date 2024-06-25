import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.Streamuser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic> user = snapshot.data!.data()!;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          "https://ui-avatars.com/api/?name=${user['name']}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "${user['name'].toString().toUpperCase()}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${user['email']}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  onTap: () =>
                      Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                  leading: const Icon(Icons.person),
                  title: const Text("Update Profile"),
                ),
                ListTile(
                  onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                  leading: const Icon(Icons.vpn_key),
                  title: const Text("Update Password"),
                ),
                if (user["role"] == "admin")
                  ListTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                    leading: const Icon(Icons.person_add),
                    title: const Text("Add Pegawai"),
                  ),
                ListTile(
                  onTap: () => controller.logout(),
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("Tidak dapat memuat data user."),
            );
          }
        },
      ),
    );
  }
}