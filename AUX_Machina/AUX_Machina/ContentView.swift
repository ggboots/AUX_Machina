//
//  ContentView.swift
//  AUX_Machina
//
//  Created by Grahm on 4/1/2025.
//

import CoreML
import SwiftUI

import UIKit
import AVFoundation
import Combine
import Vision


class CameraViewModel: ObservableObject {
    @Published var detectedObject: String = ""
//    @Published var confidence: Float = 0.0
    @Published var boundingBox: CGRect = .zero
}

struct ContentView: View {
    
    @StateObject private var viewModel = CameraViewModel()
    var body: some View {
        ZStack{
            CameraView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
        VStack{
            Text(viewModel.detectedObject)
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
                .multilineTextAlignment(.center)
        }
        Rectangle()
            .stroke(Color.red, lineWidth: 3)
            .frame(width:viewModel.boundingBox.width, height: viewModel.boundingBox.height)
            .position(x:viewModel.boundingBox.midX, y:viewModel.boundingBox.midY)
        }
    }
}

#Preview {
    ContentView()
}

// displays the camera feed
struct CameraView: UIViewControllerRepresentable {
    
    @ObservedObject var viewModel: CameraViewModel
    func makeUIViewController(context: Context) -> some UIViewController {
        let cameraViewController = CameraViewController(viewModel: viewModel)
        return cameraViewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

// UIViewController - manages the camera session and processing
class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var viewModel: CameraViewModel
    
    init(viewModel: CameraViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            return
        }
        
        captureSession.addInput(videoInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self,queue: DispatchQueue(label:"cameraQueue"))
        captureSession.addOutput(videoOutput)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        captureSession.commitConfiguration()
        captureSession.startRunning( )
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func detectObject(sampleBuffer: CMSampleBuffer){
        
            
    }
}
