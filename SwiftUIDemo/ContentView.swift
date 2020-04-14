//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Chrishon Wyllie on 4/10/20.
//  Copyright © 2020 Chrishon Wyllie. All rights reserved.
//

import SwiftUI
import SKTCapture

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            SwiftUICaptureDemoView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}







// MARK: - SwiftUICaptureDemoView

struct SwiftUICaptureDemoView: View {
    
    @ObservedObject var captureDeviceViewModel = SKTCaptureDeviceViewModel()
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Connected devices: \(captureDeviceViewModel.captureHelperDeviceWrappers.count)")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
            
            HorizontalCaptureDevicesList(captureHelperDeviceWrappers: captureDeviceViewModel.captureHelperDeviceWrappers)
            
//                VerticalCaptureDevicesList(captureHelperDeviceWrappers: captureDeviceViewModel.captureHelperDeviceWrappers)
            
            DecodedDataView(decodedDataWrapper: captureDeviceViewModel.decodedDataWrapper)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.purple, lineWidth: 8)
                )
            .shadow(radius: 5)
            .cornerRadius(20)
        }.navigationBarTitle(Text("SwiftUI Demo"))
    }
}










// MARK: - Vertical List

struct VerticalCaptureDevicesList: View {
    
    let captureHelperDeviceWrappers: [CaptureHelperDeviceWrapper]
    
    var body: some View {
        List {
            ForEach(captureHelperDeviceWrappers, id: \.id) { (deviceWrapper) in

                NavigationLink(destination: CaptureHelperDeviceDetailView(deviceWrapper: deviceWrapper)) {
                    ConnectedDeviceVerticalCell(device: deviceWrapper.captureHelperDevice)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }

            }
        }
    }
}

struct ConnectedDeviceVerticalCell: View {
    
    let device: CaptureHelperDevice
    
    var body: some View {
        HStack {
            CircleImageView(imageURL: "", imageFrameDimension: 60)
            .padding(8)
            
            VStack (alignment: .leading) {
                Text("Device Name:").font(.headline)
                Text(device.deviceInfo.name ?? "NO NAME")
                    .font(.subheadline)
                    .padding(8)
                    .lineLimit(nil)
            }
           
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
        .padding(8)
    }
}





// MARK: - Horizontal List

struct HorizontalCaptureDevicesList: View {
    
    let captureHelperDeviceWrappers: [CaptureHelperDeviceWrapper]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(captureHelperDeviceWrappers, id: \.id) { (deviceWrapper) in
                    
                    NavigationLink(destination: CaptureHelperDeviceDetailView(deviceWrapper: deviceWrapper)) {
                        ConnectedDeviceHorizontalCell(device: deviceWrapper.captureHelperDevice)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200, alignment: .leading)
        .background(Color.white)
    }
}

struct ConnectedDeviceHorizontalCell: View {
    
    let device: CaptureHelperDevice
    
    var body: some View {
        VStack (alignment: .center) {
            CircleImageView(imageURL: "", imageFrameDimension: 60)
            .padding(8)
            
            VStack (alignment: .leading) {
                Text("Device Name:")
                    .foregroundColor(.primary)
                    .font(.headline)
                Text(device.deviceInfo.name ?? "NO NAME")
                    .foregroundColor(.primary)
                    .font(.subheadline)
                    .lineLimit(nil)
            }
            .padding(8)
        }
        .frame(maxWidth: .infinity, maxHeight: 150)
        .background(Color.white)
        .padding(8)
    }
}









// MARK: - CircleImageView

struct CircleImageView: View {
    let imageURL: String
    let imageFrameDimension: CGFloat
    
    var body: some View {
        Image(imageURL)
        .resizable()
        .renderingMode(.original)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.purple, lineWidth: 3))
        .frame(width: imageFrameDimension, height: imageFrameDimension)
    }
    
    init(imageURL: String, imageFrameDimension: CGFloat) {
        self.imageURL = imageURL
        self.imageFrameDimension = imageFrameDimension
    }
}






// MARK: - DecodedDataView

struct DecodedDataView: View {
    
    let decodedDataWrapper: DecodedDataWrapper
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Device Name:").font(.headline)
            Text("Device Name: \(decodedDataWrapper.device?.deviceInfo.name ?? "No Name")")
                .lineLimit(nil)
            Text("Decoded Data:")
                .padding(.top, 20)
                .font(.headline)
            List {
                Text(decodedDataWrapper.decodedData?.stringFromDecodedData() ?? "No Data")
                .lineLimit(nil)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.leading)
        .padding(20)
        .background(Color.white)
    }
}








