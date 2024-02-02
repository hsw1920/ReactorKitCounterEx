//
//  ViewController.swift
//  ReactorKit_Ex_Counter
//
//  Created by 홍승완 on 2024/01/31.
//

import UIKit
import RxSwift
import ReactorKit
import RxCocoa

class ViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    
    lazy var decreaseBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    lazy var increaseBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        return label
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func bind(reactor: ViewReactor) {
        decreaseBtn.rx.tap
            .map{ ViewReactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        increaseBtn.rx.tap
            .map{ ViewReactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { "\($0.value)" }
            .distinctUntilChanged()
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEnable }
            .distinctUntilChanged()
            .bind(to: increaseBtn.rx.isEnabled, decreaseBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isHidden)
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertMessage)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                let alertController = UIAlertController(
                    title: nil,
                    message: message,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil)
                )
                self?.present(alertController, animated: true)
            })
            .disposed(by: disposeBag)
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
        
        [decreaseBtn, increaseBtn, label, activityIndicatorView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            decreaseBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            decreaseBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            increaseBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            increaseBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }

}

