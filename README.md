# SwiftModalPresentation

A simple library to safely present sheet and other modals in SwiftUI.  
It is meant to solve this kind of issues:  
```
Currently, only presenting a single sheet is supported.
The next sheet will be presented when the currently presented sheet gets dismissed.
```

## Usage

The library is meant to be a drop-in replacement for presenting sheets with `@State` or `@Published`.  
If you try to present a new sheet while an already existing one is presented, it will automatically close the previous sheet before showing the new one.

For `@State` with `@ModalState`  
```Swift
struct ContentView: View {
    @ModalState private var isShowingSheet1 = false
    @ModalState private var isShowingSheet2 = false
    
    var body: some View {
        VStack {
            Button("Show sheet 1") {
                isShowingSheet1 = true
            }
        }
        .sheet(isPresented: $isShowingSheet1) {
            VStack {
                Text("Sheet 1")
                Button("Show sheet 2") {
                    isShowingSheet2 = true
                }
            }
        }
        .sheet(isPresented: $isShowingSheet2) {
            Text("Sheet 2")
        }
    }
}
```

For `@Published` in an `ObservableObject` with `@ModalPublished`  
```Swift
class SomeObject: ObservableObject {
    @ModalPublished var isShowingSheet1 = false
    @ModalPublished var isShowingSheet2 = false
}

struct ContentView: View {
    @StateObject private var someObject = SomeObject()

    var body: some View {
        VStack {
            Button("Show sheet 1") {
                someObject.isShowingSheet1 = true
            }
        }
        .sheet(isPresented: $someObject.isShowingSheet1) {
            VStack {
                Text("Sheet 1")
                Button("Show sheet 2") {
                    someObject.isShowingSheet2 = true
                }
            }
        }
        .sheet(isPresented: $someObject.isShowingSheet2) {
            Text("Sheet 2")
        }
    }
}
```

Optionally you can provide a context to the `ModalState/Published(context: "SomeContextKey")` to open nested sheets within the same view.  

## Licence

This package is available under the permissive ApacheV2 licence for you to enjoy. 
