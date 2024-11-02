import Foundation
import SwiftUI
import Kingfisher
import ProgressHUD

struct FastRequestResultSecurityCenterView: View {
    @Binding var isSubscriptionActive: Bool
    @Binding var isRealTimeAntivirusOn: Bool
    
    @Binding var isBackgroundScanOn: Bool
    @Binding var isSecurityOn: Bool
    
    @Binding var isPasswordsOn: Bool
    @Binding var isCacheOn: Bool
    
    let model: DataOfferObjectLib?
    let tariffButtonTapped: (() -> Void)
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(5)
                        .frame(width: 70, height: 70)
                    
                    KFImage(URL(string: (isSubscriptionActive ? model?.scn?.banner_icon : model?.scn?.banner_icon_unp) ?? ""))
                        .setProcessor(SVGImgProcessor())
                        .resizable()
                        .frame(width: 56, height: 69)
                }
                
                VStack(alignment: .leading) {
                    Text(model?.scn?.banner_title ?? "")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                    
                    Text(model?.scn?.banner_subtitle ?? "")
                        .font(.system(size: 12, weight: .medium, design: .default))
                        .foregroundStyle(Color(red: 156/255, green: 156/255, blue: 156/255))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .padding(.leading, 7)
                
                Spacer()
            }
            .padding(.all, 5)
            .background(Color(red: 250/255, green: 250/255, blue: 250/255))
            .cornerRadius(10)
            
            VStack {
                HStack(spacing: 5) {
                    FastRequestResultToggleView(title: model?.scn?.features?[0].name ?? "",
                                          activeTitle: model?.scn?.features?[0].g_status ?? "",
                                          disactiveTitle: model?.scn?.features?[0].b_status ?? "",
                                          backColor: .white,
                                          isToggleActive: $isSubscriptionActive)
                    .toggleStyle(SymbolToggleStyle())
                    .disabled(true)
                    .onTapGesture {
                        if !isSubscriptionActive {
                            tariffButtonTapped()
                        }
                    }
                    
                    FastRequestResultToggleView(title: model?.scn?.features?[1].name ?? "",
                                          activeTitle: model?.scn?.features?[1].g_status ?? "",
                                          disactiveTitle: model?.scn?.features?[1].b_status ?? "",
                                          backColor: .white,
                                          isToggleActive: $isRealTimeAntivirusOn)
                    .disabled(!isSubscriptionActive)
                    .onTapGesture {
                        if !isSubscriptionActive {
                            tariffButtonTapped()
                        }
                    }
                    .onChange(of: isRealTimeAntivirusOn) { value in
                        if isSubscriptionActive, value {
                            showProgressAction()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showSuccessAction()
                            }
                        }
                    }
                }
                
                HStack(spacing: 5) {
                    FastRequestResultToggleView(title: model?.scn?.features?[2].name ?? "",
                                          activeTitle: model?.scn?.features?[2].g_status ?? "",
                                          disactiveTitle: model?.scn?.features?[2].b_status ?? "",
                                          backColor: .white,
                                          isToggleActive: $isBackgroundScanOn)
                    .disabled(!isSubscriptionActive)
                    .onTapGesture {
                        if !isSubscriptionActive {
                            tariffButtonTapped()
                        }
                    }
                    .onChange(of: isBackgroundScanOn) { value in
                        if isSubscriptionActive, value {
                            showProgressAction()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showSuccessAction()
                            }
                        }
                    }
                    
                    FastRequestResultToggleView(title: model?.scn?.features?[3].name ?? "",
                                          activeTitle: model?.scn?.features?[3].g_status ?? "",
                                          disactiveTitle: model?.scn?.features?[3].b_status ?? "",
                                          backColor: .white,
                                          isToggleActive: $isSecurityOn)
                    .disabled(!isSubscriptionActive)
                    .onTapGesture {
                        if !isSubscriptionActive {
                            tariffButtonTapped()
                        }
                    }
                    .onChange(of: isSecurityOn) { value in
                        if isSubscriptionActive, value {
                            ProgressHUD.animate(localizeText(forKey: .alertText), interaction: false)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showSuccessAction()
                                self.goPrivacy()
                            }
                        }
                    }
                }
                
                HStack(spacing: 5) {
                    FastRequestResultToggleView(title: model?.scn?.features?[4].name ?? "",
                                          activeTitle: model?.scn?.features?[4].g_status ?? "",
                                          disactiveTitle: model?.scn?.features?[4].b_status ?? "",
                                          backColor: .white,
                                          isToggleActive: $isPasswordsOn)
                    .disabled(!isSubscriptionActive)
                    .onTapGesture {
                        if !isSubscriptionActive {
                            tariffButtonTapped()
                        }
                    }
                    .onChange(of: isPasswordsOn) { value in
                        if isSubscriptionActive, value {
                            ProgressHUD.animate(localizeText(forKey: .alertText), interaction: false)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showSuccessAction()
                                self.goPass()
                            }
                        }
                    }
                    
                    FastRequestResultToggleView(title: model?.scn?.features?[5].name ?? "",
                                          activeTitle: model?.scn?.features?[5].g_status ?? "",
                                          disactiveTitle: model?.scn?.features?[5].b_status ?? "",
                                          backColor: .white,
                                          isToggleActive: $isCacheOn)
                    .disabled(!isSubscriptionActive)
                    .onTapGesture {
                        if !isSubscriptionActive {
                            tariffButtonTapped()
                        }
                    }
                    .onChange(of: isCacheOn) { value in
                        if isSubscriptionActive, value {
                            ProgressHUD.animate(localizeText(forKey: .alertText), interaction: false)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showSuccessAction()
                                self.goSafari()
                            }
                        }
                    }
                }
            }
        }
        .padding(.all, 5)
        .background(Color(red: 239/255, green: 239/255, blue: 239/255))
        .cornerRadius(15)
    }
    
    private func showProgressAction() {
        ProgressHUD.animate(interaction: false)
    }
    
    private func showSuccessAction() {
        ProgressHUD.success(interaction: false)
    }
    
    private func goPass() {
        DispatchQueue.main.async {
            let url: URL
            
            if #available(iOS 18, *) {
                url = URL(string: "App-Prefs:com.apple.Passwords")!
            } else {
                url = URL(string: "App-Prefs:PASSWORDS")!
            }
            
            guard UIApplication.shared.canOpenURL(url) else { return }
            
            UIApplication.shared.open(url)
        }
    }
    
    private func goPrivacy() {
        DispatchQueue.main.async {
            let url: URL
            
            if #available(iOS 18, *) {
                url = URL(string: "App-Prefs:Privacy")!
            } else {
                url = URL(string: "App-Prefs:Privacy")!
            }
            
            guard UIApplication.shared.canOpenURL(url) else { return }
            
            UIApplication.shared.open(url)
        }
    }
    
    private func goSafari() {
        DispatchQueue.main.async {
            let url: URL
            
            if #available(iOS 18, *) {
                url = URL(string: "App-Prefs:com.apple.mobilesafari&path=CLEAR_HISTORY_AND_DATA")!
            }
            else if #available(iOS 17.6, *) {
                url = URL(string: "App-Prefs:SAFARI&path=CLEAR_HISTORY_AND_DATA")!
            }
            else {
                url = URL(string: "App-Prefs:Safari&path=CLEAR_HISTORY_AND_DATA")!
                
            }
                    
            guard UIApplication.shared.canOpenURL(url) else { return }
            
            UIApplication.shared.open(url)
        }
    }
}
