import Vue from 'nativescript-vue'
import Home from './components/Home.vue'
import { registerSwiftUI, UIDataDriver, SwiftUI } from '@nativescript/swift-ui'

declare const SampleViewProvider: any
declare const MapKitViewProvider: any

// Register the sample SwiftUI component
registerSwiftUI(
  'sampleView',
  (view) => new UIDataDriver(SampleViewProvider.alloc().init(), view),
)

// Register the MapKit SwiftUI component
registerSwiftUI(
  'mapKitView',
  (view) => new UIDataDriver(MapKitViewProvider.alloc().init(), view),
)

// Register the SwiftUI component globally for Vue templates
Vue.registerElement('SwiftUIView', () => SwiftUI)

declare let __DEV__: boolean;

// Prints Vue logs when --env.production is *NOT* set while building
Vue.config.silent = !__DEV__

new Vue({
  render: (h) => h('frame', [h(Home)]),
}).$start()