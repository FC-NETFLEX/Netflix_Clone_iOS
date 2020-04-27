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

