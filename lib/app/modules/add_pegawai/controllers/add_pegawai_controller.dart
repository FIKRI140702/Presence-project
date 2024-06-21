import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;

        final UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          Get.back(); // tutup dialog
          Get.back(); // back to home
          Get.snackbar("Berhasil", "Berhasil menambahkan pegawai");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang digunakan terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan",
              "Pegawai sudah ada. Kamu tidak dapat menambahkan pegawai dengan email ini");
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Admin tidak dapat login. Password salah!");
        } else {
          // ignore: unnecessary_string_interpolations
          Get.snackbar("Terjadi Kesalahan", "${e.code}");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai.");
      }
    } else {
      Get.snackbar(
          "Terjadi Kesalahan", "Password wajib diisi untuk keperluan validasi");
    }
  }

  void addPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      Get.defaultDialog(
        title: "Validasi Admin",
        content: Column(
          children: [
            const Text("Masukkan password untuk validasi admin!"),
            TextField(
              controller: passAdminC,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () async {
              await prosesAddPegawai();
            },
            child: const Text("ADD PEGAWAI"),
          ),
        ],
      );
    } else {
      Get.snackbar("Terjadi Kesalahan", "NIP, nama, dan email harus diisi.");
    }
  }
}
