<template>
  <GridLayout rows="*">
    <ScrollView>
      <StackLayout>
        <!-- Header with placeholder for globe -->
        <GridLayout rows="auto" class="passport-header">
          <StackLayout backgroundColor="#003366" height="200" />
          <GridLayout columns="auto, *, auto" class="p-4">
            <Label col="0" class="font-mgc text-white text-2xl" :text="$fonticon('mgc-arrow-left-line')" @tap="goBack" />
            <Label col="1" text="LANDMARK PASSPORT" class="text-white text-lg font-bold text-center" />
            <Label col="2" class="font-mgc text-white text-2xl" :text="$fonticon('mgc-menu-line')" />
          </GridLayout>
        </GridLayout>

        <!-- Travel Card -->
        <StackLayout class="bg-white rounded-t-3xl -mt-4 pt-4">
          <!-- Travel Card -->
          <GridLayout rows="auto" class="mx-2 my-4 travel-card">
            <Image src="~/assets/TravelCard.png" stretch="aspectFill" class="rounded-xl" width="100%" />
            
            <!-- Stats overlay with vertical centering -->
            <GridLayout rows="auto, *, auto" columns="*, *" class="p-4" verticalAlignment="center">
              <!-- Empty space at top to maintain layout -->
              <Label row="0" colSpan="2" text=" " class="text-white text-md mb-2" />
              
              <!-- Stats container with vertical centering -->
              <GridLayout row="1" colSpan="2" rows="auto, auto" columns="*, *" verticalAlignment="center">
                <!-- Left column stats -->
                <StackLayout row="0" col="0" class="text-left">
                  <Label text="Flights" class="text-white text-xs" />
                  <Label :text="flightsCount.toString()" class="text-white text-3xl font-bold" />
                </StackLayout>
                
                <!-- Right column stats -->
                <StackLayout row="0" col="1" class="text-right">
                  <Label text="Air Distance" class="text-white text-xs" />
                  <Label :text="airDistance + ' mi'" class="text-white text-3xl font-bold" />
                </StackLayout>
                
                <!-- Left column stats -->
                <StackLayout row="1" col="0" class="text-left mt-3">
                  <Label text="Road Trips" class="text-white text-xs" />
                  <Label :text="roadTripsCount.toString()" class="text-white text-3xl font-bold" />
                </StackLayout>
                
                <!-- Right column stats -->
                <StackLayout row="1" col="1" class="text-right mt-3">
                  <Label text="Road Distance" class="text-white text-xs" />
                  <Label :text="roadDistance + ' mi'" class="text-white text-3xl font-bold" />
                </StackLayout>
              </GridLayout>
              
              <!-- Details button at bottom left -->
              <Button row="2" colSpan="2" horizontalAlignment="left" text="All Details" class="text-white bg-transparent border border-white w-2/3 rounded-lg mt-3 h-10 text-sm" />
            </GridLayout>
          </GridLayout>
          
          <!-- Travel Stats Section -->
          <StackLayout class="p-4">
            <Label text="Travel Statistics" class="text-xl font-bold mb-2" />
            
            <!-- Countries Visited -->
            <GridLayout rows="auto" columns="auto, *" class="mb-4">
              <Label col="0" class="font-mgc text-3xl mr-2" :text="$fonticon('mgc-earth-2-line')" />
              <StackLayout col="1">
                <Label text="Countries Visited" class="text-sm text-gray-500" />
                <Label :text="countriesVisited.toString()" class="text-lg font-bold" />
              </StackLayout>
            </GridLayout>
            
            <!-- Cities Explored -->
            <GridLayout rows="auto" columns="auto, *" class="mb-4">
              <Label col="0" class="font-mgc text-3xl mr-2" :text="$fonticon('mgc-building-4-line')" />
              <StackLayout col="1">
                <Label text="Cities Explored" class="text-sm text-gray-500" />
                <Label :text="citiesExplored.toString()" class="text-lg font-bold" />
              </StackLayout>
            </GridLayout>
            
            <!-- Landmarks Visited -->
            <GridLayout rows="auto" columns="auto, *" class="mb-4">
              <Label col="0" class="font-mgc text-3xl mr-2" :text="$fonticon('mgc-flag-line')" />
              <StackLayout col="1">
                <Label text="Landmarks Visited" class="text-sm text-gray-500" />
                <Label :text="landmarksVisited.toString()" class="text-lg font-bold" />
              </StackLayout>
            </GridLayout>
            
            <!-- Photos Taken -->
            <GridLayout rows="auto" columns="auto, *" class="mb-4">
              <Label col="0" class="font-mgc text-3xl mr-2" :text="$fonticon('mgc-camera-3-line')" />
              <StackLayout col="1">
                <Label text="Photos Taken" class="text-sm text-gray-500" />
                <Label :text="photosTaken.toString()" class="text-lg font-bold" />
              </StackLayout>
            </GridLayout>
          </StackLayout>
          
          <!-- Recent Trips -->
          <StackLayout class="p-4 border-t border-gray-200">
            <Label text="Recent Trips" class="text-xl font-bold mb-4" />
            
            <StackLayout v-for="(trip, index) in recentTrips" :key="index" class="mb-4 p-4 bg-gray-100 rounded-lg">
              <GridLayout rows="auto" columns="auto, *, auto">
                <Label col="0" class="font-mgc text-3xl mr-2" :text="$fonticon(trip.icon)" />
                <StackLayout col="1">
                  <Label :text="trip.destination" class="text-lg font-bold" />
                  <Label :text="trip.date" class="text-sm text-gray-500" />
                </StackLayout>
                <Label col="2" class="font-mgc text-xl" :text="$fonticon('mgc-arrow-right-s-line')" />
              </GridLayout>
            </StackLayout>
            
            <Button text="View All Trips" class="bg-gray-200 rounded-lg h-12 mt-2" />
          </StackLayout>
        </StackLayout>
      </StackLayout>
    </ScrollView>
  </GridLayout>
</template>

<script>
export default {
  name: 'Feed',
  data() {
    return {
      flightsCount: 2,
      roadTripsCount: 20,
      airDistance: '1,983',
      roadDistance: '20,000',
      countriesVisited: 5,
      citiesExplored: 28,
      landmarksVisited: 42,
      photosTaken: 1256,
      recentTrips: [
        {
          destination: 'New York City, USA',
          date: 'March 15-20, 2025',
          icon: 'mgc-building-4-line'
        },
        {
          destination: 'Grand Canyon, USA',
          date: 'February 5-10, 2025',
          icon: 'mgc-mountain-line'
        },
        {
          destination: 'Miami Beach, USA',
          date: 'January 1-8, 2025',
          icon: 'mgc-sun-line'
        }
      ]
    }
  },
  methods: {
    goBack() {
      this.$emit('back');
    }
  }
}
</script>

<style scoped>
.passport-header {
  position: relative;
}

.card-container {
  border-radius: 16;
  overflow: hidden;
}

.travel-card {
  margin-left: 16;
  margin-right: 16;
}
  </style>