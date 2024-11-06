import Foundation
import SwiftUI
import Kingfisher
import LocalAuthentication
import ScreenShield

enum ActiveAlert {
    case first, second
}

public struct FastRequest3View: View {
    @State private var showAlert = true
    @State private var activeAlert: ActiveAlert = .first
    @Binding var showNextScreen: Bool
    
    private let model: DataOfferObjectLib?
    private let currentTariff: String
    private let completion: (() -> Void)
    
    public init(showNextScreen: Binding<Bool>, model: DataOfferObjectLib?, currentTariff: String, completion: @escaping (() -> Void)) {
        self.model = model
        self.currentTariff = currentTariff
        self._showNextScreen = showNextScreen
        self.completion = completion
    }
    
    public var body: some View {
        if !NFX.sharedInstance().isShow {
            myView()
                .background(Color(red: 29/255, green: 34/255, blue: 57/255))
                .navigationBarHidden(true)
                .fullScreenCover(isPresented: $showNextScreen) {
                    FastRequestResultView(isSubscriptionActive: .constant(true), model: model, currentTariff: currentTariff, completion: nil)
                }
                .protectScreenshot()
                .ignoresSafeArea(.all)
                .onAppear {
                    ScreenShield.shared.protectFromScreenRecording()
                }
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .first:
                        return Alert(
                            title: Text(model?.objectTwo?.dark_blue.title ?? ""),
                            message: Text(model?.objectTwo?.dark_blue.subtitle ?? ""),
                            dismissButton: .default(Text("OK"), action: {
                                showAlert = false
                            })
                        )
                    case .second:
                        let authText = LAContext().biometricType.rawValue
                        let alertMess = String(format: model?.objectTwo?.dark_blue.al_subtitle ?? "", authText)
                        
                        return Alert(
                            title: Text(model?.objectTwo?.dark_blue.al_title ?? ""),
                            message: Text(alertMess),
                            primaryButton: .cancel(Text("Cancel")),
                            secondaryButton: .default(Text("OK"), action: {
                                completion()
                            })
                        )
                    }
                }
        } else {
            myView()
                .background(Color(red: 29/255, green: 34/255, blue: 57/255))
                .navigationBarHidden(true)
                .fullScreenCover(isPresented: $showNextScreen) {
                    FastRequestResultView(isSubscriptionActive: .constant(true), model: model, currentTariff: currentTariff, completion: nil)
                }
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .first:
                        return Alert(
                            title: Text(model?.objectTwo?.dark_blue.title ?? ""),
                            message: Text(model?.objectTwo?.dark_blue.subtitle ?? ""),
                            dismissButton: .default(Text("OK"), action: {
                                showAlert = false
                            })
                        )
                    case .second:
                        let authText = LAContext().biometricType.rawValue
                        let alertMess = String(format: model?.objectTwo?.dark_blue.al_subtitle ?? "", authText)
                        
                        return Alert(
                            title: Text(model?.objectTwo?.dark_blue.al_title ?? ""),
                            message: Text(alertMess),
                            primaryButton: .cancel(Text("Cancel")),
                            secondaryButton: .default(Text("OK"), action: {
                                completion()
                            })
                        )
                    }
                }
        }
    }
    
    @MainActor
    private func myView() -> some View {
        VStack {
            KFImage(URL(string: model?.objectTwo?.dark_blue.main_img ?? ""))
                .setProcessor(SVGImgProcessor())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 109, height: 97)
                .padding(.top, 20)
            
            Text(model?.objectTwo?.dark_blue.title ?? "")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 15)
            
            Text(model?.objectTwo?.dark_blue.subtitle ?? "")
                .font(.system(size: 22, weight: .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
            
            Spacer()
            
            Text((model?.objectTwo?.description.items_title ?? "") + createText())
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .padding(.top, 15)
            
            Spacer()
            
            HStack(spacing: 10) {
                KFImage(URL(string: model?.objectTwo?.dark_blue.small_img ?? ""))
                    .setProcessor(SVGImgProcessor())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                
                Text(model?.objectTwo?.dark_blue.footer_text ?? "")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(.top, 15)
            
            Button(action: {
                activeAlert = .second
                showAlert = true
            }) {
                Text(model?.objectTwo?.dark_blue.btn_title ?? "")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 115/255, green: 199/255, blue: 0/255))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 37)
            .padding(.bottom, 30)
        }
    }
    
    private func createText() -> String {
        var text: String = ""
        
        model?.objectTwo?.description.items?.forEach {
            text.append("\n \($0)")
        }
        
        return text
    }
    
    public func triggerForResult() {
        showNextScreen = true
    }
}

extension LAContext {
    enum BiometricType: String {
        case none = "faceID"
        case touchID = "Touch ID"
        case faceID = "Face ID"
    }
    
    var biometricType: BiometricType {
        var error: NSError?
        
        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
            }
        }
        
        return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
}
