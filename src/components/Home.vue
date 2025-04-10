<script setup>
import { ref, onMounted, onUnmounted, $navigateTo } from 'nativescript-vue';
import Feed from './Feed.vue';
import Profile from './Profile.vue';
import Explore from './Explore.vue';
import Messages from './Messages.vue';

// Track the active tab
const activeTab = ref('feed');

// Control visibility of create menu and animation states
const showCreateMenu = ref(false);
const menuClosing = ref(false);

// Mock data for user
const currentUser = ref({
  username: 'user123',
  profileImage: '~/assets/profile.png',
  postsCount: 42,
  followersCount: 1024,
  followingCount: 365
});

function navigateToProfile() {
  $navigateTo(Profile, { 
    props: { userId: currentUser.value.username } 
  });
}

// Toggle create menu visibility with animations
function toggleCreateMenu() {
  if (showCreateMenu.value) {
    // Start closing animation
    menuClosing.value = true;
    setTimeout(() => {
      showCreateMenu.value = false;
      menuClosing.value = false;
    }, 300); // Match animation duration
  } else {
    showCreateMenu.value = true;
  }
}

// Handle menu option selection
function handleMenuOption(option) {
  console.log(`Selected option: ${option}`);
  // Handle different options based on selection
  switch(option) {
    case 'profile':
      activeTab.value = 'profile';
      break;
    case 'home':
      activeTab.value = 'feed';
      break;
    // Add more cases as needed
  }
}

onMounted(() => {
  console.log('LandmarkNative mounted');
});

onUnmounted(() => {
  console.log('LandmarkNative unmounted');
});
</script>

