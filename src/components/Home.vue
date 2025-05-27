<!--src/components/Home.vue-->
<template>
  <Frame>
    <Page>
      <GridLayout rows="*,*" columns="">
        <GridLayout rows="auto,auto">
          <Label text="SwiftUI View:" class="text-center text-xl" />
          <SwiftUIView
            row="1"
            swiftId="sampleView"
            @swiftUIEvent="handleSwiftUIEvent"
            @loaded="loadedSwiftUI"
            height="200"
          />
        </GridLayout>
        <StackLayout row="1">
          <Label text="Count ref with Vue:" class="text-center" />
          <Label
            col="1"
            row="0"
            :text="data.count"
            class="mt-2 text-center text-xl font-bold"
          />
          <Button
            text="Increment Count With Vue"
            @tap="addCount"
            class="rounded-full bg-green-500 text-white border border-gray-500 p-4 w-[300] mt-6"
          />
          <Button
            text="Reset Count with Vue"
            @tap="resetCount"
            class="rounded-full bg-green-500 text-white border border-gray-500 p-4 w-[300] mt-4"
          />
        </StackLayout>
      </GridLayout>
    </Page>
  </Frame>
</template>

<script lang="ts" setup>
import { ref } from "nativescript-vue";
import { SwiftUI, SwiftUIEventData } from "@nativescript/swift-ui";
import { EventData, GridLayout } from "@nativescript/core";

const data = ref<{ count: number }>({ count: 1 });
let swiftUIView: SwiftUI;

function handleSwiftUIEvent(event: SwiftUIEventData<{ count: number }>) {
  // Handle the event from SwiftUI
  console.log("Received event from SwiftUI:", event.data.count);
  data.value.count = event.data.count;
}
function loadedSwiftUI(event: EventData) {
  swiftUIView = event.object as SwiftUI;
  swiftUIView.data = { count: 1 };
}
function addCount() {
  data.value.count++;
  updateSwiftUI();
}
function resetCount() {
  data.value.count = 1;
  updateSwiftUI();
}
function updateSwiftUI() {
  if (swiftUIView) {
    // Note: always make sure immutable data is passed from Vue to SwiftUI
    swiftUIView.data = {
      ...data.value
    };
    console.log("Updated SwiftUI from Vue:", data.value);
  }
}
</script>

<style></style>
