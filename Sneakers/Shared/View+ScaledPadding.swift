import SwiftUI

struct ScaledPaddingModifier: ViewModifier {
    let edges: Edge.Set
    let length: CGFloat?
    @ScaledMetric private var scaleFactor = 1
    
    private var paddingValue: CGFloat? {
        guard let length else {
            return nil
        }
        return length * scaleFactor
    }

    init(edges: Edge.Set, length: CGFloat?, relativeTo: Font.TextStyle) {
        self.edges = edges
        self.length = length
        self._scaleFactor = ScaledMetric(wrappedValue: 1, relativeTo: relativeTo)
    }
    
    func body(content: Content) -> some View {
        content
            .padding(edges, paddingValue)
    }
}

extension View {
    func padding(_ edges: Edge.Set = .all,_ length: CGFloat? = nil, relativeTo: Font.TextStyle) -> some View {
        modifier(ScaledPaddingModifier(edges: edges, length: length, relativeTo: relativeTo))
    }
}
