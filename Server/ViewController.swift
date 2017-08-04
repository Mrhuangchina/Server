//
//  ViewController.swift
//  Server
//
//  Created by MrHuang on 17/8/2.
//  Copyright © 2017年 Mrhuang. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    fileprivate lazy var serverMrg : ServerManager = ServerManager()
    @IBOutlet weak var statusLabel: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    
    @IBAction func startServer(_ sender: NSButton) {
        
        serverMrg.startRuning()
        statusLabel.stringValue = "服务器已启动ing..."
    }
    
    
    @IBAction func StopServer(_ sender: NSButton) {
        
        serverMrg.stopRuning()
        statusLabel.stringValue = "服务器已停止！！！"
    }

}

