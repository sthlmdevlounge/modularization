import SwiftUI
import SwiftUIHelpers

struct AddReportView: View {
    
    struct State {
        var name: String
        var status: IceReportStatus
    }
    
    @ObservedObject var observed: Observing<State>
    
    var didPressSave: (AddReportView.State) -> Void
    
    var body: some View {
        List {
            Section(header: Text("Name")) {
                TextField("Name", text: $observed.name)
            }
            Section(header: Text("Status")) {
                Menu(content: {
                    Picker(selection: $observed.status, label: Text("Status")) {
                        ForEach(IceReportStatus.allCases, id: \.self) { status in
                            Text(status.rawValue)
                        }
                    }
                }, label: {
                    Text(observed.status.rawValue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
            }
            Button("Save") {
                didPressSave(observed.value)
            }
        }
    }
}
