# AIM Application

투자 포트폴리오 관리를 위한 Flutter 애플리케이션

## 📱 프로젝트 소개

AIM Application은 사용자의 투자 포트폴리오를 시각적으로 관리하고 추적할 수 있는 모바일/웹 애플리케이션입니다. 주식, 채권, 현금 등 다양한 자산을 한눈에 확인하고 관리할 수 있습니다.

### 주요 기능
- 📊 포트폴리오 시각화 (파이 차트)
- 💼 자산별 상세 정보 확인
- 📈 실시간 수익률 표시
- 🔐 안전한 로그인/회원가입
- 🌏 한국어 UI 지원

## 🚀 시작하기

### 필요 환경
- Flutter SDK: 3.32.8
- Dart SDK: 호환되는 버전
- 지원 플랫폼: Android, iOS, Web, macOS, Linux, Windows

### 설치 방법

1. **저장소 클론**
```bash
git clone https://github.com/yourusername/aim-application.git
cd aim-application
```

2. **의존성 설치**
```bash
flutter pub get
```

3. **앱 실행**
```bash
# 기본 디바이스에서 실행
flutter run

# 특정 플랫폼에서 실행
flutter run -d chrome    # 웹
flutter run -d macos     # macOS
flutter run -d ios       # iOS (Mac 필요)
```

## 🏗️ 프로젝트 구조

```
lib/
├── core/                      # 핵심 기능
│   ├── injection.dart        # 의존성 주입 설정
│   └── shared_preference.dart # 로컬 저장소 서비스
├── presentation/              # 화면 (MVVM 패턴)
│   ├── splash/               # 스플래시 화면
│   ├── login/                # 로그인 화면
│   ├── sign_up/              # 회원가입 화면
│   ├── main/                 # 메인 포트폴리오 화면
│   └── stock_detail/         # 자산 상세 화면
├── routes/                    # 라우팅 설정
├── ui_packages/              # 재사용 가능한 UI 컴포넌트
│   ├── base/                 # 기본 UI 설정
│   │   ├── spacing.dart     # 간격 컴포넌트
│   │   └── config.dart      # UI 설정
│   └── widgets/              # 커스텀 위젯
│       ├── aim_text_field.dart
│       ├── aim_logo.dart
│       ├── pie_chart.dart
│       └── social_login_button.dart
└── utils/                     # 유틸리티
    └── mock_data.dart        # 목업 데이터

```

## 🎨 아키텍처

### MVVM 패턴
각 화면은 다음 구조를 따릅니다:
- **Screen** (View): UI 렌더링
- **ViewModel**: 비즈니스 로직 처리
- **State**: 불변 상태 관리

### 상태 관리
- **Riverpod**: 상태 관리 라이브러리
- **GetIt**: 의존성 주입
- **GoRouter**: 선언적 라우팅

## 📸 스크린샷

### 주요 화면

| 로그인 | 메인 포트폴리오 | 자산 상세 |
|--------|---------------|-----------|
| 사용자 인증 | 포트폴리오 시각화 | 상세 정보 확인 |

### 화면별 특징

##### 로그인 구현 방법
1. **회원가입 시**: ID와 Password를 SharedPreference에 저장
2. **로그인 시**: 입력한 ID와 Password를 SharedPreference에 저장된 값과 비교
   - 일치하면 로그인 성공 → 메인 페이지로 이동
   - 불일치하면 로그인 실패 → 에러 메시지 표시
3. **자동 로그인**: 앱을 종료 후 다시 실행 시 SharedPreference에 저장된 ID와 Password 값이 있으면 자동으로 메인 페이지로 이동

#### 📊 메인 화면
- 다크 테마 (#2B3038)
- 파이 차트로 자산 비율 표시
- 자산 유형별 그룹화 (주식, 채권, 기타)

#### 📈 자산 상세
- 민트 배경색 (#93D9D9)
- ETF별 상세 정보
- 일일 수익률 표시

## 🛠️ 개발 명령어

```bash
# 정적 분석
flutter analyze

# 테스트 실행
flutter test

# 빌드
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
flutter build macos      # macOS
```

### 핫 리로드
앱 실행 중:
- `r` - 핫 리로드 (상태 유지)
- `R` - 핫 리스타트 (상태 초기화)
- `q` - 종료

## 📝 개발 규칙

### UI 간격
**SizedBox 사용 금지**. 대신 `AimSpacing` 컴포넌트 사용:
```dart
// ❌ 잘못된 사용
SizedBox(height: 20)

// ✅ 올바른 사용
AimSpacing.vert20
```

### 에러 처리
- 비동기 작업 후 `context.mounted` 확인 필수
- GetIt 서비스 접근 전 `isRegistered<T>()` 확인
- SharedPreferences 접근 시 try-catch 사용

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이센스

이 프로젝트는 MIT 라이센스 하에 있습니다.

## 📞 연락처

프로젝트 관련 문의사항이 있으시면 이슈를 등록해주세요.

---

⭐ 이 프로젝트가 도움이 되었다면 Star를 눌러주세요!