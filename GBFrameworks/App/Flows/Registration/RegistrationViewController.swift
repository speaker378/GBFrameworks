//
//  RegistrationViewController.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 22.06.2022.
//

import UIKit
import RealmSwift

class RegistrationViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!

    @IBAction func registrationButtonTap(_ sender: UIButton) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text
        else { return }
        createUser(login: login, password: password)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddTargetIsNotEmptyTextFields()
    }

    func setupAddTargetIsNotEmptyTextFields() {
        registrationButton.isEnabled = false
        loginTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    }

    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        guard
            let login = loginTextField.text,
            !login.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty
        else {
            self.registrationButton.isEnabled = false
            return
        }
        registrationButton.isEnabled = true
    }

    private func createUser(login: String, password: String) {
        let user = RealmUser(login: login, password: password)
        do {
            try RealmService.save(items: [user])
        } catch {
            print(error)
            return
        }
    }
}
