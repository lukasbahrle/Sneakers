import SwiftUI

struct SneakersView: View {
    let sneakers: [Sneaker]
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var scrollPercent: Double = 0
    @State private var sneakerID: Sneaker.ID? = nil
    
    private var selectedIndex: Int {
        Int(round(scrollPercent))
    }
    
    private var isCTAVisible: Bool {
        let scrollPercentRemainder = scrollPercent.truncatingRemainder(dividingBy: 1)
        return scrollPercentRemainder < 0.1
    }
    
    private func scrollOffsetBinding(width: CGFloat) -> Binding<CGPoint> {
        Binding(get: {
            CGPoint(x: scrollPercent * width, y: 0)
        }, set: {
            scrollPercent = $0.x / width
        })
    }
    
    var body: some View {
        GeometryReader { reader in
            let minSide = min(reader.size.width, reader.size.height)
            ZStack {
                titleView(reader: reader)
                    .frame(maxHeight: .infinity)
                    .offset(y: -minSide * 0.22)
                
                WSScrollView(
                    axes: .horizontal,
                    showsIndicators: false,
                    offset: scrollOffsetBinding(width: reader.size.width)) {
                        HStack(spacing: 0) {
                            ForEach(sneakers) {
                                Image($0.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(.degrees(-36))
                                    .shadow(color: .black.opacity(0.06), radius: minSide * 0.07)
                                    .shadow(color: .black.opacity(0.4), radius: minSide * 0.08, y: minSide * 0.12)
                                    .padding(.top, minSide * 0.25)
                                    .containerRelativeFrame(
                                        .horizontal)
                                    .frame(maxHeight: .infinity)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: $sneakerID)
                
                VStack {
                    logo
                        .padding(.top, reader.safeAreaInsets.top + 30)
                    
                    Spacer()
                    
                    ctaButton
                        .opacity(isCTAVisible ? 1 : 0)
                        .offset(y: isCTAVisible || reduceMotion ? 0 : 30)
                        .padding(.bottom, reader.safeAreaInsets.bottom + 20)
                        .animation(.spring.speed(1.5), value: isCTAVisible)
                }
            }
            .foregroundColor(.white)
            .background(
                ScrollingColors(
                    colors: sneakers.map { $0.backgroundColor },
                    containerScrollPercent: scrollPercent))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
        .accessibilityRepresentation {
            accessibilityRepresentation
        }
        .onAppear {
            sneakerID = sneakers.first?.id
        }
    }
    
    private var logo: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 70)
    }
    
    private func titleView(reader: GeometryProxy) -> some View {
        let minSide = min(reader.size.width, reader.size.height)
        let transitionOffset: CGFloat = reader.size.width * 0.4
        let letterTransition: (Bool) -> AnyTransition  = { isMovingLeft in
                .asymmetric(insertion:
                        .offset(x: isMovingLeft ? -transitionOffset : transitionOffset).combined(with: .opacity),
                            removal:
                        .offset(x: isMovingLeft ? transitionOffset : -transitionOffset).combined(with: .opacity))
        }
        
        return ScrollingLetters(
            titles: sneakers.map { $0.title },
            containerScrollPercent: scrollPercent) { letterTransition($0)}
            .font(.custom("AvenirNextCondensed-HeavyItalic",fixedSize: minSide * 0.24))
            .animation(.spring, value: scrollPercent)
    }
    
    private var ctaButton: some View {
        Button {
            goToShop()
        } label: {
            Label {
                Text("Shop")
            } icon: {
                Image(systemName: "chevron.right")
            }
        }
        .buttonStyle(.ctaButton)
    }
    
    private func goToShop() {
        print("shop \(sneakers[selectedIndex].title)")
    }
    
    // MARK: - Accessibility
    
    private var accessibilityRepresentation: some View {
        Button(action: {
            goToShop()
        }, label: {
            Text("Sneakers slider" )
        })
        .accessibilityValue("\(sneakers[selectedIndex].title), Shop")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                guard selectedIndex < (sneakers.count - 1) else { break }
                scrollToNext()
            case .decrement:
                guard selectedIndex > 0 else { break }
                scrollToPrevious()
            @unknown default:
                break
            }
        }
    }
    
    private func scrollToNext() {
            guard let id = sneakerID, id != sneakers.last?.id,
                  let index = sneakers.firstIndex(where: { $0.id == id })
            else { return }

            withAnimation {
                sneakerID = sneakers[index + 1].id
            }
        }

        private func scrollToPrevious() {
            guard let id = sneakerID, id != sneakers.first?.id,
                  let index = sneakers.firstIndex(where: { $0.id == id })
            else { return }

            withAnimation {
                sneakerID = sneakers[index - 1].id
            }
        }
}

#Preview {
    SneakersView(sneakers: .data)
}
