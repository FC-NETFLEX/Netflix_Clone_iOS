//
//  More.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import Foundation

let moreViewData = ["내가 찜한 콘텐츠","앱 설정","계정","고객 센터"]
let moreViewImage = ["체크", "설정", "계정","고객센터"]
let mobileData = ["자동","Wi-Fi에서만 저장","데이터 절약하기","데이터 최대 사용"]

struct AppSetUp {
    let dataHeader: String
    let settingData: [AppSetData]
}
struct AppSetData {
    let text: String
    let appSetImage: String
}

let ASData: [AppSetUp] = [
    AppSetUp(dataHeader: "     콘텐츠 재생 설정", settingData: [
        AppSetData(text: "모바일 데이터 이용설정", appSetImage: "그래프")
    ]),
    AppSetUp(dataHeader: "     콘텐츠 저장 설정", settingData: [
        AppSetData(text: "Wi-Fi에서만 저장", appSetImage: "와이파이"),
        AppSetData(text: "저장한 콘텐츠 모두 삭제", appSetImage: "삭제"),
        AppSetData(text: "", appSetImage: "")
    ]),
    AppSetUp(dataHeader: "     앱 정보", settingData: [
        AppSetData(text: "인터넷 속도 검사", appSetImage: "속도")
    ])
]



//let appSetUpDataHeader = ["콘텐츠 재생 설정","콘텐츠 저장 설정","앱 정보"]
//let appSetUpData = ["모바일 데이터 이용 설정","Wi-Fi에서만 저장","스마트 저장","동영상 화질","저자한 콘텐츠 모두 삭제","인터넷 속도 검사"]
//let appSetUpImage = ["그래프","와이파이","삭제","속도"]


//color
//#colorLiteral(red: 0.7137254902, green: 0.7137254902, blue: 0.7137254902, alpha: 1)
