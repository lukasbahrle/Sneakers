import SwiftUI

struct SneakersAccessibility: View {
    let sneakers: [Sneaker]
    @Binding var sneakerID: Sneaker.ID?
    let selectedIndex: Int
    let goToShop: () -> Void
    
    var body: some View {
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
