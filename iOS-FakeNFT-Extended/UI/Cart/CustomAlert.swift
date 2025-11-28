import SwiftUI

struct CustomAlert<Content: View>: View {
    let isPresented: Binding<Bool>
    let onCancel: () -> Void
    let onRetry: () -> Void
    let content: Content

    init(
        isPresented: Binding<Bool>,
        onCancel: @escaping () -> Void,
        onRetry: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.isPresented = isPresented
        self.onCancel = onCancel
        self.onRetry = onRetry
        self.content = content()
    }

    var body: some View {
        if isPresented.wrappedValue {
            ZStack {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    content
                        .padding(.vertical, 16)
                        .padding(.horizontal, 12)

                    Divider()

                    HStack(spacing: 0) {
                        Button(action: {
                            withAnimation { isPresented.wrappedValue = false }
                            onCancel()
                        }) {
                            Text("Отмена")
                                .font(.bodyRegular)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(height: 42.5)

                        Divider()

                        Button(action: {
                            withAnimation { isPresented.wrappedValue = false }
                            onRetry()
                        }) {
                            Text("Повторить")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(height: 42.5)
                    }
                }
                .background(.thickMaterial)
                .cornerRadius(14)
                .frame(maxWidth: 270)
                .fixedSize(horizontal: false, vertical: true)
                .shadow(radius: 20)
            }
            .transition(.opacity)
        }
    }
}
