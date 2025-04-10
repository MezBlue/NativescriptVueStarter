<template>
  <StackLayout>
    <!-- A header label for context -->
    <Label text="Feed Content" class="h2 text-center" />
    
    <!-- Container with fixed height -->
    <GridLayout height="300">
      <SwiftUIView
        swiftId="sampleView"
        :data="nativeCount"
        @swiftUIEvent="onEvent"
        @loaded="loadedSwiftUI"
        ref="swiftui"
      />
    </GridLayout>
    
    <!-- Display the current count from the NativeScript side -->
    <Label :text="'NativeScript Label: ' + nativeCount.count" class="h2" />
    
    <!-- Buttons to update the count -->
    <Button text="NativeScript data bindings: Decrement"
            @tap="updateNativeScriptData"
            class="btn btn-primary" />
    <Button text="SwiftUI data bindings: Decrement"
            @tap="updateSwiftData"
            class="btn btn-primary" />
  </StackLayout>
</template>


<script>
export default {
  name: 'Feed',
  data() {
    return {
      // nativeCount mirrors the CountData used in the tutorial
      nativeCount: { count: 0 },
      // We'll hold the SwiftUI instance when it is loaded
      swiftui: null,
    };
  },
  methods: {
  loadedSwiftUI(args) {
    try {
      this.swiftui = args.object;
    } catch (e) {
      console.error('Error in loadedSwiftUI:', e);
    }
  },
  onEvent(evt) {
    try {
      this.nativeCount = { count: evt.data.count };
    } catch (e) {
      console.error('Error in onEvent:', e);
    }
  },
  updateNativeScriptData() {
    try {
      this.nativeCount = { count: this.nativeCount.count - 1 };
    } catch (e) {
      console.error('Error in updateNativeScriptData:', e);
    }
  },
  updateSwiftData() {
    try {
      if (this.swiftui && typeof this.swiftui.updateData === "function") {
        this.swiftui.updateData({ count: this.nativeCount.count - 1 });
      }
    } catch (e) {
      console.error('Error in updateSwiftData:', e);
    }
  }
}
};
</script>

<style scoped>
.h2 {
  font-size: 20;
  margin: 10;
  text-align: center;
}

.btn {
  margin: 10;
  padding: 10;
}

.btn-primary {
  background-color: #3b82f6;
  color: white;
}
</style>
