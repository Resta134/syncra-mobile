import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'id_ID': {
          // Profil & Umum
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

          // Bottom Nav
          'nav_home': 'Beranda',
          'nav_tickets': 'Tiket',
          'nav_profile': 'Profil',
          'nav_peserta': 'Peserta',
          'nav_qa': 'Tanya Jawab',

          // Login Screen
          'login_welcome_title': 'Selamat Datang!',
          'login_welcome_subtitle': 'Silakan masuk ke akun Syncro Anda',
          'login_email_hint': 'Email',
          'login_password_hint': 'Password',
          'login_forgot_password': 'Lupa Password?',
          'login_btn': 'Masuk',
          'login_or_with': 'Atau masuk dengan',
          'login_google_btn': 'Masuk dengan Google',
          'login_dont_have_account': 'Belum punya akun? ',
          'login_register_here': 'Buat Akun di sini',

          // Register Screen
          'register_title': 'Buat Akun Baru',
          'register_subtitle': 'Daftarkan diri Anda untuk bergabung ke Syncro',
          'register_full_name_hint': 'Nama Lengkap',
          'register_btn': 'Daftar',
          'register_or_with': 'Atau daftar dengan',
          'register_google_btn': 'Daftar dengan Google',
          'register_already_have_account': 'Sudah punya akun? ',
          'register_login_here': 'Masuk di sini',

          // Forgot Password Screen
          'fp_appbar_title': 'Lupa Password',
          'fp_header_reset_pass': 'Atur Ulang Password',
          'fp_header_enter_code': 'Masukkan Kode Reset',
          'fp_desc_reset_pass': 'Masukkan alamat email Anda untuk mendapatkan kode reset / tautan ubah password.',
          'fp_desc_enter_code': 'Kami telah mengirimkan kode OTP / tautan reset ke email Anda. Silakan masukkan kode tersebut beserta password baru Anda di bawah.',
          'fp_email_hint': 'Alamat Email',
          'fp_send_code_btn': 'Kirim Kode Verifikasi',
          'fp_email_fixed_hint': 'Email (tetap)',
          'fp_otp_hint': 'Kode OTP / Token Verifikasi',
          'fp_new_password_hint': 'Password Baru',
          'fp_confirm_new_password_hint': 'Konfirmasi Password Baru',
          'fp_update_password_btn': 'Perbarui Password',
          'fp_resend_email_btn': 'Ganti Email / Kirim Ulang',

          // Dashboard Screen
          'dash_ongoing': 'Sedang Berlangsung',
          'dash_no_live': 'Belum ada event yang sedang live.',
          'dash_upcoming': 'Event Mendatang',
          'dash_see_all': 'Lihat Semua',
          'dash_no_upcoming': 'Belum ada event mendatang.',
        },
        'en_US': {
          // Profil & Umum
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

          // Bottom Nav
          'nav_home': 'Home',
          'nav_tickets': 'Tickets',
          'nav_profile': 'Profile',
          'nav_peserta': 'Participants',
          'nav_qa': 'Q&A',

          // Login Screen
          'login_welcome_title': 'Welcome Back!',
          'login_welcome_subtitle': 'Please log in to your Syncro account',
          'login_email_hint': 'Email',
          'login_password_hint': 'Password',
          'login_forgot_password': 'Forgot Password?',
          'login_btn': 'Log In',
          'login_or_with': 'Or log in with',
          'login_google_btn': 'Sign in with Google',
          'login_dont_have_account': 'Don\'t have an account? ',
          'login_register_here': 'Register here',

          // Register Screen
          'register_title': 'Create New Account',
          'register_subtitle': 'Register yourself to join Syncro',
          'register_full_name_hint': 'Full Name',
          'register_btn': 'Register',
          'register_or_with': 'Or register with',
          'register_google_btn': 'Register with Google',
          'register_already_have_account': 'Already have an account? ',
          'register_login_here': 'Log in here',

          // Forgot Password Screen
          'fp_appbar_title': 'Forgot Password',
          'fp_header_reset_pass': 'Reset Password',
          'fp_header_enter_code': 'Enter Reset Code',
          'fp_desc_reset_pass': 'Enter your email address to receive a password reset code / link.',
          'fp_desc_enter_code': 'We have sent an OTP code / reset link to your email. Please enter the code and your new password below.',
          'fp_email_hint': 'Email Address',
          'fp_send_code_btn': 'Send Verification Code',
          'fp_email_fixed_hint': 'Email (fixed)',
          'fp_otp_hint': 'OTP Code / Verification Token',
          'fp_new_password_hint': 'New Password',
          'fp_confirm_new_password_hint': 'Confirm New Password',
          'fp_update_password_btn': 'Update Password',
          'fp_resend_email_btn': 'Change Email / Resend',

          // Dashboard Screen
          'dash_ongoing': 'Ongoing Events',
          'dash_no_live': 'No events are currently live.',
          'dash_upcoming': 'Upcoming Events',
          'dash_see_all': 'See All',
          'dash_no_upcoming': 'No upcoming events yet.',
        }
      };
}