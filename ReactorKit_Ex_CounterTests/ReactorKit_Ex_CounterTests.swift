//
//  ReactorKit_Ex_CounterTests.swift
//  ReactorKit_Ex_CounterTests
//
//  Created by 홍승완 on 2024/02/01.
//

import XCTest
@testable import ReactorKit_Ex_Counter

final class ReactorKit_Ex_CounterTests: XCTestCase {

    var sut = ViewController()

    func testDecreaseButton() throws {
        // given
        let reactor = ViewReactor()
        reactor.isStubEnabled = true
        
        sut.reactor = reactor
        
        // when
        sut.decreaseBtn.sendActions(for: .touchUpInside)
        
        // then
        XCTAssertEqual(reactor.stub.actions.last, .decrease)
    }
    
    func testIncreaseButton() throws {
        // given
        let reactor = ViewReactor()
        reactor.isStubEnabled = true
        
        sut.reactor = reactor
        
        // when
        sut.increaseBtn.sendActions(for: .touchUpInside)
        
        // then
        XCTAssertEqual(reactor.stub.actions.last, .increase)
    }
    

}
