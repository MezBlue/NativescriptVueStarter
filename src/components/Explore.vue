<!-- src/components/Explore.vue -->
<template>
  <GridLayout rows="auto, *">
    <GridLayout row="0" columns="*,*,*" class="p-2 bg-white border-b border-gray-300">
      <Button
        col="0"
        text="Add Pin"
        @tap="addRandomPin"
        class="btn btn-primary text-sm p-2" />
      <Button
        col="1"
        text="Center Map"
        @tap="centerMap"
        class="btn btn-primary text-sm p-2" />
      <Button
        col="2"
        text="Find Me"
        @tap="centerOnUser"
        class="btn btn-primary text-sm p-2" />
    </GridLayout>
    
    <GridLayout row="1">
      <!-- Embed the SwiftUI MapKit view using swiftId="mapKitView" and a ref -->
      <SwiftUIView ref="mapView" swiftId="mapKitView" height="100%" />
    </GridLayout>
  </GridLayout>
</template>

<script lang="ts">
export default {
  name: 'Explore',
  data() {
    return {
      locations: [
        { lat: 40.7128, lng: -74.0060, title: 'New York' },
        { lat: 34.0522, lng: -118.2437, title: 'Los Angeles' },
        { lat: 41.8781, lng: -87.6298, title: 'Chicago' },
        { lat: 29.7604, lng: -95.3698, title: 'Houston' },
        { lat: 37.7749, lng: -122.4194, title: 'San Francisco' }
      ]
    };
  },
  methods: {
    addRandomPin() {
      const randomIndex = Math.floor(Math.random() * this.locations.length);
      const location = this.locations[randomIndex];
      console.log('Adding pin at:', location.title);
      
      const data = {
        action: 'addPin',
        latitude: location.lat,
        longitude: location.lng,
        title: location.title
      };
      this.sendDataToSwiftUI(data);
    },
    centerMap() {
      console.log('Centering map on San Francisco');
      const data = {
        action: 'centerOn',
        latitude: 37.7749,
        longitude: -122.4194
      };
      this.sendDataToSwiftUI(data);
    },
    centerOnUser() {
      console.log('Centering map on user location');
      const data = {
        action: 'centerOnUser'
      };
      this.sendDataToSwiftUI(data);
    },
    // Method to call updateData on the SwiftUI view.
    sendDataToSwiftUI(data: any) {
      console.log('Sending data to SwiftUI:', data);
      try {
        const mapViewRef = this.$refs.mapView as any;
        if (mapViewRef && mapViewRef.nativeView && typeof mapViewRef.nativeView.updateData === 'function') {
          console.log('Sending data via $refs using updateData');
          mapViewRef.nativeView.updateData(data);
          return;
        } else {
          console.error('nativeView or updateData not available on $refs.mapView');
        }
      } catch (error) {
        console.error('Error sending data via $refs:', error);
      }
      
      // Fallback: attempt to locate SwiftUI view in the page hierarchy.
      try {
        const swiftUI = this.findSwiftUIView();
        if (swiftUI && typeof swiftUI.updateData === 'function') {
          console.log('Sending data via findSwiftUIView using updateData');
          swiftUI.updateData(data);
          return;
        } else {
          console.error('updateData not found via findSwiftUIView');
        }
      } catch (error) {
        console.error('Error sending data via findSwiftUIView:', error);
      }
      
      console.error('Failed to send data to SwiftUI view');
    },
    findSwiftUIView() {
      try {
        const mapViewRef = this.$refs.mapView as any;
        if (mapViewRef && mapViewRef.nativeView) {
          console.log('Found SwiftUI view via $refs');
          return mapViewRef.nativeView;
        }
      } catch (error) {
        console.error('Error accessing map view via $refs:', error);
      }
      
      try {
        const { Frame } = require('@nativescript/core');
        const page = Frame.topmost().currentPage;
        if (page) {
          console.log('Searching for SwiftUI view in page hierarchy');
          const findView = (parent: any): any => {
            if (parent && parent.swiftId === 'mapKitView') {
              return parent;
            }
            if (parent && typeof parent.getChildrenCount === 'function') {
              const count = parent.getChildrenCount();
              for (let i = 0; i < count; i++) {
                const child = parent.getChildAt(i);
                const result = findView(child);
                if (result) return result;
              }
            }
            return null;
          };
          const view = findView(page);
          if (view) {
            console.log('Found SwiftUI view in hierarchy');
            return view;
          }
        }
      } catch (error) {
        console.error('Error searching view hierarchy:', error);
      }
      
      console.log('SwiftUI view not found');
      return null;
    }
  }
};
</script>

<style scoped>
.btn {
  background-color: #4CAF50;
  color: white;
  border-radius: 4;
  margin: 2;
  padding: 4;
  font-size: 12px;
}
</style>
