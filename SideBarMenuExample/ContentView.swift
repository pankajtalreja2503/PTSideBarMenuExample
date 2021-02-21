//
//  ContentView.swift
//  TestPackage
//
//  Created by Pankaj Talreja on 16/02/21.
//

import SwiftUI
import PTSideBarMenu

struct ContentView: View {
    // Controls display of sidebar
    @State private var hideSidebar = true
    @State private var selectedIndex = 0

    /// Items which need to display
    var items = [PTSideBarModel(withtitle: "Home", image: Image(systemName: "house.fill")), PTSideBarModel(withtitle: "Profile", image: Image(systemName: "person.fill")), PTSideBarModel(withtitle: "Email", image: Image(systemName: "envelope.fill")),PTSideBarModel(withtitle: "Contact Us", image: Image(systemName: "phone.fill"))]

    let divider: DividerDesigns = .ZigZag

    var configuration: PTSiderBarConfiguration?
    
    init() {
    
        /// Create the Configuration and set the required parameters(.modifiers)
        self.configuration = try! PTSiderBarConfiguration(dividerdesign: divider, items: items)
        self.configuration?.foregroundColorOfImage = .white
        self.configuration?.sizeOfImage = (20, 20)

    }

    var body: some View {
        
        NavigationView {
            
            ///Entry point and rendering Side Menu on 
                    PTSideBarMenu(selectedRow: { (index) in
                                       selectedIndex = index
                                        hideSidebar.toggle()

                    }, contentView: AnyView(Text(items[selectedIndex].title ?? "No Values")), hideSideBar: $hideSidebar).environmentObject(configuration!)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading:
                                            Button("Tap", action: {
                                                hideSidebar.toggle()
                                            })
                                            .background(Color.white)
                        )
                    .modifier(RedNavigationBar(title: "Test"))

        }
    }
    func    configureBar() -> PTSiderBarConfiguration {
        let divider: DividerDesigns = .ZigZag

        do {
            let configuration = try PTSiderBarConfiguration(dividerdesign: divider, items: items)
            return configuration
        } catch {
            print(error)
            return try! PTSiderBarConfiguration(dividerdesign: .Straight, items: [PTSideBarModel(withTitle: "No Menu to display")])
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


extension View {
    func navigationBarColor(_ backgroundColor: UIColor?, textColor: UIColor?) -> some View {
        modifier(NavigationBarModifier(backgroundColor: backgroundColor, textColor: textColor))
    }
}

struct NavigationBarModifier: ViewModifier {
        
    var backgroundColor: UIColor?
    var textColor: UIColor?
    
    init( backgroundColor: UIColor?, textColor: UIColor?) {
        self.backgroundColor = backgroundColor
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: textColor ?? .black]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: textColor ?? .black]
    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}


struct RedNavigationBar: ViewModifier {
    var title: String
    
    func body(content: Content) -> some View {
        content
            .navigationBarColor(.red, textColor: .white)
            .navigationBarTitle(title)
    }
}
