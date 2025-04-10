<template>
  <Page>
    <ActionBar>
      <Label :text="currentTab" class="font-bold text-lg" />
    </ActionBar>

    <GridLayout rows="*, auto">
      <!-- Content area -->
      <GridLayout row="0">
        <!-- Feed Tab -->
        <Feed v-if="currentTab === 'Feed'" />
        
        <!-- Discover Tab -->
        <Discover v-if="currentTab === 'Discover'" />
        
        <!-- Create Tab -->
        <Create v-if="currentTab === 'Create'" />
        
        <!-- Profile Tab -->
        <Profile v-if="currentTab === 'Profile'" />
      </GridLayout>
      
      <!-- Bottom Navigation -->
      <GridLayout row="1" columns="*, *, *, *" height="60" class="bg-white border-t border-gray-300">
        <!-- Feed Tab -->
        <StackLayout col="0" @tap="currentTab = 'Feed'" class="p-2" :class="{'bg-gray-100': currentTab === 'Feed'}">
          <Label text="Feed" class="text-center" :class="{'font-bold': currentTab === 'Feed'}" />
        </StackLayout>
        
        <!-- Discover Tab -->
        <StackLayout col="1" @tap="currentTab = 'Discover'" class="p-2" :class="{'bg-gray-100': currentTab === 'Discover'}">
          <Label text="Discover" class="text-center" :class="{'font-bold': currentTab === 'Discover'}" />
        </StackLayout>
        
        <!-- Create Tab -->
        <StackLayout col="2" @tap="currentTab = 'Create'" class="p-2" :class="{'bg-gray-100': currentTab === 'Create'}">
          <Label text="Create" class="text-center" :class="{'font-bold': currentTab === 'Create'}" />
        </StackLayout>
        
        <!-- Profile Tab -->
        <StackLayout col="3" @tap="currentTab = 'Profile'" class="p-2" :class="{'bg-gray-100': currentTab === 'Profile'}">
          <Label text="Profile" class="text-center" :class="{'font-bold': currentTab === 'Profile'}" />
        </StackLayout>
      </GridLayout>
    </GridLayout>
  </Page>
</template>

<script lang="ts">
import Vue from 'nativescript-vue';
import { Utils } from '@nativescript/core';
import Feed from './Feed.vue';
import Discover from './Discover.vue';
import Create from './Create.vue';
import Profile from './Profile.vue';

export default Vue.extend({
  components: {
    Feed,
    Discover,
    Create,
    Profile
  },
  data() {
    return {
      currentTab: 'Feed'
    };
  },
  
  methods: {
    logMessage() {
      console.log('You have tapped the message!');
      Utils.openUrl('mailto://guillaume@akryum.dev');
    },
  },
});
</script>

<style>
/* .info {
    font-size: 20;
  } */
</style>
