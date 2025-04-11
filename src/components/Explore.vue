<!-- src/components/Explore.vue -->
<template>
  <GridLayout rows="auto, *">
    <!-- Top row: buttons -->
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
    
    <!-- Bottom row: embed the MapKit SwiftUI view -->
    <GridLayout row="1">
      <SwiftUIView ref="mapView" swiftId="mapKitView" height="100%" />
    </GridLayout>
  </GridLayout>
</template>

<script lang="ts">
export default {
  name: 'Explore',
  data() {
    return {
      // List of locations (for adding random pins)
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
      const loc = this.locations[randomIndex];
      console.log('Adding pin at:', loc.title);
      const data = {
        action: 'addPin',
        latitude: loc.lat,
        longitude: loc.lng,
        title: loc.title
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
    // Sends data to the native view by calling updateData on the SwiftUI view.
    sendDataToSwiftUI(data: any) {
      console.log('Sending data to SwiftUI:', data);
      try {
        const mapViewRef = this.$refs.mapView as any;
        if (mapViewRef && mapViewRef.nativeView && typeof mapViewRef.nativeView.updateData === 'function') {
          mapViewRef.nativeView.updateData(data);
          return;
        } else {
          console.error('nativeView or updateData not available on $refs.mapView');
        }
      } catch (error) {
        console.error('Error sending data via $refs:', error);
      }
      console.error('Failed to send data to SwiftUI view');
    }
  }
};
</script>

<style scoped>
.btn {
  margin: 4px;
  padding: 8px;
}
</style>
