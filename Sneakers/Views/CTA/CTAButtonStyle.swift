import SwiftUI

extension ButtonStyle where Self == CTAButtonStyle {
    static var ctaButton: Self {
        CTAButtonStyle()
    }
}

struct CTAButtonStyle: ButtonStyle {
    @Environment(\.legibilityWeight) private var legibilityWeight
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    
    private var fontWeight: Font.Weight {
        legibilityWeight == .bold ? .bold : .medium
    }
    
    private var backgroundOpacity: CGFloat {
        colorSchemeContrast == .increased ? 0.2 : 0.15
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("AvenirNextCondensed-Italic", size: 20, relativeTo: .body))
            .fontWeight(fontWeight)
            .kerning(2, relativeTo: .body)
            .padding(.vertical, 12, relativeTo: .largeTitle)
            .padding(.horizontal, 16, relativeTo: .largeTitle)
            .background(Rectangle().fill(.white.opacity(backgroundOpacity)))
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
                Text(verbatim: "Star")
            } icon: {
                Image(systemName: "star")
            }
        }
    }
}
#endif
