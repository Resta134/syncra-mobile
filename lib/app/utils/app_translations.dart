import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'id_ID': {
          'profile': 'Profil',
          'personal_info': 'Informasi Personal',
          'full_name': 'Nama Lengkap',
          'phone': 'No Telepon',
          'edit_profile': 'Edit Profil',
          'security_setting': 'Keamanan & Pengaturan',
          'change_password': 'Ubah Password',
          'language': 'Bahasa',
          'logout': 'Keluar',
          'verification_req': 'Butuh Verifikasi',
          'verified': 'Terverifikasi (Siap Event)',
          'save': 'Simpan',
          'cancel': 'Batal',
        },
        'en_US': {
          'profile': 'Profile',
          'personal_info': 'Personal Information',
          'full_name': 'Full Name',
          'phone': 'Phone Number',
          'edit_profile': 'Edit Profile',
          'security_setting': 'Security & Setting',
          'change_password': 'Change Password',
          'language': 'Language',
          'logout': 'Sign Out',
          'verification_req': 'Verification required',
          'verified': 'Verified (Ready for Event)',
          'save': 'Save',
          'cancel': 'Cancel',
        }
      };
}