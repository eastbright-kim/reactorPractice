//
//  CountingReactor.swift
//  reactorPractice
//
//  Created by 김동환 on 2021/11/21.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

final class CountingReactor: Reactor {
    
    enum Action {
        case increase
        case decrease
    }
    
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
        case setAlertLabel(String)
    }
    
    struct State {
        var value: Int
        var isLoading: Bool
        @Pulse var alertMessage: String?
    }
    
    let initialState: State
    
    init(){
        self.initialState = State(value: 0, isLoading: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setAlertLabel("increased !"))
            ])
        case .decrease:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setAlertLabel("decreased !"))
            ])
        }
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .increaseValue:
            state.value += 1
        case .decreaseValue:
            state.value -= 1
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setAlertLabel(message):
            state.alertMessage = message
        }
        return state
    }
    
}
