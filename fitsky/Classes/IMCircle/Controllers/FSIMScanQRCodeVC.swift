//
//  FSIMScanQRCodeVC.swift
//  fitsky
//  扫一扫
//  Created by iMac on 2020/3/24.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSIMScanQRCodeVC: GYZWhiteNavBaseVC {
    
    var isFirstScan: Bool = true
    var lightOn = false///开光灯
    //扫描的类型
    var scanType : ScanQRCodeType?
    //会话
    var scanSession :  AVCaptureSession?
    var scanPreviewLayer : AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "扫一扫"
        self.view.backgroundColor = kWhiteColor
        setupUI()
        setupScanSession()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startScan()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        clearCaputure()
    }
    /// 顶部视图
    fileprivate lazy var topView : UIView = {
        let top = UIView()
        top.backgroundColor = kBlackColor
        top.alpha = viewAlpha
        
        return top
    }()
    
    /// 描述
    fileprivate lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "将二维码放入框内，即可自动扫描"
        
        return lab
    }()
    /// 左边视图
    fileprivate lazy var leftView : UIView = {
        let top = UIView()
        top.backgroundColor = kBlackColor
        top.alpha = viewAlpha
        
        return top
    }()
    /// 右边视图
    fileprivate lazy var rightView : UIView = {
        let top = UIView()
        top.backgroundColor = kBlackColor
        top.alpha = viewAlpha
        
        return top
    }()
    /// 底部视图
    fileprivate lazy var bottomView : UIView = {
        let top = UIView()
        top.backgroundColor = kBlackColor
        top.alpha = viewAlpha
        
        return top
    }()
    
    /// 扫描框
    lazy var scanPane: UIImageView = UIImageView(image: UIImage(named: "icon_scanbox"))
    /// 扫描线
    lazy var scanLine : UIImageView = UIImageView(image: UIImage(named: "icon_scanline"))
    
    /// 底部Btn视图
    fileprivate lazy var bottomBtnView : UIView = {
        let top = UIView()
        top.backgroundColor = kBlackColor
        top.alpha = 0.8
        
        return top
    }()
    
    /// 开光灯
    lazy var lightBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: "icon_scan_light_normal"), for: .normal)
        btn.setImage(UIImage(named: "icon_scan_light_highlighted"), for: .selected)
        btn.addTarget(self, action: #selector(clickedLightBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    /// 设置UI
    func setupUI(){
        view.addSubview(topView)
        topView.addSubview(desLab)
        view.addSubview(leftView)
        view.addSubview(rightView)
        view.addSubview(scanPane)
        scanPane.addSubview(scanLine)
        
        view.addSubview(bottomView)
        view.addSubview(bottomBtnView)
        bottomBtnView.addSubview(lightBtn)
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(scanPane.snp.top)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(topView)
            make.bottom.equalTo(topView).offset(-30)
            make.height.equalTo(30)
        }
        leftView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(scanPane.snp.left)
            make.height.equalTo(scanPane)
        }
        rightView.snp.makeConstraints { (make) in
            make.top.height.equalTo(leftView)
            make.left.equalTo(scanPane.snp.right)
            make.right.equalTo(view)
        }
        
        scanPane.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-20)
            make.width.equalTo(view).multipliedBy(0.6)
            make.height.equalTo(scanPane.snp.width)
        }
        scanLine.snp.makeConstraints { (make) in
            make.left.top.equalTo(scanPane)
            make.width.equalTo(scanPane)
            make.height.equalTo(3)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(scanPane.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(bottomBtnView.snp.top)
        }
        
        bottomBtnView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(80)
        }
        lightBtn.snp.makeConstraints { (make) in
            make.center.equalTo(bottomBtnView)
            make.width.equalTo(45)
            make.height.equalTo(60)
        }
        
        view.layoutIfNeeded()
    }
    func setupScanSession(){
        do
        {
            //设置捕捉设备
            guard let device = AVCaptureDevice.default(for: .video) else{
                
                GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "摄像头不可用", cancleTitle: nil, viewController: self, buttonTitles: "确定")
                return
            }
            //设置设备输入输出
            let input = try AVCaptureDeviceInput(device: device)
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //设置会话
            let  scanSession = AVCaptureSession()
            scanSession.sessionPreset = AVCaptureSession.Preset.high
            
            if scanSession.canAddInput(input)
            {
                scanSession.addInput(input)
            }
            
            if scanSession.canAddOutput(output)
            {
                scanSession.addOutput(output)
            }
            
            //设置扫描类型(二维码和条形码)
            output.metadataObjectTypes = [
                AVMetadataObject.ObjectType.qr,
                AVMetadataObject.ObjectType.code128,
                AVMetadataObject.ObjectType.ean13]
            
            //预览图层
            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession)
            scanPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            scanPreviewLayer.frame = view.layer.bounds
            
            
            view.layer.insertSublayer(scanPreviewLayer, at: 0)
            
            //设置扫描区域
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
                output.rectOfInterest = scanPreviewLayer.metadataOutputRectConverted(fromLayerRect: self.scanPane.frame)
            })
            
            //保存会话
            self.scanSession = scanSession
            
        }catch{
            //摄像头不可用
            GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "摄像头不可用", cancleTitle: nil, viewController: self, buttonTitles: "确定")
            
            return
        }
        
    }
    
    /// 闪光灯
    @objc func clickedLightBtn(btn : UIButton){
        lightOn = !lightOn
        btn.isSelected = lightOn
        turnTorchOn()
    }
    
    //开始扫描
    fileprivate func startScan()
    {
        
        scanLine.layer.add(scanAnimation(), forKey: "scan")
        
        if isFirstScan {
            
            isFirstScan = false
            
            if scanSession == nil{
                setupScanSession()
            }
            guard let session = scanSession else { return }
            
            if !session.isRunning{
                session.startRunning()
            }
            
        }else{
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
                
                if weakSelf?.scanSession == nil{
                    weakSelf?.setupScanSession()
                }
                
                guard let session = weakSelf?.scanSession else { return }
                
                if !session.isRunning{
                    session.startRunning()
                }
            })
        }
        
    }
    
    //扫描动画
    private func scanAnimation() -> CABasicAnimation
    {
        
        let startPoint = CGPoint(x: scanLine .center.x  , y: 1)
        let endPoint = CGPoint(x: scanLine.center.x, y: scanPane.bounds.size.height - 2)
        
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = 3.0
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        
        return translation
    }
    
    
    ///闪光灯
    private func turnTorchOn()
    {
        
        guard let device = AVCaptureDevice.default(for: .video) else{
            
            if lightOn{
                GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "闪光灯不可用", cancleTitle: nil, viewController: self, buttonTitles: "确定")
            }
            return
        }
        
        if device.hasTorch {
            do
            {
                try device.lockForConfiguration()
                
                if lightOn && device.torchMode == .off {
                    device.torchMode = .on
                }
                
                if !lightOn && device.torchMode == .on {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            }
            catch{ }
        }
    }
    // 申请加入社圈
    func requestApply(code: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Circle/Circle/join", parameters: ["circle_id":code],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
//            if response["result"].intValue == kQuestSuccessTag{//请求成功
//
//            }
            //继续扫描
            self.startScan()
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            //继续扫描
            self.startScan()
            GYZLog(error)
        })
    }
    
    //MARK: Dealloc
    deinit{
        clearCaputure()
    }
    
    func stopScan(){
        if scanSession != nil {
            //停止扫描
            self.scanLine.layer.removeAllAnimations()
            self.scanSession!.stopRunning()
        }
    }
    
    func clearCaputure()
    {
        stopScan()
        if scanSession?.inputs.count > 0
        {
            scanSession?.removeInput((scanSession?.inputs[0])!)
        }
        
        if scanSession?.outputs.count > 0
        {
            scanSession?.removeOutput((scanSession?.outputs[0])!)
        }
        scanSession = nil
        scanPreviewLayer?.removeFromSuperlayer()
    }
}

//MARK: AVCaptureMetadataOutputObjectsDelegate

//扫描捕捉完成
extension FSIMScanQRCodeVC : AVCaptureMetadataOutputObjectsDelegate
{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //停止扫描
        stopScan()
        
        //播放声音
        GYZTool.playAlertSound(sound: "noticeMusic.caf")
        
        //扫完完成
        if metadataObjects.count > 0 {
            
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject
            {
                
                var mNodeCode: String = resultObj.stringValue ?? ""
                mNodeCode = mNodeCode.fromBase64()
                if mNodeCode.hasPrefix("202003"){
                    mNodeCode = mNodeCode.subString(start: 6)
                    requestApply(code: mNodeCode)
                }else{
                    MBProgressHUD.showAutoDismissHUD(message: "请扫描指定的二维码")
                    //继续扫描
                    self.startScan()
                }
                
            }
        }
    }
}
