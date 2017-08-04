//
//  ClientManager.swift
//  Server
//
//  Created by MrHuang on 17/8/2.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import Cocoa

protocol ClientManagerDelegate : class {
    
    func SendMessageToClient(_ data : Data)
    
}

class ClientManager: NSObject {
    
    var clientManger : TCPClient
    
    weak var delegate : ClientManagerDelegate?
    fileprivate var isReadMessge : Bool = false
    init(tcpClient : TCPClient) {
        
        self.clientManger = tcpClient
    }
}

extension ClientManager {
    
    func startReadMessages() {
        
        isReadMessge = true
        while isReadMessge  {
           
            if let message = clientManger.read(4){
                // 1.读取消息长度
                let HeadMsgData = Data(bytes: message, count: 4)
                var lenght : Int = 0
                (HeadMsgData as NSData).getBytes(&lenght, length: 4)
                
                // 2. 读取消息类型
                var type : Int = 0
                guard let typeMsg = clientManger.read(2) else { return }
                let typeData = Data(bytes: typeMsg, count: 2)
                var typelenght : Int = 0
                (typeData as NSData).getBytes(&typelenght, length: 2)
                
                // 3. 根据长度 读取真实消息
                guard let Msg = clientManger.read(lenght) else {
                    return
                }
                
                let MsgData = Data(bytes: Msg, count: lenght)
                
                /*
                switch type {
                    
                case 0, 1:
                  let user = try! UserInfo.parseFrom(data: MsgData)
                    print(user.name)
                    print(user.level)
                default:
                    print("未知类型")
                }
                */
//                let Msgstring = String(data: MsgData, encoding: .utf8)
//                print(Msgstring ?? "123")
                
                // 消息长度
                let total = HeadMsgData + typeData + MsgData
                
                delegate?.SendMessageToClient(total)
                
                print(total )
                
            }else {
                
                isReadMessge = false
                print("断开了链接")
                clientManger.close()
            }
            
        }
       
    }

}
