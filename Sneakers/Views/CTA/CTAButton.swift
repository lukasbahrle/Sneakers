import SwiftUI

struct CTAButton: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    let isVisible: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Label {
                Text("Shop")
            } icon: {
                Image(systemName: "chevron.right")
            }
        }
        .buttonStyle(.ctaButton)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible || reduceMotion ? 0 : 30)
        .animation(.spring.speed(1.5), value: isVisible)
    }
}
