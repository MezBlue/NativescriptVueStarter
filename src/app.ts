import { createApp, h, registerElement } from 'nativescript-vue'
import Home from './components/Home.vue'
import { registerSwiftUI, UIDataDriver, SwiftUI } from '@nativescript/swift-ui'
import { FontIconFactory, fonticon } from 'nativescript-fonticon'
import { knownFolders } from '@nativescript/core/file-system'


// Create the Vue 3 app instance
const app = createApp(Home);


// Register SwiftUI components
declare const SampleViewProvider: any
declare const MapKitViewProvider: any
registerSwiftUI('sampleView', (view) => new UIDataDriver(SampleViewProvider.alloc().init(), view))
registerSwiftUI('mapKitView', (view) => new UIDataDriver(MapKitViewProvider.alloc().init(), view))
registerElement('SwiftUIView', () => SwiftUI)


// Font icons configuration
FontIconFactory.paths = {mgc: knownFolders.currentApp().getFile("./assets/mgc.css").readTextSync()}
FontIconFactory.loadCss()
app.config.globalProperties.$fonticon = fonticon



// Start the application
app.start()
