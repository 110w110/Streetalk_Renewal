# Streetalk_Renewal
기존 Streetalk 프로젝트를 완전히 새롭게 리팩토링하는 프로젝트입니다.

- 프로젝트명 : Streetalk Renewal (Streetalk 2.0)
- 작업 기간 : 2023.5.31 ~ 진행중

현재 작업이 꾸준히 진행 중에 있으며, 업데이트 되는 내용들은 계속해서 추가하도록 하겠습니다.

기존 레거시 코드에 부족한 부분이 아주 많고 구조적으로 완성도가 많이 떨어지기 때문에 리팩토링은 새로운 프로젝트에서 구현하게 되었습니다.
아래에는 변경되는 사항에 대한 내용이며 소스 코드 또는 캡쳐 화면을 추후에 업데이트하여 정리할 예정입니다.

## 주요 변경점 요약
- 네트워크 모듈을 깔끔하게 정리하였습니다.
    - 레거시에서는 같은 로직을 모든 요청마다 중복 수행하는 문제가 있었기 때문에 싱글턴의 네트워크 모듈을 구현하여 정리하였습니다.
    - Model 또한 중복되거나 불필요한 구조를 제거하여 정리하였습니다.
    - 네트워크 응답에 대한 모델이 중복으로 선언되지 않도록 하나의 Request와 Response로 처리하였습니다.
    - 이 과정에서 비슷한 기능을 유지보수하기 좋게 프로토콜 지향적으로 구현하였습니다.
    - 레거시 코드에서는 Alamofire를 활용했으나 네트워크 통신 로직에 대한 이해도를 높이기 위해 URLSession을 사용해서 간결하게 구현하였습니다.
- Storyboard를 간결하게 정리하였습니다.
    - 화면 역할 별로 스토리보드 분리했습니다.
    - 큰 UI 구성 위주로 사용하여 가독성을 높이고 오류를 줄였습니다.
    - 코드로만 작성할지 스토리보드로 작성할지 고민 끝에 큰 줄기는 비슷하게 리팩토링 하는 것이 목표여서 그대로 스토리보드를 활용하였습니다.
- Swift 언어 또는 iOS 개발의 통용되는 컨벤션과 자체적인 컨벤션을 적용하였습니다.
    - Class 이름이 lowerCamelCase로 표현된 경우는 UpperCamelCase로 수정하였습니다.
    - 인스턴스 변수나 프로퍼티가 UpperCamelCase로 표현된 경우는 lowerCamelCase로 수정하였습니다.
    - 특정 컨벤션이 존재한다고 가정하고 클래스명의 접두어로 ST를 붙였습니다.
- 자주 사용되는 로직을 Extension 또는 상속을 통해 중복을 줄였습니다.
    - 앱의 시그니처 디자인이 적용된 버튼을 STButton을 만들어서 매번 중복되는 로직으로 나타내지 않도록 수정하였습니다.
- 불필요한 로직 대거 제거
    - 사용되지 않는 UIColor가 Extension에 추가된 것을 확인하고 모두 제거하였습니다.
    - IBOutlet 중 거의 동일한 기능을 수행하는 요소들은 하나로 통합하여 불필요한 로직을 대거 제거하였습니다.
- 접근제한자를 적절하게 수정하여 구조적 안정성을 확보하였습니다.
    - 파일 내부에서 사용되는 구조체 또는 클래스는 fileprivate로 설정하여 내부에서만 사용하게 수정하였습니다.
    - 클래스 또는 구조체 외부에서 사용되지 않거나 사용하지 않아야 하는 프로퍼티 또는 함수는 모두 private으로 설정하였습니다.
- 메인화면의 뷰의 배너를 UICollectionView의 Header로 변경하고 Sticky Header 형태로 구현하였습니다.
- 스토리보드 상 UI 배치 간에 Stack View를 적극 활용하여 각 UI 간 Auto Layout의 충돌 가능성을 최소화하고 재사용성을 늘렸습니다.
- myPage 구조체를 만들어서 메뉴 수정이 있을 때 다른 클래스에 영향이 없도록 분리 시켰습니다.
- mypage showNextViewController 에서 제너릭 구현으로 메소드 간소화

## 주요 변경점 자세히 보기
![스크린샷 2023-06-23 오후 7 34 19](https://github.com/110w110/Streetalk_Renewal/assets/87888411/ce5c0646-2c1f-4e98-9cde-75007a718686)
![스크린샷 2023-06-23 오후 7 34 30](https://github.com/110w110/Streetalk_Renewal/assets/87888411/9a775f47-44ee-4987-844e-0e102509be07)
![스크린샷 2023-06-23 오후 7 34 40](https://github.com/110w110/Streetalk_Renewal/assets/87888411/8ceafda3-81bb-46e6-a900-55e74e199198)
![스크린샷 2023-06-23 오후 7 34 55](https://github.com/110w110/Streetalk_Renewal/assets/87888411/2483d22c-e0d2-4ada-b3f3-14e38c613f42)
![스크린샷 2023-06-23 오후 7 34 55](https://github.com/110w110/Streetalk_Renewal/assets/87888411/5ee9636b-fb49-4860-8d93-d9434ccd7f43)
![스크린샷 2023-06-23 오후 7 35 15](https://github.com/110w110/Streetalk_Renewal/assets/87888411/f26a7378-4ac0-4deb-b6f8-9bbf415ccfd8)
![스크린샷 2023-06-23 오후 8 02 13](https://github.com/110w110/Streetalk_Renewal/assets/87888411/2df705e0-3eee-43bf-9f56-5591025567ce)
![스크린샷 2023-06-23 오후 8 02 24](https://github.com/110w110/Streetalk_Renewal/assets/87888411/a0057c11-f617-45da-ac2a-944bb24d0c2b)
![스크린샷 2023-06-23 오후 8 02 32](https://github.com/110w110/Streetalk_Renewal/assets/87888411/569a981f-9728-474b-a98b-90c9816ee578)
![스크린샷 2023-06-23 오후 8 02 44](https://github.com/110w110/Streetalk_Renewal/assets/87888411/7850bf2a-ecbb-481e-8e55-c1f1ce9cee48)
![스크린샷 2023-06-23 오후 8 02 54](https://github.com/110w110/Streetalk_Renewal/assets/87888411/50e0bad4-7b2f-4956-a2fe-edf09866f1c6)
![스크린샷 2023-06-23 오후 8 03 07](https://github.com/110w110/Streetalk_Renewal/assets/87888411/0d0d9c90-f9ab-4f83-8e11-1d863f938de8)
  
