//
//  AuthViewController.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 22.06.2022.
//

import UIKit
import RxSwift
import RxCocoa

class AuthViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    var onLogin: (() -> Void)?
    var onRegistration: (() -> Void)?

    @IBAction func loginButtonTap(_ sender: UIButton) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text
        else { return }

        let passwordHash = Crypto.hash(password)

        guard let user = findUserBy(login: login) else {
            showAlert("Пользователь не найден")
            return
        }
        guard user.password == passwordHash else {
            showAlert("Не верный пароль")
            passwordTextField.text = ""
            return
        }
        UserDefaults.isLogin = true
        onLogin?()
    }

    @IBAction func registrationButtonTap(_ sender: UIButton) {
        onRegistration?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginBindings()
    }

    private func findUserBy(login: String) -> RealmUser? {
        let users = try? RealmService.load(typeOf: RealmUser.self)
        let user = users?.first(where: { $0.login == login })
        return user
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }

    private func configureLoginBindings() {
        Observable
            .combineLatest(
                loginTextField.rx.text,
                passwordTextField.rx.text
            )
            .map { login, password in
                return ((login ?? "").count >= 3) && (password ?? "").count >= 8
            }
            .bind { [weak loginButton] inputField in
                loginButton?.isEnabled = inputField
            }
    }
}
