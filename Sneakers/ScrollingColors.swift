import SwiftUI

struct ScrollingColors: View {
    let colors: [Color]
    let containerScrollPercent: CGFloat
    
    @Environment(\.self) private var environment
    
    private var currentBackgroundColor: Color {
        let index0 = max(0, Int(floor(containerScrollPercent)))
        let index1 = min(colors.count - 1, Int(ceil(containerScrollPercent)))
        let color1 = colors[index0]
        let color2 = colors[index1]
        let colorPercent = containerScrollPercent.truncatingRemainder(dividingBy: 1)
        
        return color1.mix(with: color2, percent: Float(colorPercent), environmnet: environment)
    }
    
    var body: some View {
        currentBackgroundColor
    }
}

private extension Color {
    func mix(with color: Color, percent: Float, environmnet: EnvironmentValues) -> Color {
        let resolvedColor1 = self.resolve(in: environmnet)
        let resolvedColor2 = color.resolve(in: environmnet)
        
        let red1 = Double(resolvedColor1.red * (1 - percent))
        let red2 = Double(resolvedColor2.red * percent)
        
        let green1 = Double(resolvedColor1.green * (1 - percent))
        let green2 = Double(resolvedColor2.green * percent)
        
        let blue1 = Double(resolvedColor1.blue * (1 - percent))
        let blue2 = Double(resolvedColor2.blue * percent)
        
        return Color(red:  red1 + red2,
                     green: green1 + green2,
                     blue: blue1 + blue2)
    }
}

private struct PreviewView: View {
    let colors = [
        Color.red,
        Color.green,
        Color.blue
    ]
    @State private var scrollPercent: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 60) {
            ScrollingColors(colors: colors, containerScrollPercent: scrollPercent)
            
            Slider(value: $scrollPercent, in: 0...CGFloat(colors.count - 1))
                .padding()
        }
    }
}

#Preview {
    PreviewView()
}
