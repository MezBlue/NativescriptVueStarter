<template>
  <GridLayout rows="auto, *">
    <GridLayout row="0" columns="*, *, *" class="p-2 bg-white border-b border-gray-300">
      <Button col="0" text="Add Pin" @tap="addRandomPin" class="btn btn-primary text-sm p-2" />
      <Button col="1" text="Center Map" @tap="centerMap" class="btn btn-primary text-sm p-2" />
      <Button col="2" text="Find Me" @tap="centerOnUser" class="btn btn-primary text-sm p-2" />
    </GridLayout>
    
    <GridLayout row="1">
      <!-- embed the MapKit SwiftUI view with a ref -->
      <SwiftUIView ref="mapView" swiftId="mapKitView" height="100%" />
    </GridLayout>
  </GridLayout>
</template>

<script lang="ts">
export default{
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
      // Get a random location from our predefined list
      const randomIndex = Math.floor(Math.random() * this.locations.length);
      const location = this.locations[randomIndex];
      
      console.log('Adding pin at:', location.title);
      
      // Use the direct approach with the SwiftUI registry
      try {
        // Access the SwiftUI registry directly
        const { SwiftUIManager } = require('@nativescript/swift-ui');
        
        // Create the data to send
        const data = {
          action: 'addPin',
          latitude: location.lat,
          longitude: location.lng,
          title: location.title
        };
        
        // Send the data to the SwiftUI view
        this.sendDataToSwiftUI(data);
      } catch (error) {
        console.error('Error adding pin:', error);
      }
    },
    
    centerMap() {
      console.log('Centering map on San Francisco');
      
      // Create the data to send
      const data = {
        action: 'centerOn',
        latitude: 37.7749,
        longitude: -122.4194
      };
      
      // Send the data to the SwiftUI view
      this.sendDataToSwiftUI(data);
    },
    
    centerOnUser() {
      console.log('Centering map on user location');
      
      // Create the data to send
      const data = {
        action: 'centerOnUser'
      };
      
      // Send the data to the SwiftUI view
      this.sendDataToSwiftUI(data);
    },
    
    // Helper method to send data to the SwiftUI view
    sendDataToSwiftUI(data: any) {
      console.log('Sending data to SwiftUI:', data);
      
      // Try multiple approaches to ensure the data gets through
      
      // Approach 1: Use $refs
      try {
        const mapViewRef = this.$refs.mapView as any;
        if (mapViewRef && mapViewRef.nativeView) {
          console.log('Sending data via $refs');
          mapViewRef.nativeView.data = data;
          return;
        }
      } catch (error) {
        console.error('Error sending data via $refs:', error);
      }
      
      // Approach 2: Use direct registry access
      try {
        const swiftUI = this.findSwiftUIView();
        if (swiftUI) {
          console.log('Sending data via findSwiftUIView');
          swiftUI.data = data;
          return;
        }
      } catch (error) {
        console.error('Error sending data via findSwiftUIView:', error);
      }
      
      console.error('Failed to send data to SwiftUI view');
    },
    
    findSwiftUIView() {
      // Simplest approach: use the $refs to get the SwiftUI view
      try {
        const mapViewRef = this.$refs.mapView as any;
        if (mapViewRef && mapViewRef.nativeView) {
          console.log('Found SwiftUI view through $refs');
          return mapViewRef.nativeView;
        }
      } catch (error) {
        console.error('Error accessing map view through $refs:', error);
      }
      
      // If $refs doesn't work, try a direct approach using the Frame
      try {
        const { Frame } = require('@nativescript/core');
        const page = Frame.topmost().currentPage;
        
        if (page) {
          console.log('Searching for SwiftUI view in page');
          
          // Simple function to find the SwiftUI view by ID
          const findView = (parent: any): any => {
            // Check if this is our view
            if (parent && parent.swiftId === 'mapKitView') {
              return parent;
            }
            
            // Check children
            if (parent && parent.getChildrenCount && typeof parent.getChildrenCount === 'function') {
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
            console.log('Found SwiftUI view in page hierarchy');
            return view;
          }
        }
      } catch (error) {
        console.error('Error searching for SwiftUI view:', error);
      }
      
      console.log('Could not find SwiftUI view');
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
}
</style>
