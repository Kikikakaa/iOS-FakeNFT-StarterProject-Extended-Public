import SwiftUI

struct ProfileListRow: View {
    let title: String
    let count: String?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(uiColor: .label))
            
            if let count = count {
                Text(count)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(uiColor: .label))
            }
            
            Spacer()
            
            Image("Chevron.forward")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 8, height: 14)
                .foregroundStyle(Color(uiColor: .label))
                .padding(.leading, 16)
        }
        .padding(.vertical, 16)
        .contentShape(Rectangle())
    }
}
