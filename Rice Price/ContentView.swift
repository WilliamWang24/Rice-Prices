//
//  ContentView.swift
//  Rice Price
//
//  Created by William Wang on 11/24/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        VStack(alignment:.leading) {
            Spacer()
            
            textView(color: .orange, title: "Get Started", substitle: "Use the Widget", bodyText: "Hold your home screen and press the plus button on the top left. Search up Rice Price. Click to add the widget.")

            Spacer()
            textView(color: .red, title: "How it works", substitle: "Widget Details", bodyText: "We scrape information from Market Business Insider every 15 minutes for the current price for 100lbs of rice and recent changes by percent and value.")
            Spacer()

            
            Group {
                Text("Credits")
                    .bold()
                    .font(.title2)
                    .padding(.bottom, 5)
                Button {
                    openURL(URL(string: "https://markets.businessinsider.com")!)
                } label: {
                    Text("Market Business Insider")
                        .foregroundColor(.indigo)
                        .underline()
                        .font(.headline)
                }
                Text("We uses their site for the data.")
                    .padding(.bottom, 5)

                Button {
                    openURL(URL(string: "https://github.com/scinfu/SwiftSoup")!)
                } label: {
                    Text("SwiftSoup")
                        .foregroundColor(.blue)
                        .underline()
                        .font(.headline)
                }
                
                Text("We uses their framework to scrape the data.")
            }
            
            Spacer()
            
            Group {
                Text("Support this project")
                    .bold()
                    .font(.title2)
                    .padding(.bottom, 5)
                Button("🌟 Star on GitHub") {
                    openURL(URL(string: "https://github.com/scinfu/SwiftSoup")!)
                }
                .buttonStyle(.bordered)
                .tint(.green)
            }
            

            Spacer()
            
            Group {
                Text("Created by William Wang")
                    .bold()
                    .padding(.bottom, 1)
                Button {
                    openURL(URL(string: "https://markets.businessinsider.com")!)
                } label: {
                    HStack {
                        Image("github")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                        Text("GitHub Repository")
                            .foregroundColor(.black)
                            .underline()
                    }
                }
               
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct textView: View {
    let color: Color
    let title:String
    let substitle:String
    let bodyText: String
    var body: some View {
        Text(substitle)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(color)
      
        Text(title)
            .bold()
            .font(.title)
            .padding(.bottom, 5)
        
        Text(bodyText)
    }
}
