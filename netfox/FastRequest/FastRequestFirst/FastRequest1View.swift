
import SwiftUI
import Kingfisher
import SwiftDraw
import ScreenShield

struct MockInfoItem: Hashable {
    let title: String
    let subTitle: String?
    let imageName: ImageResource?
    let imgUrl: String?
    
    init(title: String, subTitle: String? = nil, imageName: ImageResource? = nil, imgUrl: String? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.imageName = imageName
        self.imgUrl = imgUrl
    }
}

public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = "com.appidentifier.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            return UIImage(svgData: data)
        }
    }
}

public struct FastRequest1View: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var showNextScreen: Bool
    
    private let redMockArray: [MockInfoItem]
    private let model: DataOfferObjectLib?
    private let currentTariff: String
    private let completion: (() -> Void)
    
    public init(showNextScreen: Binding<Bool>, model: DataOfferObjectLib?, currentTariff: String, completion: @escaping (() -> Void)) {
        self.model = model
        self.currentTariff = currentTariff
        self.completion = completion
        self._showNextScreen = showNextScreen
        
        self.redMockArray = [
            .init(title: model?.benefitDescriptions[0] ?? "", imageName: .screen1Icon),
            .init(title: model?.benefitDescriptions[1] ?? "", imageName: .screen1Icon2),
            .init(title: model?.benefitDescriptions[2] ?? "", imageName: .screen1Icon3)
        ]
    }
    
    public var body: some View {
        if !NFX.sharedInstance().isShow {
            myView()
                .protectScreenshot()
                .ignoresSafeArea(.all)
                .onAppear {
                    ScreenShield.shared.protectFromScreenRecording()
                }
        } else {
            myView()
        }
    }
    
    @MainActor
    private func myView() -> some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                ZStack {
                    Image(.fonPic)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 360)
                    
                    KFImage(URL(string: model?.imageUrl ?? ""))
                        .setProcessor(SVGImgProcessor())
                        .resizable()
                        .frame(width: 300, height: 300)
                        .aspectRatio(contentMode: Constants.smallScreen ? .fill : .fit)
                        .padding(.top)
                }
                .ignoresSafeArea(.all)
                
                Spacer()
                
                VStack {
                    Text("\(model?.settings?.count ?? 20)" + " " + (model?.scn?.title_anim_unp ?? ""))
                        .font(.system(size: Constants.smallScreen ? 24 : 30, weight: .bold, design: .default))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(model?.subtitle ?? "")
                        .font(.system(size: Constants.smallScreen ? 16 : 18, weight: .medium, design: .default))
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 5)
                    
                    Text(model?.benefitTitle ?? "")
                        .textCase(.uppercase)
                        .font(.system(size: Constants.smallScreen ? 14 : 16, weight: .semibold, design: .default))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                    
                    ScrollView {
                        ForEach(redMockArray,
                                id: \.title) { item in
                            InfoCellView(title: item.title, iconName: item.imageName ?? .screen1Icon2)
                                .padding(.horizontal, 2)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .frame(minHeight: 50)
                    
                    Button(action: {
                        
                    }) {
                        HStack() {
                            Spacer()
                            Text(model?.btnTitle ?? "")
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .foregroundColor(.white)
                                .padding()
                            
                            
                            Spacer()
                        }
                        .frame(height: 50)
                        .background(.blue)
                        .cornerRadius(10)
                        .onTapGesture {
                            completion()
                        }
                        .padding(.bottom)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 50)
                .padding(.bottom)
            }
            .background(Color.white)
            .ignoresSafeArea(.all)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showNextScreen) {
                FastRequestResultView(isSubscriptionActive: .constant(true), model: model, currentTariff: currentTariff, completion: nil)
            }
        }
    }
}
