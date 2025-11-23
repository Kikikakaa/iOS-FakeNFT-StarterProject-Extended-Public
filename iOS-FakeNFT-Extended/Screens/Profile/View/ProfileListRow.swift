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
        }
        .padding(.vertical, 16)
    }
}
