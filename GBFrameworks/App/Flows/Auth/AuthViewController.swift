//
//  AuthViewController.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 22.06.2022.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var onLogin: (() -> Void)?
    var onRegistration: (() -> Void)?

    @IBAction func loginButtonTap(_ sender: UIButton) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text
        else { return }

        guard login != "", password != "" else {
            showAlert("Введите логин и пароль")
            return
        }

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
}
