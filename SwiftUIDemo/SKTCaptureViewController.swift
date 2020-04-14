//
//  SKTCaptureViewController.swift
//  SwiftUIDemo
//
//  Created by Chrishon Wyllie on 4/14/20.
//  Copyright © 2020 Chrishon Wyllie. All rights reserved.
//

import UIKit
import SKTCapture

class SKTCaptureViewController: UIViewController {
    
    public var capture = CaptureHelper.sharedInstance
    
    public var discoveredDevices: [CaptureHelperDevice] = []
    
    // MARK: - Variables
    
    
    
    
    
    




    // MARK: - Variables
       
   private let cellReuseIdentifier = "cell reuse identifier"
   
   private var isScanning = false
   
   
   
   
   
   
   
   // MARK: - UI Elements
   
   private lazy var tableView: UITableView = {
       let tbv = UITableView(frame: .zero, style: UITableView.Style.plain)
       tbv.translatesAutoresizingMaskIntoConstraints = false
       tbv.backgroundColor = .systemBackground
       tbv.delegate = self
       tbv.dataSource = self
       return tbv
   }()
   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUIElements()
        setupCapture()
    }
    

    
    
    
    
    // MARK: - Functions
    
    private func setupUIElements() {
        
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    private func setupCapture() {
        let AppInfo = SKTAppInfo();
        AppInfo.appKey="MC0CFQC0h6M9xDDTYUc7FKzb4CkfVt5S4wIUPLr7JGNQnRO54VEncskc7JKTH8U=";
        AppInfo.appID="ios:com.socketmobile.SwiftUIDemo";
        AppInfo.developerID="bb57d8e1-f911-47ba-b510-693be162686a";
        // open Capture Helper only once in the application
        
        capture.dispatchQueue = DispatchQueue.main
        capture.pushDelegate(self)
        capture.openWithAppInfo(AppInfo, withCompletionHandler: { (result: SKTResult) in
            print("Result of Capture initialization: \(result.rawValue)")
        })
    }
}







// MARK: - UITableViewDelegate and UITableViewDataSource

extension SKTCaptureViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return capture.getDevices().count
    }
    
    // Display a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let device = capture.getDevices()[indexPath.item]
        cell.textLabel?.text = device.deviceInfo.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}













extension SKTCaptureViewController: CaptureHelperDeviceManagerPresenceDelegate {
    
    func didNotifyArrivalForDeviceManager(_ device: CaptureHelperDeviceManager, withResult result: SKTResult) {
        print("device manager has arrived")
        
        device.dispatchQueue = DispatchQueue.main
        
        // By default, the favorites is set to ""
        device.getFavoriteDevicesWithCompletionHandler { (result, favorite) in
            if result == SKTResult.E_NOERROR {
                if let favorite = favorite {
                    print("device favorite: \(favorite)")
                    if favorite == "" {
                        device.setFavoriteDevices("*") { (result) in
                            
                        }
                    }
                }
            }
        }
    }
    
    func didNotifyRemovalForDeviceManager(_ device: CaptureHelperDeviceManager, withResult result: SKTResult) {

    }
}

extension SKTCaptureViewController: CaptureHelperDevicePresenceDelegate {
    
    func didNotifyArrivalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        print("capture device arrived")
        tableView.reloadData()
    }
    
    func didNotifyRemovalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        tableView.reloadData()
    }
    
}

extension SKTCaptureViewController: CaptureHelperDeviceManagerDiscoveryDelegate {
    
    func didDiscoverDevice(_ device: String, fromDeviceManager deviceManager: CaptureHelperDeviceManager) {
      
    }
    
    func didEndDiscoveryWithResult(_ result: SKTResult, fromDeviceManager deviceManager: CaptureHelperDeviceManager){
        
    }
    
}



extension SKTCaptureViewController: CaptureHelperDeviceDecodedDataDelegate {
    
    func didReceiveDecodedData(_ decodedData: SKTCaptureDecodedData?, fromDevice device: CaptureHelperDevice, withResult result: SKTResult) {
        if let decodedData = decodedData, let stringFromData = decodedData.stringFromDecodedData() {
            print("tag id raw value: \(decodedData.dataSourceID.rawValue)")
            print("tag id: \(decodedData.dataSourceID)")
            print("data source name: \(String(describing: decodedData.dataSourceName))")
            print("decoded data: \(stringFromData)")
        }
    }
    
}
