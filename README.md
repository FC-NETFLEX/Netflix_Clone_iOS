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
  - 다양한 기기에 대응하기 위해 extension을 통한 함수를 작성해 팀원들 에게 제공
    - UIFoant: iPhone 11pro를 기준으로 height의 비율 계산을 통해 적절한 폰트를 반환.
    - CGFloat: iPhone 11pro를 기준으로 height 또는 width의 비율 계산을 통해 적절한 CGFloat 수치를 반환.





## Implementation

### 영상 재생 

<img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/VideoContrtoller.gif"></img>

- 구현 내용

  - 서버, 혹은 저장 되어 있는 영상의 재생
  - 일시정지, 빨리감기, 되감기 등의 영상 컨트롤
  - 영상 썸네일 추출
  - 시청 종료시 시청중인 부분의 정보를 서버, 혹은 로컬에 저장

- 트러블 슈팅

  - ```UISlider ``` 의 value의 변화에 따라  ``` AVAssetImageGenerator``` 클래스의 ```generateCGImagesAsynchronously``` 함수를 이용해 영상 썸네일을 추출하여 사용자에게 보여주려 했으나 이미지 요청 횟수가 너무 많고 느려서 정확한 이미지를 보여주지 못하는 문제

    - 예를 들어 영상이 1시간이면 1초 단위로만 계산해도 60 * 60 = 3600 추출할 이미지가 너무 많음

    - AVAsset의 load가 완료됨과 동시에 썸네일 이미지를 10초 단위로 추출하고 그 이미지들을 캐싱해 두고 사용하는 방식으로 해결 



### 콘텐츠 저장

<img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/SaveContent.gif"></img>





| 영상 재생 | 콘텐츠 저장 |                       로그인, 회원가입                       |
| :-------: | :---------: | :----------------------------------------------------------: |
|           |             | <img src = "https://github.com/JoongChangYang/Netflix_Clone_iOS/blob/master/assets/Login.gif"></img> |



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

















