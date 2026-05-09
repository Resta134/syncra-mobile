import 'package:get/get.dart';

import '../modules/QA/bindings/qa_binding.dart';
import '../modules/QA/views/qa_view.dart';
import '../modules/QA_speak/bindings/q_a_speak_binding.dart';
import '../modules/QA_speak/views/q_a_speak_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/dashboard_gatekeeper/bindings/dashboard_gatekeeper_binding.dart';
import '../modules/dashboard_gatekeeper/views/dashboard_gatekeeper_view.dart';
import '../modules/dashboard_mod/bindings/dashboard_mod_binding.dart';
import '../modules/dashboard_mod/views/dashboard_mod_view.dart';
import '../modules/dashboard_speak/bindings/dashboard_speak_binding.dart';
import '../modules/dashboard_speak/views/dashboard_speak_view.dart';
import '../modules/event_detail/bindings/event_detail_binding.dart';
import '../modules/event_detail/views/event_detail_view.dart';
import '../modules/events/bindings/events_binding.dart';
import '../modules/events/views/events_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/live/bindings/live_binding.dart';
import '../modules/live/views/live_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/notifikasi/bindings/notifikasi_binding.dart';
import '../modules/notifikasi/views/notifikasi_view.dart';
import '../modules/present_speak/bindings/present_speaker_binding.dart';
import '../modules/present_speak/views/present_speaker_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/ticket/bindings/ticket_binding.dart';
import '../modules/ticket/views/ticket_view.dart';
import '../modules/transcript/bindings/transcript_binding.dart';
import '../modules/transcript/views/transcript_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
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
    GetPage(
      name: _Paths.QA,
      page: () => const QaView(),
      binding: QaBinding(),
    ),
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
  ];
}
