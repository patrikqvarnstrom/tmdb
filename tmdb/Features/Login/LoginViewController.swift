//
//  LoginViewController.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    weak var authenticationDelegate: AuthenticationDelegate?

    lazy var viewModel: LoginViewModel = {
        return LoginViewModel(authenticationDelegate: authenticationDelegate)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if !viewModel.isAuthenticationValid {
            viewModel.authenticationRequired()
        }
        authenticationDelegate?.authenticationDidSucceed()
    }
}
