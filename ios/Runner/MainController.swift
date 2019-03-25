//
//  MainController.swift
//  Runner
//
//  Created by YoonTaesup on 2019. 3. 25..
//  Copyright © 2019년 The Chromium Authors. All rights reserved.
//
import UIKit
import Flutter
import SwiftyBootpay

class MainController: UIViewController {
    
    var nc: NativeController?
    var fc: FlutterViewController!
    var mc: FlutterBasicMessageChannel!
    
    var emptyString = ""
    var ping = "ping"
    var channel = "increment"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print(segue)
        if segue.identifier == "NativeControllerSegue" {
            self.nc = segue.destination as? NativeController
            self.nc?.sendable = self
        }else if segue.identifier == "FlutterControllerSegue" {
            self.fc = segue.destination as? FlutterViewController
            
            mc = FlutterBasicMessageChannel(
                name: channel,
                binaryMessenger: fc,
                codec: FlutterStringCodec.sharedInstance())
            
            mc.setMessageHandler() { (message:Any?, reply:FlutterReply) in
                self.nc?.didReceiveIncrement()
                reply(self.emptyString)
            }
        }
    }
}

extension MainController: NativeProtocol {
    func didReceiveIncrement() {
        self.mc.sendMessage(ping)
    }
}
