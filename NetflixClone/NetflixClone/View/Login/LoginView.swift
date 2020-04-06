//
//  LoginView.swift
//  NetlixClone
//
//  Created by 양중창 on 2020/03/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
    func login(email: String, password: String)
}

class LoginView: UIView {
    
    weak var delegate: LoginViewDelegate?
    
    var isLoading: Bool = false {
        didSet {
            if self.isLoading {
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        }
    }
    
    private let indicator = UIActivityIndicatorView()
    
    private let parentView = UIView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let passwordResetButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObservers()
    }
    
    //MARK: UI
    private func setUI() {
        
        [parentView].forEach({
            addSubview($0)
        })
        
        [emailTextField, passwordTextField, loginButton, passwordResetButton, indicator].forEach {
            parentView.addSubview($0)
        }
        
        let placeholderColor = UIColor.setNetfilxColor(name: .netflixLightGray).cgColor
        let textFieldColor = UIColor.setNetfilxColor(name: .netflixDarkGray)
        let textColor = UIColor.setNetfilxColor(name: .white)
        
        indicator.hidesWhenStopped = true
        indicator.tintColor = .setNetfilxColor(name: .white)
        
        emailTextField.tintColor = textColor
        emailTextField.backgroundColor = textFieldColor
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        emailTextField.delegate = self
        emailTextField.textColor = textColor
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "이메일 주소 또는 전화번호",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        
        
        passwordTextField.tintColor = textColor
        passwordTextField.backgroundColor = textFieldColor
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        passwordTextField.textContentType = .password
        passwordTextField.textColor = textColor
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        
        
        loginButton.setTitle("로그인", for: .normal)
        loginButton.setTitleColor(.lightGray, for: .normal)
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.borderColor = UIColor.setNetfilxColor(name: .netflixDarkGray).cgColor
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.setBackgroundColor(.black, for: .normal)
        loginButton.setBackgroundColor(.red, for: .selected)
        
        
        passwordResetButton.setTitle("비밀번호 재설정", for: .normal)
        passwordResetButton.setTitleColor(.lightGray, for: .normal)
        passwordResetButton.titleLabel?.font = UIFont.dynamicFont(fontSize: 18, weight: .semibold)
        passwordResetButton.addTarget(self, action: #selector(touchResetPasswordButton(_:)), for: .touchUpInside)
        
        passwordResetButton.addTarget(self, action: #selector(touchResetPasswordButton(_:)), for: .touchUpOutside)
        passwordResetButton.layer.borderWidth = 0.5
        passwordResetButton.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    private func setConstraints() {
        
        let guide = safeAreaLayoutGuide
        
        let widthMultiplier: CGFloat = 0.85
        let yMargin = CGFloat.dynamicYMargin(margin: 15)
        let heigh: CGFloat = 50
        
        indicator.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        parentView.snp.makeConstraints({
            $0.centerX.centerY.equalTo(guide)
            $0.width.equalTo(guide).multipliedBy(widthMultiplier)
        })
        
        emailTextField.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(heigh)
        })
        
        passwordTextField.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(emailTextField.snp.bottom).offset(yMargin)
            $0.height.equalTo(heigh)
        })
        
        loginButton.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(passwordTextField.snp.bottom).offset(yMargin)
            $0.height.equalTo(heigh)
        })
        
        passwordResetButton.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(loginButton.snp.bottom).offset(yMargin)
            $0.height.equalTo(heigh)
            $0.bottom.equalToSuperview()
        })
        
    }
    
    //MARK: Action
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        endEditing(true)
    }
    
    @objc private func touchResetPasswordButton(_ sender: UIButton) {
        print("비밀번호 재설정")
    }
    
    @objc private func didTapLoginButton() {
        guard !isLoading else { return }
        guard
            loginButton.isSelected,
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        delegate?.login(email: email, password: password)
        isLoading = true
    }
    
    // 키보드의 움직임에 따른 parentView Constraints update
    private func updateParentViewConstraints(constant: CGFloat) {
        let margin = CGFloat.dynamicYMargin(margin: 8)
        parentView.snp.updateConstraints({
            $0.centerY.equalTo(safeAreaLayoutGuide).offset(constant - margin)
        })
    }
    
    // 키보드 올라올때
    @objc private func keyboardWillAppear(notification: NSNotification) {
//        print(#function)
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else { return }
        let viewCenter = (frame.height - safeAreaInsets.top - safeAreaInsets.bottom) / 2
        let keyboardHeight = keyboardFrame.height
        let constant = viewCenter - (parentView.frame.height / 2 + keyboardHeight)
        UIView.animate(withDuration: duration, animations: {
            [weak self] in
            self?.updateParentViewConstraints(constant: constant)
            self?.layoutIfNeeded()
        })
        
    }
    
    // 키보드 내려갈때
    @objc private func keyboardWillDisappear(notification: NSNotification) {
        print(#function)
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }
        UIView.animate(withDuration: duration, animations: {
            [weak self] in
            self?.updateParentViewConstraints(constant: 0)
            self?.layoutIfNeeded()
        })
    }
    
    
    //MARK: Observer
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    
}


extension LoginView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return !isLoading
    }
    
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
