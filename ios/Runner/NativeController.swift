//
//  NativeController.swift
//  Runner
//
//  Created by YoonTaesup on 2019. 3. 25..
//  Copyright © 2019년 The Chromium Authors. All rights reserved.
//

import UIKit
import SwiftyBootpay

@objc public protocol NativeProtocol {
    @objc(didReceiveIncrement) func didReceiveIncrement()
}

class NativeController: UIViewController {
    
    var sendable: NativeProtocol?
    var counter = 0
    var vc: BootpayController!
    
    @IBOutlet weak var centerLabel: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    
    func didReceiveIncrement() {
        counter += 1
        centerLabel.text = "Flutter button tapped \(counter) \(counter == 1 ? "time" : "times")"        
    }
    
    @IBAction func clickIncrement(_ sender: UIButton) {
        self.sendable?.didReceiveIncrement()
    }
    
    @IBAction func clickBootpayRequest(_ sender: UIButton) {
        presentBootpayController()
    }
    
    
    func presentBootpayController() {
        // 통계정보를 위해 사용되는 정보
        // 주문 정보에 담길 상품정보로 배열 형태로 add가 가능함
        let item1 = BootpayItem().params {
            $0.item_name = "미\"키's 마우스" // 주문정보에 담길 상품명
            $0.qty = 1 // 해당 상품의 주문 수량
            $0.unique = "ITEM_CODE_MOUSE" // 해당 상품의 고유 키
            $0.price = 1000 // 상품의 가격
        }
        let item2 = BootpayItem().params {
            $0.item_name = "키보드" // 주문정보에 담길 상품명
            $0.qty = 1 // 해당 상품의 주문 수량
            $0.unique = "ITEM_CODE_KEYBOARD" // 해당 상품의 고유 키
            $0.price = 10000 // 상품의 가격
            $0.cat1 = "패션"
            $0.cat2 = "여\"성'상의"
            $0.cat3 = "블라우스"
        }
        
        // 커스텀 변수로, 서버에서 해당 값을 그대로 리턴 받음
        let customParams: [String: String] = [
            "callbackParam1": "value12",
            "callbackParam2": "value34",
            "callbackParam3": "value56",
            "callbackParam4": "value78",
            ]
        
        // 구매자 정보
        let userInfo: [String: String] = [
            "username": "사용자 이름",
            "email": "user1234@gmail.com",
            "addr": "사용자 주소",
            "phone": "010-1234-4567"
        ]
        
        vc = BootpayController()
        
        // 주문정보 - 실제 결제창에 반영되는 정보
        vc.params {
            $0.price = 1000 // 결제할 금액
            $0.name = "블링\"블링's 마스카라" // 결제할 상품명
            $0.order_id = "1234_1234_124" // 결제 고유번호
            $0.params = customParams // 커스텀 변수
            $0.user_info = userInfo // 구매자 정보
            $0.pg = "easypay" // 결제할 PG사
            $0.phone = "010-1234-5678" // 결제할 PG사
            //            $0.account_expire_at = "2018-09-25" // 가상계좌 입금기간 제한 ( yyyy-mm-dd 포멧으로 입력해주세요. 가상계좌만 적용됩니다. 오늘 날짜보다 더 뒤(미래)여야 합니다 )
            $0.method = "card" // 결제수단
            $0.sendable = self // 이벤트를 처리할 protocol receiver
            $0.quotas = [0,2,3] // // 5만원 이상일 경우 할부 허용범위 설정 가능, (예제는 일시불, 2개월 할부, 3개월 할부 허용)
        }
        
        vc.addItem(item: item1) //배열 가능
        vc.addItem(item: item2) //배열 가능
        
        self.present(vc, animated: true, completion: nil)
//        self.view.addSubview(vc.view);
    }
}


//MARK: Bootpay Callback Protocol
extension NativeController: BootpayRequestProtocol {
    // 에러가 났을때 호출되는 부분
    func onError(data: [String: Any]) {
        print(data)
    }
    
    // 가상계좌 입금 계좌번호가 발급되면 호출되는 함수입니다.
    func onReady(data: [String: Any]) {
        print("ready")
        print(data)
    }
    
    // 결제가 진행되기 바로 직전 호출되는 함수로, 주로 재고처리 등의 로직이 수행
    func onConfirm(data: [String: Any]) {
        print(data)
        
        let iWantPay = true
        if iWantPay == true {  // 재고가 있을 경우.
            vc.transactionConfirm(data: data) // 결제 승인
        } else { // 재고가 없어 중간에 결제창을 닫고 싶을 경우
            vc.removePaymentWindow()
        }
    }
    
    // 결제 취소시 호출
    func onCancel(data: [String: Any]) {
        print(data)
    }
    
    // 결제완료시 호출
    // 아이템 지급 등 데이터 동기화 로직을 수행합니다
    func onDone(data: [String: Any]) {
        print("onDone")
        print(data)
    }
    
    //결제창이 닫힐때 실행되는 부분
    func onClose() {
        print("close")
//        vc.view.removeFromSuperview()
        vc.dismiss() //결제창 종료
    }
}
