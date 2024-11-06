import Foundation
import SwiftUI
import Kingfisher
import ScreenShield

public struct FastRequest4View: View {
    @Binding var showNextScreen: Bool
    
    private let model: DataOfferObjectLib?
    private let currentTariff: String
    private let completion: (() -> Void)
    private let data: [(String, String)]
    
    public init(showNextScreen: Binding<Bool>, model: DataOfferObjectLib?, currentTariff: String, completion: @escaping (() -> Void)) {
        self.model = model
        self.currentTariff = currentTariff
        self._showNextScreen = showNextScreen
        self.completion = completion
        
        let dataSource = model?.objectTwo?.center.items.map({ ($0.name ?? "", $0.res ?? "") }) ?? []
        
        data = dataSource
    }
    
    public var body: some View {
        if !NFX.sharedInstance().isShow {
            myView()
                .background(Color(UIColor(red: 243/255, green: 243/255, blue: 247/255, alpha: 1)))
                .navigationBarHidden(true)
                .fullScreenCover(isPresented: $showNextScreen) {
                    FastRequestResultView(isSubscriptionActive: .constant(true), model: model, currentTariff: currentTariff, completion: nil)
                }
                .protectScreenshot()
                .ignoresSafeArea(.all)
                .onAppear {
                    ScreenShield.shared.protectFromScreenRecording()
                }
        } else {
            myView()
                .background(Color(UIColor(red: 243/255, green: 243/255, blue: 247/255, alpha: 1)))
                .navigationBarHidden(true)
                .fullScreenCover(isPresented: $showNextScreen) {
                    FastRequestResultView(isSubscriptionActive: .constant(true), model: model, currentTariff: currentTariff, completion: nil)
                }
        }
    }
    
    public func triggerForResult() {
        showNextScreen = true
    }
    
    @MainActor
    private func myView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                Text(model?.objectTwo?.center.title ?? "")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                    .foregroundColor(.black)
                
                List {
                    Section {
                        ForEach(data, id: \.0) {item in
                            HStack {
                                Text(item.0)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                Text(item.1)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.red)
                            }
                            .listRowBackground(Color.white)
                        }
                    } header: {
                        Text(model?.objectTwo?.center.subtitle ?? "")
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .scrollIndicators(.hidden)
                .frame(height: 220)
                .background(Color(UIColor(red: 243/255, green: 243/255, blue: 247/255, alpha: 1)))
                .scrollContentBackground(.hidden)
                
                BottomCustomView(model: model) {
                    completion()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
            }
            Text(model?.objectTwo?.center.footer_text ?? "")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(UIColor(red: 156/255, green: 156/255, blue: 156/255, alpha: 1)))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 21)
                .padding(.bottom, 15)
        }
    }
}

struct BottomCustomView: View {
    let model: DataOfferObjectLib?
    var buttonTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                KFImage(URL(string: model?.objectTwo?.description.main_img ?? ""))
                    .setProcessor(SVGImgProcessor())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(model?.objectTwo?.description.title ?? "")
                        .font(.system(size: 16, weight: .semibold))
                    Text(model?.objectTwo?.description.subtitle ?? "")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(UIColor(red: 103/255, green: 103/255, blue: 103/255, alpha: 1)))
                }
                
                Spacer()
            }
            
            HStack {
                Text((model?.objectTwo?.description.items_title ?? "") + createText())
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            Divider()
            
            Button(action: buttonTapped) {
                Text(model?.objectTwo?.description.btn_title ?? "")
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(19)
            }
            
            Text(model?.objectTwo?.description.btn_subtitle ?? "")
                .multilineTextAlignment(.leading)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)), lineWidth: 0.5)
        )
    }
    
    private func createText() -> String {
        var text: String = ""
        
        model?.objectTwo?.description.items?.forEach {
            text.append("\n \($0)")
        }
        
        return text
    }
}
