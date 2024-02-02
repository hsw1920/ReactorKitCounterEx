//
//  ViewReactor.swift
//  ReactorKit_Ex_Counter
//
//  Created by 홍승완 on 2024/01/31.
//

import UIKit
import ReactorKit
import RxSwift

class ViewReactor: Reactor {
    let initialState: State = State()
    
    enum Action {
        case decrease
        case increase
    }

    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
        case setHidden(Bool)
        case setEnable(Bool)
        case setAlertMessage(String)
    }
    
    struct State {
        var value: Int = 0
        var isLoading = false
        var isHidden = true
        var isEnable = true
        @Pulse var alertMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .increase:
          // just 2개를 of로 묶어서 간소화시킬 수 있음
          return Observable.concat([
            .of(.setEnable(false), .setLoading(true), .setHidden(false)),
            .just(.increaseValue).delay(.seconds(1), scheduler: MainScheduler.instance),
            .of(.setEnable(true), .setLoading(false), .setHidden(true)),
            .just(.setAlertMessage("increased!"))
          ])
          
      case .decrease:
          return Observable.concat([
            .of(.setEnable(false), .setLoading(true), .setHidden(false)),
            .just(.decreaseValue).delay(.seconds(1), scheduler: MainScheduler.instance),
            .of(.setEnable(true), .setLoading(false), .setHidden(true)),
            .just(.setAlertMessage("decreased!"))
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
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setEnable(let isEnable):
            state.isEnable = isEnable
        case .setAlertMessage(let message):
            state.alertMessage = message
        case .setHidden(let isHidden):
            state.isHidden = isHidden
        }
        return state
    }
}