// MARK: - Device Detail View

struct CaptureHelperDeviceDetailView: View {
    
    let deviceWrapper: CaptureHelperDeviceWrapper
    
    var body: some View {
        VStack {
            Text(deviceWrapper.captureHelperDevice.deviceInfo.name ?? "NO NAME")
        }
    }
}










// MARK: - Wrappers

struct CaptureHelperDeviceWrapper: Identifiable {
    var id: String {
        return captureHelperDevice.deviceInfo.guid ?? UUID().uuidString
    }
    let captureHelperDevice: CaptureHelperDevice
}

struct DecodedDataWrapper {
    public private(set) var decodedData: SKTCaptureDecodedData?
    public private(set) var device: CaptureHelperDevice?
    
    init() {}
    
    mutating func update(decodedData: SKTCaptureDecodedData?, device: CaptureHelperDevice) {
        self.decodedData = decodedData
        self.device = device
    }
}










// MARK: - Capture View Model

class SKTCaptureDeviceViewModel: ObservableObject,
    CaptureHelperDeviceManagerPresenceDelegate,
CaptureHelperDevicePresenceDelegate,
CaptureHelperDeviceManagerDiscoveryDelegate,
CaptureHelperDeviceDecodedDataDelegate {
    
    private let capture = CaptureHelper.sharedInstance
    
    @Published var captureHelperDeviceWrappers: [CaptureHelperDeviceWrapper] = []
    
    @Published var decodedDataWrapper = DecodedDataWrapper()
    
    init() {
        setupCapture()
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
    
    
    
    
    // CaptureHelperDeviceManagerPresenceDelegate
    
    func didNotifyArrivalForDeviceManager(_ device: CaptureHelperDeviceManager, withResult result: SKTResult) {
        
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
    
    
    
    
    // CaptureHelperDevicePresenceDelegate
    
    func didNotifyArrivalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        print("capture device arrived")
        let deviceWrapper = CaptureHelperDeviceWrapper(captureHelperDevice: device)
        self.captureHelperDeviceWrappers.append(deviceWrapper)
    }
    
    func didNotifyRemovalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        
        guard let arrayElementIndex = self.captureHelperDeviceWrappers.firstIndex(where: { (deviceWrapper) -> Bool in
            return deviceWrapper.captureHelperDevice == device
        }) else {
            return
        }
        
        self.captureHelperDeviceWrappers.remove(at: Int(arrayElementIndex))
    }

    
    
    
    // CaptureHelperDeviceManagerDiscoveryDelegate
    
    func didDiscoverDevice(_ device: String, fromDeviceManager deviceManager: CaptureHelperDeviceManager) {
      
    }
    
    func didEndDiscoveryWithResult(_ result: SKTResult, fromDeviceManager deviceManager: CaptureHelperDeviceManager){
        
    }
    
    
    
    



    // CaptureHelperDeviceDecodedDataDelegate
    
    func didReceiveDecodedData(_ decodedData: SKTCaptureDecodedData?, fromDevice device: CaptureHelperDevice, withResult result: SKTResult) {
        
        decodedDataWrapper.update(decodedData: decodedData, device: device)
        
        if let decodedData = decodedData, let stringFromData = decodedData.stringFromDecodedData() {
            print("tag id raw value: \(decodedData.dataSourceID.rawValue)")
            print("tag id: \(decodedData.dataSourceID)")
            print("data source name: \(String(describing: decodedData.dataSourceName))")
            print("decoded data: \(stringFromData)")
        }
    }
}











// MARK: - UIViewControllerRepresentable
// It is possible to embed normal UIKit UIViewControllers
// inside SwiftUI Views

struct SKTCaptureIntegratedViewController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = SKTCaptureViewController
    
    func makeUIViewController(context: Context) -> SKTCaptureViewController {
        return SKTCaptureViewController()
    }
    
    func updateUIViewController(_ uiViewController: SKTCaptureViewController, context: Context) {
        
    }
}

struct SKTCaptureSampleView: View {
    var body: some View {
        NavigationView {
            SKTCaptureIntegratedViewController()
            .navigationBarTitle("SwiftUI/Capture Demo")
            .navigationBarHidden(false)
        }
    }
}

struct SKTCaptureSampleView_Previews: PreviewProvider {
    static var previews: some View {
        SKTCaptureSampleView()
    }
}
