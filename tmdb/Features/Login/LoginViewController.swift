//
//  LoginViewController.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

import Lottie
import SnapKit

class LoginViewController: UIViewController {

    weak var authenticationDelegate: AuthenticationDelegate?

    lazy var informationLabel: UILabel = {
        let informationLabel = UILabel()
        informationLabel.numberOfLines = 0
        informationLabel.textAlignment = .center
        informationLabel.font = UIFont.boldSystemFont(ofSize: 20)
        informationLabel.adjustsFontSizeToFitWidth = true
        return informationLabel
    }()

    lazy var animationView: AnimationView = {
        let animationView = AnimationView()
        let animation = Animation.named("loading")
        animationView.animation = animation
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()

    lazy var viewModel: LoginViewModel = {
        return LoginViewModel(authenticationDelegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        animationView.play()
        viewModel.authenticate()
    }

    private func setupConstraints() {
        animationView.snp.makeConstraints { make in
            make.height.width.equalTo(300)
            make.center.equalToSuperview()
        }

        informationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(animationView.snp.top).offset(12)
            make.width.centerX.equalTo(animationView)
        }
    }

    private func setupViews() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        view.addSubview(informationLabel)
        view.addSubview(animationView)
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.text = "Authentication in progress .."
    }

}

extension LoginViewController: AuthenticationDelegate {
    func authenticationDidFail() {
        informationLabel.text = "Something went wrong, please try again at a later time"
        animationView.animation = Animation.named("load-fail")
        animationView.animationSpeed = 0.5
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce)
    }

    func authenticationDidSucceed() {
        informationLabel.text = "Authentication successful"
        animationView.play(fromProgress: animationView.currentProgress,
                           toProgress: 1.3,
                           loopMode: .playOnce, completion: { [weak self] _ in
            self?.authenticationDelegate?.authenticationDidSucceed()
        })
    }

}
