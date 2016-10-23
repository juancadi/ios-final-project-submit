//
//  ScanViewController.swift
//  City Tour
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 21/10/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var qrSession: AVCaptureSession?
    var qrLayer: AVCaptureVideoPreviewLayer?
    var qrFrame: UIView?
    var qrUrls: String?
    
    
    override func viewWillAppear(animated: Bool) {
        
        //Se inicia captura de metadatos antes de que aparezca la vista
        qrSession?.startRunning()
        qrFrame?.frame = CGRectZero
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let videoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            
            let input = try AVCaptureDeviceInput(device: videoDevice)
            
            let qrMetadata = AVCaptureMetadataOutput()
            qrMetadata.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            qrMetadata.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            qrSession = AVCaptureSession()
            qrSession?.addInput(input)
            qrSession?.addOutput(qrMetadata)
            
            qrLayer = AVCaptureVideoPreviewLayer(session: qrSession!)
            qrLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            qrLayer?.frame = view.layer.bounds
            view.layer.addSublayer(qrLayer!)
            
            qrFrame = UIView()
            qrFrame?.layer.borderWidth = 3
            qrFrame?.layer.borderColor = UIColor.redColor().CGColor
            view.addSubview(qrFrame!)
            
            qrSession?.startRunning()
            
        } catch {
            
            print("Error Getting Metadata...")
            
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        //Si se detecta algo, se desaparece el marco rojo
        qrFrame?.frame = CGRectZero
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            
            return
        }
        
        let objMetadata = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if objMetadata.type == AVMetadataObjectTypeQRCode{
            
            let objBorder = qrLayer?.transformedMetadataObjectForMetadataObject(objMetadata)
            qrFrame?.frame = (objBorder?.bounds)!
            
            if objMetadata.stringValue != nil {
                
                self.qrUrls = objMetadata.stringValue
                
                let scanResultViewController = storyboard?.instantiateViewControllerWithIdentifier("scan-result-vc")
                self.navigationController?.pushViewController(scanResultViewController!, animated: true)
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destinyViewController = segue.destinationViewController as! ScanResultViewController
        self.qrSession?.stopRunning()
        destinyViewController.urlFromQR = self.qrUrls
    }
    

}
