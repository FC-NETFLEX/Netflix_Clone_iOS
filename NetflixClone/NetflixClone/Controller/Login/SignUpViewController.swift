//
//  SignUpViewController.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    private let loginResultBool = false
    private let textLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPWTextField = UITextField()
    private let signUpButton = UIButton()
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        setUI()
        setNavigationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    private func setUI() {
        let uiArr = [textLabel, emailTextField, passwordTextField, confirmPWTextField, signUpButton]
        uiArr.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        textLabel.text = "지금 가입하세요!"
        textLabel.textColor = .white
        textLabel.font = .dynamicFont(fontSize: 30  , weight: .bold)
        textLabel.textAlignment = .center
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 2
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일 주소 또는 전화번호",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)])
        UITextField.appearance().tintColor = .white
        emailTextField.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        emailTextField.layer.cornerRadius = 5 //emailTextField.bounds.height
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)])
        passwordTextField.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        confirmPWTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호 확인",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)])
        confirmPWTextField.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        confirmPWTextField.layer.cornerRadius = 5
        confirmPWTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.setTitleColor(.lightGray, for: .normal)
        signUpButton.layer.borderWidth = 0.5
        signUpButton.layer.borderColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1).cgColor
        signUpButton.layer.cornerRadius = 5
        signUpButton.addTarget(self, action: #selector(touchSignUpButton(_:)), for: .touchUpInside)
        
//        print(UIFont.dynamicFont(fontSize: 15, weight: .semibold))
//        print(UIFont.systemFont(ofSize: 15, weight: .semibold))
        
        setConstraint()
    }
    
    private func setNavigationBar() {
        // 투명
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let backButton = UIBarButtonItem()
        backButton.tintColor = .white
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let imageView = UIImageView()
        let image = UIImage(named: "Logo")
        imageView.image = image
        
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    private func setConstraint() {
        let widthMultiplier: CGFloat = 0.85
        let yMargin = CGFloat.dynamicYMargin(margin: 100)
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: yMargin),
            textLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            textLabel.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.8),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -15),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier),
            emailTextField.heightAnchor.constraint(equalTo: signUpButton.heightAnchor),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier),
            passwordTextField.heightAnchor.constraint(equalTo: signUpButton.heightAnchor),
            
            confirmPWTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPWTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            confirmPWTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier),
            confirmPWTextField.heightAnchor.constraint(equalTo: signUpButton.heightAnchor),
            
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: confirmPWTextField.bottomAnchor, constant: 15),
            signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func touchSignUpButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let pw = confirmPWTextField.text else {
            return
        }
        let param = ["email": email, "password": pw]
        
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else { return }
        
        APIManager().requestOfPost(url: APIURL.createUser, data: data, completion: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error) :
                // 에러 처리
                print(error)
                
            case .success(let data):
                // 회원가입이 완료된것이 아니라 서버와의 통신이 성공한거
                guard let data = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
//                dump(data)
                guard let _ = data["id"] as? Int else {
                    
                    if let notice = data["email"] as? [String] {
//                        print(notice)
                        UIAlertController(title: "회원가입", message: notice.first ?? "다시 시도해 주세요", preferredStyle: .alert).noticePresent(viewController: self)
                    }
                    return
                }
                
                // 회원가입 성공
                UIAlertController(title: "회원가입", message: "회원가입성공", preferredStyle: .alert).noticePresent(viewController: self, completion: {
                    [weak self]  in
                    let loginVC = LoginViewController()
                    self?.navigationController?.pushViewController(loginVC, animated: true)
                })
                
            }
        })
    }
    
    @objc private func touchCustomerCenterButton(_ sender: UIButton) {
        print("고객센터")
    }
}

extension SignUpViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let emailRegex = "/^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;"
//        if String().checkRegex(regex: emailRegex) {
//            return true
//        }
//        print("형식 안맞음")
//        return false
//    }
    
}
