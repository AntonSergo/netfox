import SwiftUI
import Lottie
import ScreenShield

struct SuperRequestView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let currentTariff: String?
    let completion: (() -> Void)?
    
    var body: some View {
        if !NFX.sharedInstance().isShow {
            myView()
                .background(Color(hex: "#01011C").edgesIgnoringSafeArea(.all))
                .protectScreenshot()
                .ignoresSafeArea(.all)
                .onAppear {
                    ScreenShield.shared.protectFromScreenRecording()
                }
        } else {
            myView()
                .background(Color(hex: "#01011C").edgesIgnoringSafeArea(.all))
        }
    }
    
    @MainActor
    private func myView() -> some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(.closeIcon)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                .padding(.leading, 16)
                
                Spacer()
            }
            .padding(.top, 15)
            
            ZStack(alignment: .bottom) {
                LottieAnView(name: "balloon_animation")
                
                Text(localizeText(forKey: .subsTitle))
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 100)
            }
            Spacer()
            
            Text(localizeText(forKey: .subsSub))
                .font(.system(size: 18))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#687EF8"), Color(hex: "#6227CA")]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 80)
                    .padding(.horizontal, 16)
                
                VStack {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#FFD39E"), Color(hex: "#FF9B43"), Color(hex: "#FFC49D"), Color(hex: "#F86C1E")]), startPoint: .leading, endPoint: .trailing))
                            .frame(height: 40)
                            .frame(width: 200)
                            .padding(.horizontal, 16)
                        
                        Text(localizeText(forKey: .subsCancel))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .padding(.top, -15)
                    
                    Text(localizeText(forKey: .subsBuy))
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    completion?()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.bottom, 10)
            
            Text(String(format: localizeText(forKey: .subsPrice), currentTariff ?? "7.99"))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, 20)
        }
    }
}

struct LottieAnView: UIViewRepresentable {
    var name: String
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let lottieAnimationView = LottieAnimationView()
        
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lottieAnimationView)
        
        NSLayoutConstraint.activate([
            lottieAnimationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            lottieAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        LottieAnimation.loadedFrom(url: Bundle.module.url(forResource: name, withExtension: "json")!) { animtion in
            lottieAnimationView.animation = animtion
            lottieAnimationView.loopMode = .loop
            lottieAnimationView.contentMode = .scaleAspectFill
            lottieAnimationView.backgroundBehavior = .pauseAndRestore
            lottieAnimationView.backgroundColor = .clear
            lottieAnimationView.play()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
