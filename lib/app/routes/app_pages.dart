import 'package:get/get.dart';

import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/auth/splash/bindings/splash_binding.dart';
import '../modules/auth/splash/views/splash_view.dart';
import '../modules/auth/verify_otp/bindings/verify_otp_binding.dart';
import '../modules/auth/verify_otp/views/verify_otp_view.dart';
import '../modules/gatekeeper/dashboard_gatekeeper/bindings/dashboard_gatekeeper_binding.dart';
import '../modules/gatekeeper/dashboard_gatekeeper/views/dashboard_gatekeeper_view.dart';
import '../modules/gatekeeper/face_vertivication/bindings/face_vertivication_binding.dart';
import '../modules/gatekeeper/face_vertivication/views/face_vertivication_view.dart';
import '../modules/gatekeeper/qr_scanner/bindings/qr_scanner_binding.dart';
import '../modules/gatekeeper/qr_scanner/views/qr_scanner_view.dart';
import '../modules/gatekeeper/user_validation/bindings/user_validation_binding.dart';
import '../modules/gatekeeper/user_validation/views/user_validation_view.dart';
import '../modules/moderator/QA/bindings/qa_binding.dart';
import '../modules/moderator/QA/views/qa_view.dart';
import '../modules/moderator/dashboard_mod/bindings/dashboard_mod_binding.dart';
import '../modules/moderator/dashboard_mod/views/dashboard_mod_view.dart';
import '../modules/moderator/transcript/bindings/transcript_binding.dart';
import '../modules/moderator/transcript/views/transcript_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';
import '../modules/speaker/QA_speak/bindings/q_a_speak_binding.dart';
import '../modules/speaker/QA_speak/views/q_a_speak_view.dart';
import '../modules/speaker/dashboard_speak/bindings/dashboard_speak_binding.dart';
import '../modules/speaker/dashboard_speak/views/dashboard_speak_view.dart';
import '../modules/speaker/present_speak/bindings/present_speaker_binding.dart';
import '../modules/speaker/present_speak/views/present_speaker_view.dart';
import '../modules/user/dashboard/bindings/dashboard_binding.dart';
import '../modules/user/dashboard/views/dashboard_view.dart';
import '../modules/user/event_detail/bindings/event_detail_binding.dart';
import '../modules/user/event_detail/views/event_detail_view.dart';
import '../modules/user/events/bindings/events_binding.dart';
import '../modules/user/events/views/events_view.dart';
import '../modules/user/faceregistration/bindings/faceregistration_binding.dart';
import '../modules/user/faceregistration/views/faceregistration_view.dart';
import '../modules/user/facescanner/bindings/facescanner_binding.dart';
import '../modules/user/facescanner/views/facescanner_view.dart';
import '../modules/user/history/bindings/history_binding.dart';
import '../modules/user/history/views/history_view.dart';
import '../modules/user/live/bindings/live_binding.dart';
import '../modules/user/live/views/live_view.dart';
import '../modules/user/notifikasi/bindings/notifikasi_binding.dart';
import '../modules/user/notifikasi/views/notifikasi_view.dart';
import '../modules/user/payment/bindings/payment_binding.dart';
import '../modules/user/payment/views/payment_view.dart';
import '../modules/user/ticket/bindings/ticket_binding.dart';
import '../modules/user/ticket/views/ticket_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // static const INITIAL = Routes.LOGIN;
  static const INITIAL = Routes.AUTH_SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.PROFIL,
      page: () => const ProfilView(),
      binding: ProfilBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.EVENTS,
      page: () => const EventsView(),
      binding: EventsBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_DETAIL,
      page: () => const EventDetailView(),
      binding: EventDetailBinding(),
    ),
    GetPage(
      name: _Paths.TICKET,
      page: () => const TicketView(),
      binding: TicketBinding(),
    ),
    GetPage(
      name: _Paths.LIVE,
      page: () => const LiveView(),
      binding: LiveBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFIKASI,
      page: () => const NotifikasiView(),
      binding: NotifikasiBinding(),
    ),
    GetPage(name: _Paths.QA, page: () => const QaView(), binding: QaBinding()),
    GetPage(
      name: _Paths.TRANSCRIPT,
      page: () => const TranscriptView(),
      binding: TranscriptBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_MOD,
      page: () => const DashboardModView(),
      binding: DashboardModBinding(),
    ),
    GetPage(
      name: _Paths.SPEAKER,
      page: () => const PresentSpeakerView(),
      binding: PresentSpeakerBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_SPEAK,
      page: () => const DashboardSpeakView(),
      binding: DashboardSpeakBinding(),
    ),
    GetPage(
      name: _Paths.Q_A_SPEAK,
      page: () => const QASpeakView(),
      binding: QASpeakBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_GATEKEEPER,
      page: () => const DashboardGatekeeperView(),
      binding: DashboardGatekeeperBinding(),
    ),
    GetPage(
      name: _Paths.USER_VALIDATION,
      page: () => const UserValidationView(),
      binding: UserValidationBinding(),
    ),
    GetPage(
      name: _Paths.FACE_VERTIVICATION,
      page: () => const FaceVertivicationView(),
      binding: FaceVertivicationBinding(),
    ),
    GetPage(
      name: _Paths.QR_SCANNER,
      page: () => const QrScannerView(),
      binding: QrScannerBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.FACEREGISTRATION,
      page: () => const FaceregistrationView(),
      binding: FaceregistrationBinding(),
    ),
    GetPage(
      name: _Paths.FACESCANNER,
      page: () => const FaceScannerView(),
      binding: FacescannerBinding(),
      children: [
        GetPage(
          name: _Paths.FACESCANNER,
          page: () => const FaceScannerView(),
          binding: FacescannerBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.AUTH_SPLASH,
      page: () => const SplashView(),
      binding: AuthSplashBinding(),
    ),
    GetPage(
      name: _Paths.AUTH_VERIFY_OTP,
      page: () => const VerifyOtpView(),
      binding: AuthVerifyOtpBinding(),
    ),
  ];
}
