import Foundation
import SwiftUI

public struct HStackSnap<Content: View>: View {

    // MARK: Lifecycle

    @Binding var selectedIndex: Int?

    public init(
        alignment: SnapAlignment,
        selectedIndex: Binding<Int>? = nil,
        spacing: CGFloat? = nil,
        coordinateSpace: String = "SnapToScroll",
        @ViewBuilder content: @escaping () -> Content,
        eventHandler: SnapToScrollEventHandler? = .none) {

        self.content = content
        self._selectedIndex = selectedIndex != nil ? Binding<Int?>(selectedIndex!) : .constant(nil)
        self.alignment = alignment
        self.leadingOffset = alignment.scrollOffset
        self.spacing = spacing
        self.coordinateSpace = coordinateSpace
        self.eventHandler = eventHandler
    }

    // MARK: Public

    public var body: some View {
        
        func calculatedItemWidth(parentWidth: CGFloat, offset: CGFloat) -> CGFloat {
            
            print(parentWidth)
            return parentWidth - offset * 2
        }

        return GeometryReader { geometry in

            HStackSnapCore(
                leadingOffset: leadingOffset,
                selectedIndex: $selectedIndex,
                spacing: spacing,
                coordinateSpace: coordinateSpace,
                content: content,
                eventHandler: eventHandler)
                .environmentObject(SizeOverride(itemWidth: alignment.shouldSetWidth ? calculatedItemWidth(parentWidth: geometry.size.width, offset: alignment.scrollOffset) : .none))
        }
    }

    // MARK: Internal

    var content: () -> Content

    // MARK: Private
    
    private let alignment: SnapAlignment

    /// Calculated offset based on `SnapLocation`
    private let leadingOffset: CGFloat

    private let spacing: CGFloat?

    private var eventHandler: SnapToScrollEventHandler?

    private let coordinateSpace: String
}
