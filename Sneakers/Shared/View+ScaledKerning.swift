import SwiftUI

private struct ScaledKerningModifier: ViewModifier {
    let kerning: CGFloat
    @ScaledMetric private var scaleFactor = 1
    
    init(kerning: CGFloat, relativeTo: Font.TextStyle) {
        self.kerning = kerning
        self._scaleFactor = ScaledMetric(wrappedValue: 1, relativeTo: relativeTo)
    }
    
    func body(content: Content) -> some View {
        content
            .kerning(kerning * scaleFactor)
    }
}

extension View {
    func kerning(_ kerning: CGFloat, relativeTo: Font.TextStyle) -> some View {
        modifier(ScaledKerningModifier(kerning: kerning, relativeTo: relativeTo))
    }
}
