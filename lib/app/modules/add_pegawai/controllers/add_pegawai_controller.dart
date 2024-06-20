import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void AddPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        final UserCredential credential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (credential.user != null) {
          String uid = credential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
          });

          credential.user!.sendEmailVerification();

          Get.snackbar("Berhasil", "Pegawai berhasil ditambahkan.");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang digunakan terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan",
              "Pegawai sudah ada, Anda tidak dapat menambahkan pegawai dengan akun ini.");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai.");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "NIP, nama, dan email harus diisi.");
    }
  }
}
