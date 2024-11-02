import Foundation
import SwiftUI

struct FastRequestResultToggleView: View {
    let title: String
    let activeTitle: String
    let disactiveTitle: String
    let backColor: Color
    
    @Binding var isToggleActive: Bool
    
    var body: some View {
        Toggle(isOn: $isToggleActive) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: Constants.smallScreen ? 9 : 10, weight: .medium, design: .default))
                        .foregroundColor(Color(red: 103/255, green: 103/255, blue: 103/255))
                    
                    HStack(spacing: 5) {
                        Image(isToggleActive ? .screen7GreenMark : .screen7RedMark)
                            .frame(width: 12, height: 12)
                        
                        Text(isToggleActive ? activeTitle : disactiveTitle)
                            .font(.system(size: Constants.smallScreen ? 11 : 14, weight: .semibold, design: .default))
                            .foregroundColor(isToggleActive ? .green : .red)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .background(backColor)
        .cornerRadius(10)
    }
}

struct SymbolToggleStyle: ToggleStyle {
    var systemImage: String = "lock.fill"
    var activeColor: Color = .green
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 30)
                .fill(configuration.isOn ? activeColor : Color(uiColor: #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)))
                .overlay {
                    Circle()
                        .fill(.white)
                        .padding(3)
                        .overlay {
                            Image(systemName: systemImage)
                                .foregroundColor(configuration.isOn ? .gray : .white)
                        }
                        .offset(x: configuration.isOn ? 10 : -10)
                    
                }
                .frame(width: 50, height: 32)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}
