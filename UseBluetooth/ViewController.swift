//
//  ViewController.swift
//  UseBluetooth
//
//  Created by 覃子轩 on 2017/6/29.
//  Copyright © 2017年 覃子轩. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {

    var blueManager:CBCentralManager! = nil
    var blueperipheral:CBPeripheral! = nil
    var peripheralAry:[CBPeripheral] = []
    var grassImg:UIImageView! = nil
    var rotetaImg:UIImageView! = nil
    var blueSwitch:Bool = false
    
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    
    @IBAction func oneAction(_ sender: AnyObject) {
        self.blueManager.connect(self.peripheralAry[sender.tag!-1], options: nil)
        self.view.addSubview(self.rotetaImg)
    }
    @IBAction func twoAction(_ sender: AnyObject) {
        self.blueManager.connect(self.peripheralAry[sender.tag!-1], options: nil)
    }
    @IBAction func threeAction(_ sender: AnyObject) {
        self.blueManager.connect(self.peripheralAry[sender.tag!-1], options: nil)
        
    }
    @IBAction func fourAction(_ sender: AnyObject) {
        self.blueManager.connect(self.peripheralAry[sender.tag!-1], options: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initBluetooth()
        self.initBlueButton()
        self.initGrass()
        self.initWater()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

// MARK: - 拓展描述初始化
extension ViewController {
    
    /// 初始化蓝牙管理
    ///
    /// - returns:
    fileprivate func initBluetooth() {
        
        self.blueManager = CBCentralManager.init(delegate: self, queue: nil)
        
    }
    
    /// 初始化链接蓝牙的按钮
    ///
    /// - returns:
    fileprivate func initBlueButton() {
        
        self.changeShowShape(viewAry: [self.oneButton,self.twoButton,self.threeButton,self.fourButton])
        self.changeShowState(viewAry: [self.oneButton,self.twoButton,self.threeButton,self.fourButton], true)
        
    }
    
    /// 初始化水
    ///
    /// - returns:
    fileprivate func initWater() {
        let waterButton:UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        waterButton.center = self.view.center
        waterButton.setImage(UIImage.init(named: "water.png"), for: .normal)
        waterButton.addTarget(self, action: #selector(waterAction(_ :)), for: .touchUpInside)
        self.view.addSubview(waterButton)
    }
    
    /// 初始化草
    ///
    /// - returns:
    fileprivate func initGrass() {
        
        self.grassImg = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        self.grassImg.center = CGPoint.init(x: self.view.frame.midX, y: self.view.frame.maxY-50)
        self.grassImg.image = UIImage.init(named: "grass.png")
        self.view.addSubview(self.grassImg)
        
    }
    
    /// 初始化旋转图片（等待蓝牙数据传输）
    ///
    /// - returns:
    fileprivate func initRotetaImg() {
        
        self.rotetaImg = RotetaImg.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100),"barley.png")
        self.rotetaImg.center = self.view.center
        self.view.addSubview(self.rotetaImg)
    }
    
}

// MARK: - 功能函数
extension ViewController {
    
    
    
    /// 改变显示的状态
    ///
    /// - parameter viewAry:
    /// - parameter state:
    fileprivate func changeShowState(viewAry:[UIView?],_ state:Bool) {
        for item in viewAry {
            item?.isHidden = state
        }
    }
    
    /// 改变显示的形状
    ///
    /// - parameter viewAry:
    fileprivate func changeShowShape(viewAry:[UIView?],_ r:CGFloat = 10) {
        
        for item in viewAry {
            item?.layer.masksToBounds = true
            item?.layer.cornerRadius = r
        }
    }
    
    
    
}

// MARK: - 按钮响应事件
extension ViewController {
    
    /// 点击水滴按钮响应
    ///
    /// - parameter button:
    @objc fileprivate func waterAction(_ button:UIButton) {
        
        if blueSwitch {
            
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                button.center.y = self.view.frame.maxY
                button.alpha = 0
            }) { (ture) in
                UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
                    self.grassImg.center = self.view.center
                    self.grassImg.transform = CGAffineTransform.init(scaleX: 4, y: 4)
                    self.grassImg.alpha = 0
                    self.view.backgroundColor = UIColor.init(red: 151/255, green: 209/255, blue: 114/255, alpha: 1)
                    }, completion: { (true) in
                        
                        self.initRotetaImg()
                        //MARK: 打开蓝牙搜索
                        self.blueManager.scanForPeripherals(withServices: nil, options: nil)
                        
                        
                })
            }
        } else {
            let alertController = UIAlertController(title: "您好 ",message: "请打开您的蓝牙", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }

    }
    
}

