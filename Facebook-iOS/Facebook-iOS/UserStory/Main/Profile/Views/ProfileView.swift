//
//  ProfileView.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 11/05/23.
//

import UIKit

class ProfileView: UIView {
    
    private let view: UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(view)
        view.backgroundColor = .systemPurple
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let stackView = setupStackViewForHeader()
        view.addSubview(stackView)
        addStackViewForHeaderConstraints(stackView: stackView)
        
    }
    
    private func setupStackViewForHeader() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .brown
        return stackView
    }
    
    private func addStackViewForHeaderConstraints(stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func customImageView() {
        let image = UIImageView()
        image.image = UIImage(named: "")
    }
}