<template>
  <Frame>
    <Page actionBarHidden="true">
      <GridLayout rows="auto, *, auto">
        <!-- Header -->
        <!-- <GridLayout row="0" columns="*, auto" class="p-4">
          <Label col="0" text="Landmark" class="font-bold text-2xl" />
          <Label col="1" class="text-2xl" text="📷" @tap="navigateToProfile" />
        </GridLayout> -->

        <!-- Content area -->
        <ContentView row="1">
          <Feed v-if="activeTab === 'feed'" />
          <Explore v-else-if="activeTab === 'explore'" />
          <Profile v-else-if="activeTab === 'profile'" :userId="currentUser.username" />
          <Messages v-else-if="activeTab === 'messages'" />
        </ContentView>
        
        <!-- Bottom navigation -->
        <GridLayout row="2" columns="*, *, *, *, *" class="p-4 navbar">
          <Label
            col="0"
            class="font-mgc text-center text-3xl"
            :text="$fonticon('mgc-home-4-line')"
            :class="activeTab === 'feed' ? 'text-black' : 'text-neutral-300'"
            @tap="activeTab = 'feed'; if(showCreateMenu) toggleCreateMenu();"
          />
          <Label
            col="1"
            class="font-mgc text-center text-3xl"
            :text="$fonticon('mgc-world-2-line')"
            :class="activeTab === 'explore' ? 'text-black' : 'text-neutral-300'"
            @tap="activeTab = 'explore'; if(showCreateMenu) toggleCreateMenu();"
          />
          <Label
            col="2"
            class="font-mgc text-center text-3xl"
            :text="$fonticon('mgc-fullscreen-exit-line')"
            :class="showCreateMenu ? 'text-black' : 'text-neutral-300'"
            @tap="toggleCreateMenu"
          />
          <Label
            col="3"
            :text="$fonticon('mgc-happy-line')"
            class="font-mgc text-center text-3xl"
            :class="activeTab === 'profile' ? 'text-black' : 'text-neutral-300'"
            @tap="activeTab = 'profile'; if(showCreateMenu) toggleCreateMenu();" />
          <Label
            col="4"
            :text="$fonticon('mgc-inbox-2-line')"
            class="font-mgc text-center text-3xl"
            :class="activeTab === 'messages' ? 'text-black' : 'text-neutral-300'"
            @tap="activeTab = 'messages'; if(showCreateMenu) toggleCreateMenu();" />
        </GridLayout>
        
        <!-- Create Menu overlay - positioned to cover only the content area, not the navbar -->
        <GridLayout row="0" rowSpan="2" col="0" colSpan="1" v-if="showCreateMenu" :class="['content-overlay', menuClosing ? 'background-fade-out' : 'background-fade']">
          <!-- Semi-transparent background with fade animation - tap to dismiss -->
          <GridLayout backgroundColor="black" @tap="toggleCreateMenu"></GridLayout>
        </GridLayout>
        
        <!-- Menu container at bottom - positioned directly above navbar but below it in z-index -->
        <GridLayout row="1" col="0" colSpan="1" v-if="showCreateMenu" verticalAlignment="bottom" :class="['menu-container-wrapper', menuClosing ? 'menu-slide-down' : 'menu-slide-up']">
          <StackLayout backgroundColor="white" class="menu-container" @tap="$event.stopPropagation()">
            <Label text="What do you want to do?" class="font-bold text-lg text-center p-2" />
            
            <!-- Four options in a 2x2 grid -->
            <GridLayout rows="auto" columns="*, *, *, *" class="p-2">
              <StackLayout row="0" col="0" class="bg-neutral-100 rounded-lg m-1 p-4" width="70" height="70" @tap="handleMenuOption('capture'); toggleCreateMenu()">
                <Label class="font-mgc text-center text-4xl" :text="$fonticon('mgc-camera-2-ai-line')" />
              </StackLayout>
              
              <StackLayout row="0" col="1" class="bg-neutral-100 rounded-lg m-1 p-4" width="70" height="70" @tap="handleMenuOption('post'); toggleCreateMenu()">
                <Label class="font-mgc text-center text-4xl" :text="$fonticon('mgc-photo-album-line')" />
              </StackLayout>
              
              <StackLayout row="0" col="2" class="bg-neutral-100 rounded-lg m-1 p-4" width="70" height="70" @tap="handleMenuOption('plan'); toggleCreateMenu()">
                <Label class="font-mgc text-center text-4xl" :text="$fonticon('mgc-tree-4-line')" />
              </StackLayout>
              
              <StackLayout row="0" col="3" class="bg-neutral-100 rounded-lg m-1 p-4" width="70" height="70" @tap="handleMenuOption('location'); toggleCreateMenu()">
                <Label class="font-mgc text-center text-4xl" :text="$fonticon('mgc-live-location-fill')" />
              </StackLayout>
            </GridLayout>
          </StackLayout>
        </GridLayout>
      </GridLayout>
    </Page>
  </Frame>
</template>

<style>
.active-tab {
  color: #3498db;
}

.navbar {
  background-color: white;
  z-index: 1000;
}

.content-overlay {
  z-index: 900;
}

.menu-container-wrapper {
  z-index: 950;
}

.menu-container {
  width: 100%;
  border-radius: 24 24 0 0;
  padding-bottom: 8;
  margin-bottom: 0; /* Space for navbar */
}

/* Menu options now use Tailwind classes directly */

.menu-slide-up {
  width: 100%;
  animation-name: slideUp;
  animation-duration: 0.2s;
  animation-timing-function: ease-out;
  animation-fill-mode: forwards;
}

.menu-slide-down {
  width: 100%;
  animation-name: slideDown;
  animation-duration: 0.2s;
  animation-timing-function: ease-in;
  animation-fill-mode: forwards;
}

.background-fade {
  opacity: 0;
  animation-name: fadeIn;
  animation-duration: 0.2s;
  animation-timing-function: ease-out;
  animation-fill-mode: forwards;
}

.background-fade-out {
  opacity: 0.5;
  animation-name: fadeOut;
  animation-duration: 0.2s;
  animation-timing-function: ease-in;
  animation-fill-mode: forwards;
}

@keyframes slideUp {
  from { transform: translateY(150%); }
  to { transform: translateY(0); }
}

@keyframes slideDown {
  from { transform: translateY(0); }
  to { transform: translateY(150%); }
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 0.5; }
}

@keyframes fadeOut {
  from { opacity: 0.5; }
  to { opacity: 0; }
}
</style>
