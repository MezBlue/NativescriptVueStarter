//src/app.ts
import { createApp, registerElement } from 'nativescript-vue'
import { registerSwiftUI, UIDataDriver, SwiftUI } from '@nativescript/swift-ui'
import Home from './components/Home.vue'

// Create the Vue 3 app instance
const app = createApp(Home as any);

// Register SwiftUI components
declare const SampleViewProvider: any;
registerElement('SwiftUIView', () => SwiftUI);
registerSwiftUI('sampleView', (view) => new UIDataDriver(SampleViewProvider.alloc().init(), view));

// Start the application
app.start()