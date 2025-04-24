# Kolektt 개발 가이드라인

## 1. 개발 환경 설정

### 1.1 필수 도구

- Flutter SDK (최신 버전)
- Dart SDK (최신 버전)
- Android Studio / Xcode
- VS Code (권장)
- Git

### 1.2 VS Code 확장 프로그램

- Dart
- Flutter
- Pubspec Assist
- Error Lens
- GitLens

### 1.3 환경 변수 설정

`.env` 파일 생성:
```bash
DISCOGS_API_KEY=your_api_key
DISCOGS_API_SECRET=your_api_secret
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## 2. 코드 스타일 가이드

### 2.1 Dart 스타일 가이드

- [Effective Dart](https://dart.dev/guides/language/effective-dart) 준수
- `dart format` 사용
- `analysis_options.yaml` 설정 준수

### 2.2 네이밍 컨벤션

- 클래스: PascalCase
- 변수/함수: camelCase
- 상수: UPPER_CASE
- 프라이빗 멤버: _underscorePrefix

### 2.3 파일 구조

```
lib/
├── components/     # 재사용 가능한 UI 컴포넌트
├── data/          # 데이터 소스 및 리포지토리 구현
├── domain/        # 비즈니스 로직 및 엔티티
├── exceptions/    # 예외 처리
├── model/         # 데이터 모델
├── repository/    # 데이터 접근 계층
├── view/          # UI 화면
└── view_models/   # 상태 관리
```

## 3. 아키텍처 가이드라인

### 3.1 Clean Architecture 원칙

- 도메인 중심 설계
- 의존성 역전 원칙 준수
- 단일 책임 원칙 준수
- 인터페이스 분리 원칙 준수

### 3.2 레이어 간 통신

- Presentation → Domain: Use Cases 사용
- Domain → Data: Repository 인터페이스 사용
- Data → External: API 클라이언트 사용

### 3.3 상태 관리

- Provider 패턴 사용
- ChangeNotifier 기반 상태 관리
- 비동기 작업 처리

## 4. 테스트 가이드라인

### 4.1 테스트 구조

```
test/
├── unit/          # 단위 테스트
├── integration/   # 통합 테스트
└── widget/        # 위젯 테스트
```

### 4.2 테스트 작성 규칙

- Given-When-Then 패턴 사용
- 의미 있는 테스트 이름 작성
- 하나의 테스트는 하나의 동작만 검증
- Mock 객체 사용

### 4.3 테스트 커버리지

- 최소 80% 커버리지 유지
- 중요 비즈니스 로직 100% 커버리지
- UI 컴포넌트 핵심 기능 테스트

## 5. Git 작업 흐름

### 5.1 브랜치 전략

- `main`: 프로덕션 브랜치
- `develop`: 개발 브랜치
- `feature/*`: 기능 개발
- `bugfix/*`: 버그 수정
- `release/*`: 릴리스 준비

### 5.2 커밋 메시지 규칙

```
<type>(<scope>): <subject>

<body>

<footer>
```

타입:
- feat: 새로운 기능
- fix: 버그 수정
- docs: 문서 변경
- style: 코드 스타일 변경
- refactor: 코드 리팩토링
- test: 테스트 추가/수정
- chore: 빌드 프로세스/도구 변경

### 5.3 PR 가이드라인

- 의미 있는 PR 제목
- 상세한 설명
- 관련 이슈 링크
- 테스트 결과
- 스크린샷 (UI 변경 시)

## 6. 성능 최적화

### 6.1 이미지 최적화

- 이미지 캐싱 사용
- 적절한 이미지 크기 사용
- 지연 로딩 구현

### 6.2 상태 관리 최적화

- 불필요한 리빌드 방지
- 메모리 누수 방지
- 비동기 작업 최적화

### 6.3 API 호출 최적화

- 요청 캐싱
- 배치 처리
- 오프라인 지원

## 7. 보안 가이드라인

### 7.1 API 키 관리

- 환경 변수 사용
- 버전 관리에서 제외
- 암호화 저장

### 7.2 데이터 보안

- HTTPS 사용
- 민감 정보 암호화
- 접근 제어 구현

### 7.3 인증/인가

- JWT 토큰 사용
- 토큰 갱신 메커니즘
- 세션 관리

## 8. 배포 프로세스

### 8.1 테스트 배포

1. 개발 환경 테스트
2. 스테이징 환경 배포
3. QA 테스트
4. 버그 수정

### 8.2 프로덕션 배포

1. 버전 태그 생성
2. 릴리스 노트 작성
3. 프로덕션 배포
4. 모니터링

### 8.3 롤백 계획

- 롤백 절차 문서화
- 백업 시스템 준비
- 모니터링 지표 설정

## 9. 문서화

### 9.1 코드 문서화

- Dartdoc 사용
- 복잡한 로직 주석
- API 문서화

### 9.2 프로젝트 문서화

- README.md 유지
- 아키텍처 문서
- API 문서
- 개발 가이드라인

## 10. 문제 해결

### 10.1 디버깅

- 로깅 전략
- 디버그 모드 사용
- 크래시 리포트 분석

### 10.2 성능 문제

- 프로파일링 도구 사용
- 메모리 누수 검사
- 네트워크 요청 분석

### 10.3 보안 문제

- 보안 취약점 스캔
- 페널티 테스트
- 보안 감사 