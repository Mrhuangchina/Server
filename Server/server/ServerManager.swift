//
//  ServerManager.swift
//  Server
//
//  Created by MrHuang on 17/8/2.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import Cocoa



class ServerManager: NSObject {

    fileprivate lazy var serverSocket :  TCPServer = TCPServer(addr: "0.0.0.0", port: 8888)
    fileprivate lazy var Managers : [ClientManager] = [ClientManager]()
    fileprivate lazy var isRuning : Bool = false
    
}


extension ServerManager {

    func  startRuning() {
     // 1.开始监听
     serverSocket.listen()
      isRuning = true
     
     // 2.开始接收
        DispatchQueue.global().async {
            
            while self.isRuning  {
              
                if let client = self.serverSocket.accept() {
                
                    DispatchQueue.global().async {
                        
                        self.handlerClient(client)
                    }
                }
                
                
            }

            
        }
        
    }
    
    func stopRuning() {
        isRuning = false
    }

}

extension ServerManager {
    
    //处理client操作
    fileprivate func handlerClient(_ client : TCPClient){
     // 1.用一个ClientManager管理TCPClient
        let Manager = ClientManager(tcpClient: client)
        Manager.delegate = self
     // 2.保存客户端manger
        Managers.append(Manager)
    // 3.读取/接收消息
        Manager.startReadMessages()
    }

}

//ClientManagerDelegate
extension ServerManager : ClientManagerDelegate {

    
    func SendMessageToClient(_ data: Data) {
        //  将消息转发给其他的客户端
        for msg in Managers {
            
            msg.clientManger.send(data:data)
            
        }
        
    }

}