// MARK: - 拓展描述协议
extension ViewController:CBCentralManagerDelegate,CBPeripheralDelegate {
    
    /// 蓝牙状态发生改变时响应
    ///
    /// - parameter central:
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            print("On")
            self.blueSwitch = true
        case .poweredOff:
            print("please Open")
            self.blueSwitch = false
        default:
            print("err")
        }
        
    }
    
    /// 查到外设后，停止扫描，链接设备
    ///
    /// - parameter central:
    /// - parameter peripheral:
    /// - parameter advertisementData:
    /// - parameter RSSI:
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("发现设备：\(peripheral.name),强度：\(RSSI),UUID:\(peripheral.identifier),data:\(advertisementData)")
        
        // 使用设备名字排查询是否在设备数组内
        if peripheral.name != nil && !self.peripheralAry.contains(peripheral) {
            self.peripheralAry.append(peripheral)
        }
        
        if peripheral.name == "覃子轩的Mac mini" {
            
            self.rotetaImg.removeFromSuperview()
            
            self.blueperipheral = peripheral
            let aryLen = self.peripheralAry.count
            var tempAry:[CBPeripheral] = []
            if aryLen > 4 {
                for index in 1...4 {
                    tempAry.append(self.peripheralAry[aryLen-index])
                }
                self.peripheralAry = tempAry
            }
            
            // 显示有蓝牙的按钮
            for index in 1...self.peripheralAry.count {
                // tag为0的是controller的view
                let button:UIButton = self.view.viewWithTag(index) as! UIButton
                button.setTitle(self.peripheralAry[index-1].name!, for:.normal)
                button.isHidden = false
            }

            print(self.peripheralAry)
            print("链接外设")
            self.blueManager.stopScan()
            
        }
        
    }
    
    /// 链接外设成功，开始发现服务
    ///
    /// - parameter central:
    /// - parameter peripheral:
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("success,peripheral:\(peripheral),uuid\(peripheral.identifier)")
        self.blueperipheral.delegate = self
        self.blueperipheral.discoverServices(nil)
        print("scan server")
        
    }
    
    /// 获取从外设发来的数据
    ///
    /// - parameter peripheral:
    /// - parameter characteristic:
    /// - parameter error:
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (error != nil) {
            print("get data err")
        } else {
            let blueData = String.init(data: characteristic.value!, encoding:String.Encoding.ascii)
            if blueData == "T" {
                // 写入数据
                self.blueperipheral.writeValue(Data.init(base64Encoded: "2")!, for: characteristic, type: .withoutResponse)
            } else {
                // 保存数据
            }
            
            print(blueData)
            
        }
    }
    
    /// 写入数据的回调
    ///
    /// - parameter peripheral:
    /// - parameter descriptor:
    /// - parameter error:
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        
        print("write chara")
    }
    
    
    /// 链接外设失败
    ///
    /// - parameter central:
    /// - parameter peripheral:
    /// - parameter error:
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        print("link err")
        
    }
    
    /// 获取热点强度
    ///
    /// - parameter peripheral:
    /// - parameter RSSI:
    /// - parameter error:
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        
    }
    
    /// 发现服务
    ///
    /// - parameter peripheral:
    /// - parameter error:
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
    }
    
    /// 搜索到Characteristics的回调
    ///
    /// - parameter peripheral:
    /// - parameter service:
    /// - parameter error:
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("find char")
    }
    
    /// 断开链接
    ///
    /// - parameter central:
    /// - parameter peripheral:
    /// - parameter error:
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
    
    /// 中心读取外设实时数据
    ///
    /// - parameter peripheral:
    /// - parameter characteristic:
    /// - parameter error:
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    /// 检测写入是否成功
    ///
    /// - parameter peripheral:
    /// - parameter characteristic:
    /// - parameter error:
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
}

