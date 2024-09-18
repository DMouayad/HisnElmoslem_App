import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hisnelmoslem/src/core/shared/widgets/empty.dart';
import 'package:hisnelmoslem/src/core/utils/volume_button_manager.dart';
import 'package:hisnelmoslem/src/features/settings/data/repository/app_settings_repo.dart';

part 'onboard_state.dart';

class OnboardCubit extends Cubit<OnboardState> {
  final AppSettingsRepo appSettingsRepo;
  final VolumeButtonManager volumeButtonManager;
  PageController pageController = PageController();
  OnboardCubit(this.appSettingsRepo, this.volumeButtonManager)
      : super(OnboardLoadingState()) {
    _init();
  }

  void _init() {
    volumeButtonManager.toggleActivation(activate: true);
    volumeButtonManager.listen(
      onVolumeDownPressed: () {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
      onVolumeUpPressed: () {
        pageController.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
    );

    pageController.addListener(
      () {
        final int index = pageController.page!.round();
        onPageChanged(index);
      },
    );
  }

  ///TODO: Change every release
  List<Empty> get pageData {
    return [
//     const Empty(
//       title: "حصن المسلم الإصدار $appVersion",
//       description: '''
// السلام عليكم أيها المبارك
// أهلا بك في تحديث جديد من حصن المسلم
// قم بسحب الشاشة لتقليب الصفحات
// أو استخدم مفاتيح الصوت لرؤية الميزات الجديدة
// ''',
//     ),
      const Empty(
        title: "الجديد في هذا الإصدار",
        isImage: false,
        icon: Icons.new_releases,
        description: """
- يمكنك الآن التحكم في استخدام الأرقام الهندية من الإعدادات

- التحكم في إبقاء الشاشة نشطة أثناء الذكر من الإعدادات

- تحسين على القائمة الجانبية للواجهة الرئيسية

- تحسين نافذة ضبط التنبيهات

- شاشة إعدادات ألوان مشاركة الذكر كصورة يمكن الوصول إليها الآن من الشريط العلوي بجواز زر المشاركة بدلا من النافذة العائمة
""",
      ),
    ];
  }

  Future start() async {
    if (!appSettingsRepo.isReleaseFirstOpen) {
      emit(OnboardDoneState());
      return;
    }
    emit(
      OnboardLoadedState(
        showSkipBtn: true,
        currentPageIndex: 0,
        pages: pageData,
      ),
    );
  }

  Future onPageChanged(int index) async {
    final state = this.state;
    if (state is! OnboardLoadedState) return;
    emit(state.copyWith(currentPageIndex: index));
  }

  Future done() async {
    await appSettingsRepo.changIsReleaseFirstOpen(value: false);
    volumeButtonManager.dispose();
    emit(OnboardDoneState());
  }

  @override
  Future<void> close() {
    pageController.dispose();
    volumeButtonManager.dispose();
    return super.close();
  }
}
