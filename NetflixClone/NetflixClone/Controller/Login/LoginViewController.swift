//
//  LoginViewController.swift
//  NetFlexFrame
//
//  Created by MyMac on 2020/03/22.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let tempID = "netflex@gmail.com"
    let tempPW = "1234qwer!"
    
    // 로그인 성공 실패 상황 가정 bool값
    // 성공은 true, 실패는 false
    private enum LoginResult: String {
        case NotExistedEmail = "죄송합니다. 로그인계정 #####@email.com의 비밀번호가 맞지 않습니다."
        case WrongPassword = "죄송합니다. 이 이메일 주소를 사용하는 계정을 찾을 수 없습니다. 다시 입력하시거나 새로운 계정을 등록하세요."
    }
    
    private let loginResultBool = false
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    let loginButton = UIButton()
    private let passwordResetButton = UIButton()
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        setUI()
        setNavigationBar()
    }
    
    private func setUI() {
        let uiArr = [emailTextField, passwordTextField, loginButton, passwordResetButton]
        uiArr.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
//        emailTextField.placeholder = " 이메일 주소 또는 전화번호"
        emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일 주소 또는 전화번호",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)])
        UITextField.appearance().tintColor = .white
        emailTextField.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        emailTextField.layer.cornerRadius = 5 //emailTextField.bounds.height
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        emailTextField.delegate = self
        emailTextField.textColor = .white
        emailTextField.autocapitalizationType = .none
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)])
        passwordTextField.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        passwordTextField.textContentType = .password
        passwordTextField.textColor = .white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
       
        loginButton.setTitle("로그인", for: .normal)
        loginButton.setTitleColor(.lightGray, for: .normal)
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.borderColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1).cgColor
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.setBackgroundColor(.black, for: .normal)
        loginButton.setBackgroundColor(.red, for: .selected)
        
        
        passwordResetButton.setTitle("비밀번호 재설정", for: .normal)
        passwordResetButton.setTitleColor(.lightGray, for: .normal)
        passwordResetButton.titleLabel?.font = UIFont.dynamicFont(fontSize: 18, weight: .semibold)
        
        passwordResetButton.addTarget(self, action: #selector(touchResetPasswordButton(_:)), for: .touchUpOutside)
        passwordResetButton.layer.borderWidth = 0.5
        passwordResetButton.layer.borderColor = UIColor.clear.cgColor
        
        setConstraint()
    }
    
    private func setNavigationBar() {
        // 투명
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
//        let backButton = UIBarButtonItem()
//        backButton.tintColor = .white
//        backButton.title = ""
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popAction))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        let imageView = UIImageView()
        let image = UIImage(named: "Logo")
        imageView.image = image
        
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        let customerCenterButton = UIBarButtonItem(title: "고객센터", style: .plain, target: self, action: #selector(touchCustomerCenterButton))
        customerCenterButton.tintColor = .white
        navigationItem.rightBarButtonItem = customerCenterButton
    }
    
    private func setConstraint() {
        let widthMultiplier: CGFloat = 0.85
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -15),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier),
            emailTextField.heightAnchor.constraint(equalTo: loginButton.heightAnchor),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier),
            passwordTextField.heightAnchor.constraint(equalTo: loginButton.heightAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            passwordResetButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            passwordResetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordResetButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier),
        ])
    }
    
    @objc private func touchResetPasswordButton(_ sender: UIButton) {
        print("비밀번호 재설정")
    }
    
    @objc private func touchCustomerCenterButton(_ sender: UIButton) {
        print("고객센터")
    }
    
    @objc private func didTapLoginButton() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
//        LoginStatus.shared.login(token: email)
//        let tabBarController = TabBarController()
//        tabBarController.changeRootViewController()
        let param = ["email": email, "password": password]
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else { return }
        
        APIManager().requestOfPost(
            url: .logIn,
            data: data,
            completion: {
            [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    dump(try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?])
                    guard
                        let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let token = result["token"] as? String
                    else {
                        UIAlertController(title: "로그인", message: "아이디 또는 비밀번호를 확인해주세요.", preferredStyle: .alert).noticePresent(viewController: self)
                        return
                    }
                    
                    LoginStatus.shared.login(token: token)
                    let profileVC = ProfileViewController()
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
        })
    }
    @objc private func popAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print(#function)
        guard let email = emailTextField.text, let password = passwordTextField.text else {
                loginButton.isSelected = false
                return true
        }
        
        let thisString: String
        let otherString: String
        
        if textField == emailTextField {
            thisString = (email as NSString).replacingCharacters(in: range, with: string)
            otherString = password
        } else {
            thisString = (password as NSString).replacingCharacters(in: range, with: string)
            otherString = email
        }
        
        if thisString.isEmpty || otherString.isEmpty {
            loginButton.isSelected = false
            return true
        }else {
            loginButton.isSelected = true
            return true
        }
    }
    
}
