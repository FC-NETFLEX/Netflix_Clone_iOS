//
//  CanSaveViewController.swift
//  NetflixClone
//
//  Created by 양중창 on 2020/04/16.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class CanSaveViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tryStartDownLoad(saveContent: SaveContent) {
        let profile = HaveSaveContentsProfile.default()
        
        profile?.startDownLoad(saveContent: saveContent)
    }

}

