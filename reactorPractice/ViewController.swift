//
//  ViewController.swift
//  reactorPractice
//
//  Created by 김동환 on 2021/11/21.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then

final class ViewController: UIViewController, View {
    
    private let decreaseBtn = UIButton().then {
        $0.setTitle("-", for: .normal)
        $0.setTitleColor(.link, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
    }
    
    private let increaseBtn = UIButton().then {
        $0.setTitle("+", for: .normal)
        $0.setTitleColor(.link, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
    }
    
    private let countingLabel = UILabel().then {
        $0.text = "0"
        $0.font = UIFont.systemFont(ofSize: 30)
        $0.textColor = .label
    }
    
    private let activityIndicator = UIActivityIndicatorView()
    
    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayout()
    }

    func setLayout() {
        
        view.addSubview(decreaseBtn)
        view.addSubview(countingLabel)
        view.addSubview(increaseBtn)
        view.addSubview(activityIndicator)
        decreaseBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        increaseBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        countingLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(countingLabel.snp.bottom).offset(10)
        }
        
    }
    
    func bind(reactor: CountingReactor) {
        
        increaseBtn.rx.tap
            .map{ Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        decreaseBtn.rx.tap
            .map{ Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.value }
               .distinctUntilChanged()
               .map{ "\($0)" }
               .bind(to: countingLabel.rx.text)
               .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isLoading }
               .distinctUntilChanged()
               .bind(to: activityIndicator.rx.isAnimating)
               .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertMessage)
               .compactMap{ $0 }
               .subscribe(onNext:{ [weak self] message in
                   let alert = UIAlertController(
                    title: nil,
                    message: message,
                    preferredStyle: .alert)
                   let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                   alert.addAction(action)
                   self?.present(alert, animated: true, completion: nil)
               })
               .disposed(by: disposeBag)
    }
    
}

