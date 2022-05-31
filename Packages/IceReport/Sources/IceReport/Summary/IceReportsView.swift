import Foundation
import SwiftUI

struct IceReportsView: View {
    
    @ObservedObject var viewModel: IceReportViewModel
    let coordinator: IceReportCoordinator
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .success(let iceReports):
                List(iceReports) { iceReport in
                    Button {
                        coordinator.didPressSummary(iceReport)
                    } label: {
                        IceReportItem(name: iceReport.name,
                                      distance: iceReport.distanceString,
                                      icon: iceReport.status.iconName,
                                      iconColor: iceReport.status.color)
                    }
                }
            case .failure(let error):
                VStack {
                    Text(error.localizedDescription)
                    Button("Try again") {
                        Task {
                            await viewModel.getReports()
                        }
                    }
                }
                
            }
        }
        .task {
            await viewModel.getReports()
        }

    }
}

struct IceReportItem: View {
    let name: String
    let distance: String
    let icon: String
    let iconColor: Color
    var body: some View {
        HStack {
            Group {
                VStack(alignment: .leading) {
                    Text(name)
                    HStack {
                        Image(systemName: "location")
                        Text(distance)
                    }
                    .font(.caption)
                }
                Spacer()
                Image(systemName: icon)
                    .foregroundColor(iconColor)
            }
            .foregroundColor(.primary)
        }
    }
}
