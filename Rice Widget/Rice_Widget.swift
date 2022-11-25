import WidgetKit
import SwiftUI
import Intents
import Foundation
import SwiftSoup

struct Rice: TimelineEntry, Codable {
    var date: Date = .init()
    let price: String
    let change: String
    let percentChange: String
    init(price: String, change:String, percentChange:String) {
        self.price = price
        self.change = change
        self.percentChange = percentChange
      }
}

class scraping {
    static func classicalscraping() -> Rice  {
        let url = URL(string:"https://markets.businessinsider.com/commodities/rice-price")!
        let html = try! String(contentsOf: url)
        let document = try! SwiftSoup.parse(html)
        let currentValue = try! document.select(".price-section__current-value").text()
        let absoluteValue = try! document.select(".price-section__absolute-value").text()
        let relativeValue = try! document.select(".price-section__relative-value").text()
        return Rice(price: currentValue, change: absoluteValue, percentChange: relativeValue)
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Rice {Rice(price: "0.0", change: "0.0", percentChange: "0.0")}
    func getSnapshot(in context: Context, completion: @escaping (Rice) -> ()) {let entry = Rice(price: "0.0", change: "0.0", percentChange: "0.0")
        completion(entry)}
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
       let currentDate = Date()
        var riceData = scraping.classicalscraping()
        riceData.date = currentDate
        let nextUpdate = Calendar.current.date(byAdding: .minute,value: 15, to: currentDate)!
        let timeline = Timeline(entries: [riceData], policy: .after(nextUpdate))
                completion(timeline)
    }
}

struct WidgetEntryView : View {
    var crypto: Provider.Entry
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Image("rice")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .frame(width: 20)
                    .padding(5)
                    .background(Color.brown.opacity(0.7))
                    .cornerRadius(20)

                Text("100lbs")
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .font(.callout)
            }
            
            Text("$" + crypto.price)
                .font(.system(size: 33))
                .bold()
            HStack {
                if (crypto.change.contains("-")) {
                    plusOrMinusView(color: .red, dropFirst: 1, change: crypto.change, percentChange: crypto.percentChange, upOrDown: "down")
                } else {
                    plusOrMinusView(color: .green, dropFirst: 0, change: crypto.change, percentChange: crypto.percentChange, upOrDown: "up")
                }
            }
        }.padding(20)
    }
}

@main
struct Rice_Widget: Widget {
    let kind: String = "Widget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in WidgetEntryView(crypto: entry)}
        .configurationDisplayName("Rice Prices Widget")
        .description("Updates rice prices per 100lbs every 15 minutes.")
        .supportedFamilies([.systemSmall])
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(crypto: Rice(price: "0.0", change: "0.0", percentChange: "0.0")).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct plusOrMinusView: View {
    let color: Color
    let dropFirst: Int
    let change: String
    let percentChange: String
    let upOrDown: String
    var body: some View {
        Image(systemName: ("arrow.\(upOrDown)"))
            .foregroundColor(color)
        Spacer()
            .frame(maxWidth: 4)
        Text(change.dropFirst(dropFirst))
            .font(.subheadline)
            .bold()
        Text(percentChange.dropFirst(dropFirst))
            .bold()
            .font(.footnote)
            .foregroundColor(color)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(color.opacity(0.30))
            .cornerRadius(20)
    }
}
