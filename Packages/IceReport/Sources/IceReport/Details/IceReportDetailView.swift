import SwiftUI

struct IceReportDetailView: View {
    
    let coordinator: IceReportCoordinator
    @ObservedObject var viewModel: IceReportDetailViewModel
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Distance from you")
                    Spacer()
                    Text(viewModel.summary.distanceString)
                }
                HStack {
                    Text("Status")
                    Spacer()
                    Text(viewModel.summary.status.rawValue)
                        .foregroundColor(viewModel.summary.status.color)
                }
            }
            Section(header: ListHeader(didTapAddNewReport: {
                coordinator.didPressAddNewReport { result in
                    viewModel.didPressSave(name: result.name, status: result.status)
                }
            })) {
                ForEach(viewModel.summary.reports) { report in
                    HStack {
                        Label(report.reporter, systemImage: report.status.iconName)
                            .foregroundColor(report.status.color)
                        Spacer()
                        Text(report.date, style: .date)
                    }
                }
            }
        }
    }
}

struct ListHeader: View {
    let didTapAddNewReport: @MainActor () -> Void
    var body: some View {
        HStack {
            Text("Reports")
                .font(.headline)
            Spacer()
            Button {
                didTapAddNewReport()
            } label: {
                Label("", systemImage: "plus")
                    .labelStyle(.iconOnly)
                    .font(.system(size: 24))
            }
        }
    }
}
