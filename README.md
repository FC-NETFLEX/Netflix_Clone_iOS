# Netflix Clone

패스트 캠퍼스에서 진행한 팀 프로젝트 입니다.

Backend팀과의 협업으로 기존 Netflix 앱 서비스를 기반으로 같은 형태의 서비스를 만들어보는 클론 프로젝트 입니다.





## Description

- 개발 기간: 2020.03.20 ~ 2020.04.29 (약 6주)
- 참여 인원: iOS 4명, Backend 2명   [Organization](https://github.com/FC-NETFLEX)
- 사용 기술
  - Language: Swift
  - FrameWork: UIKit, AVFoundation
  - Library: SnapKit, KingFisher
- 담당 구현 파트
  - 영상 재생 기능 구현
  
  - 콘텐츠 저장 기능 구현
  
  - 로그인, 회원가입 기능 구현
  
  - 서버에 데이터 요청하는 작업을 `APIManager` struct로 모듈화
  
  - 다양한 기기에 대응하기 위해 extension을 통한 함수를 작성해 팀원들 에게 제공
    - UIFoant: iPhone 11pro를 기준으로 height의 비율 계산을 통해 적절한 폰트를 반환.
    - CGFloat: iPhone 11pro를 기준으로 height 또는 width의 비율 계산을 통해 적절한 CGFloat 수치를 반환.
    
    





## Implementation

### 영상 재생 

<img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/VideoContrtoller.gif"></img>

- 구현 내용

  - 서버, 혹은 저장 되어 있는 영상의 재생
  - 재생, 일시정지, 건너뛰기 등의 영상 컨트롤
  - 영상 썸네일 추출
  - 시청 종료시 시청중인 부분의 정보를 서버, 혹은 디바이스에 저장
  - 이전에 시청중이였던 부분부터 재생

- 트러블 슈팅

  - ```UISlider``` 의 value의 변화에 따라  ``` AVAssetImageGenerator``` class의 ```generateCGImagesAsynchronously``` 함수를 이용해 영상 썸네일을 추출하여 사용자에게 보여주려 했으나 이미지 요청 횟수가 너무 많고 느려서 정확한 이미지를 보여주지 못하는 문제
- 예를 들어 영상이 1시간이면 1초 단위로만 계산해도 60 * 60 = 3600 추출할 이미지가 너무 많고 비동기로 동작하기 때문에 slider를 멈췄을때도 이미지가 계속 바뀜
    - Netflix 앱 확인 결과 영상 썸네일이 10초 단위로 나오는것 확인
    
- `AVAsset`의 load가 완료됨과 동시에 썸네일 이미지를 10초 단위로 추출한 후 그 이미지들을 캐싱해 두고 사용하는 방식으로 해결 



### 콘텐츠 저장

<img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/SaveContent.gif"></img>

- 구현 내용
  - 서버에 있는 영상을 다운로드, 디바이스에 저장
  - 현재 다운로드 상태를 원형의 프로그레스바로 표현 
  - Swipe 삭제 버튼을 커스텀으로 직접 구현
  - 시청중인 영상 프로그레스바로 표현
  - 저장 가능한 콘텐츠 찾아보기 화면 구현
    - 콘텐츠 데이터 요청으로 응답받은 데이터 `Codable`을 이용한 파싱
- 트러블 슈팅
  - 커스텀 삭제 버튼을 구현하기 위해 Cell에 등록한 `UIPanGestureRecognizer` 가 `UITableView` 가 스크롤 되어야 하는 상황 에서도 동작해서 스크롤이 되지 않는 문제
    - `UITableViewCell`은 기본적으로 `UIGestureRecognizerDelegate` 를 체택하고 있는데 그중 `gestureRecognizerShouldBegin` 함수 에서 `UIPanGestureRecognizer` 의 translation의 x값과 y값을 비교하여 적절하게 gesture를 분배하여 해결 
  - 다운로드가 완료된 시점에 `FileManager` class를 이용해 디바이스에 영상, 이미지 파일을 저장하고 해당 URL을 저장 하는데 가끔 영상, 이미지의 경로를 찾지 못하는 문제
    - `FileManager` 의 경로를 확인해본 결과` .../Application/<app id>/Documents` 경로로 저장을 하는데 `<app id>` 가 계속해서 바뀌는 것이 문제
    - 저장 시점의 URL은 계속해서 사용할 수 없기 때문에 영상 콘텐츠의 id값은 서버의 DB에서부터 고유한 id 값이라는 것을 이용해서 파일이름을 콘텐츠의 id값으로 저장하고 그 id값을 가지고 찾아들어가는 방식으로 해결



### 로그인, 회원가입

<img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/Login.gif"></img>

- 구현 내용
  - 회원 가입시 이메일 정규 표현식, 비밀번호 정규 표현식을 사용
  - 회원 가입시 정규 표현식, 비밀번호 확인을 만족하는 상태에서만 회원가입 버튼을 활성화
  - 로그인, 회원가입 요청시 서버와의 통신을 통해 응답 받은 데이터 `JSONSerialization`을 이용한 파싱



## Design

- 플로우 차트 (AdobeXD) : UI 구성과 앱의 흐름을 파악함

  <img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/FlowChart.png"></img>

- 명세서 작성 (Keynote): 앱의 상세 기능과 구조를 파악함

  <img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/blueprint.gif"></img>



## Collaboration

- GitHub

  - Organization에 repository를 만들고 팀원들은 각자 Fork한 repository에 작업 후 pull request를 보내는 방식으로 작업

    <img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/organization.png"></img>

  - project board 를 통한 일정 관리

    <img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/projectboard.png"></img>

- Slack: GitHub과의 연동을 통해 issue, pull request등의 실시간 알림

  <img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/slack.png"></img> 

- Slack: GitHub과의 연동을 통해 issue, pull request등의 실시간 알림

  <img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/slack.png"></img> 















