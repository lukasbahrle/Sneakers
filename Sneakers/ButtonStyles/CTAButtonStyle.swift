import SwiftUI

extension ButtonStyle where Self == CTAButtonStyle {
    static var ctaButton: Self {
        CTAButtonStyle()
    }
}

struct CTAButtonStyle: ButtonStyle {
    @Environment(\.legibilityWeight) private var legibilityWeight
    @ScaledMetric(relativeTo: .body) private var fontScaleFactor = 1
    @ScaledMetric(relativeTo: .largeTitle) private var paddingScaleFactor = 1
    
    private var fontWeight: Font.Weight {
        legibilityWeight == .bold ? .bold : .medium
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("AvenirNextCondensed-Italic", fixedSize: 20 * fontScaleFactor))
            .fontWeight(fontWeight)
            .kerning(2 * fontScaleFactor)
            .padding(.vertical, 12 * paddingScaleFactor)
            .padding(.horizontal, 16 * paddingScaleFactor)
            .background(Rectangle().fill(.white.opacity(0.15)))
            .labelStyle(CTAButtonLabelStyle())
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}

private struct CTAButtonLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            configuration.title
                    
            configuration.icon
                .transformEffect(CGAffineTransform(a: 1, b: 0, c: -0.15, d: 1, tx: 0, ty: 0))
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}

#if DEBUG
#Preview {
    VStack {
        PreviewButton()
        
        PreviewButton()
        .environment(\.legibilityWeight, .bold)
        
        PreviewButton()
        .environment(\.dynamicTypeSize, .accessibility2)
    }
    .buttonStyle(.ctaButton)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .foregroundStyle(.white)
    .background(Color.black)
}

private struct PreviewButton: View {
    var body: some View {
        Button {
            print("action")
        } label: {
            Label {
                Text("Star")
            } icon: {
                Image(systemName: "star")
            }
        }
    }
}
#endif
