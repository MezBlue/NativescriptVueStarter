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

// Register the sample view if available
try {
  if (typeof SampleViewProvider !== 'undefined') {
    console.log('Registering SampleViewProvider with SwiftUI');
    registerSwiftUI('sampleView', (view) => new UIDataDriver(SampleViewProvider.alloc().init(), view));
  } else {
    console.log('SampleViewProvider not found');
  }
} catch (error) {
  console.error('Error registering SampleViewProvider:', error);
}

// Register the MapKit view if available
try {
  if (typeof MapKitViewProvider !== 'undefined') {
    console.log('Registering MapKitViewProvider with SwiftUI');
    registerSwiftUI('mapKitView', (view) => new UIDataDriver(MapKitViewProvider.alloc().init(), view));
  } else {
    console.error('MapKitViewProvider not found in global scope');
  }
} catch (error) {
  console.error('Error registering MapKitViewProvider:', error);
}

// Register the SwiftUIView element globally
registerElement('SwiftUIView', () => SwiftUI)


// Font icons configuration
FontIconFactory.paths = {mgc: knownFolders.currentApp().getFile("./assets/mgc.css").readTextSync()}
FontIconFactory.loadCss()
app.config.globalProperties.$fonticon = fonticon



// Start the application
app.start()
