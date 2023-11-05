import SwiftUI

extension ButtonStyle where Self == CTAButtonStyle {
    static var ctaButton: Self {
        CTAButtonStyle()
    }
}

struct CTAButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("AvenirNextCondensed-Italic", size: 20, relativeTo: .body))
            .kerning(2)
            .fontWeight(.medium)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
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

#Preview {
    ZStack {
        Button {
            print("action")
        } label: {
            Label {
                Text("Star")
            } icon: {
                Image(systemName: "star")
            }
        }
        .buttonStyle(.ctaButton)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .foregroundStyle(.white)
    .background(Color.black)
    
}
