<template>
  <GridLayout rows="*, auto">
    <ScrollView row="0">
      <StackLayout>
        <!-- Header with gray background -->
        <GridLayout rows="auto" class="profile-header">
          <StackLayout backgroundColor="#888888" height="200" />
          <GridLayout columns="auto, *, auto" class="p-4">
            <Label col="0" class="font-mgc text-white text-2xl" :text="$fonticon('mgc-arrow-left-line')" @tap="goBack" />
            <Label col="1" :text="'@' + username" class="text-white text-md font-bold text-center" />
            <Label col="2" class="font-mgc text-white text-2xl" :text="$fonticon('mgc-menu-line')" />
          </GridLayout>
        </GridLayout>

        <!-- User profile card -->
        <StackLayout class="bg-white rounded-t-3xl -mt-4 pt-4">
          <!-- Profile info section -->
          <GridLayout rows="auto, auto" columns="auto, *" class="p-4">
            <Image :src="profileImage || '~/assets/profile.png'" class="w-20 h-20 rounded-full bg-neutral-200 mr-4" row="0" col="0" rowspan="2" />
            <GridLayout row="0" col="1" columns="*, *, *" class="ml-2 mt-2">
              <StackLayout col="0" class="text-center">
                <Label :text="postsCount.toString()" class="font-bold text-lg" />
                <Label text="Posts" class="text-sm text-gray-500" />
              </StackLayout>
              <StackLayout col="1" class="text-center">
                <Label :text="followersCount.toString()" class="font-bold text-lg" />
                <Label text="Followers" class="text-sm text-gray-500" />
              </StackLayout>
              <StackLayout col="2" class="text-center">
                <Label :text="likesCount.toString()" class="font-bold text-lg" />
                <Label text="Likes" class="text-sm text-gray-500" />
              </StackLayout>
            </GridLayout>
            <Button row="1" col="1" text="Edit Profile" class="-mt-5 bg-transparent border border-gray-300 rounded-lg h-8 text-sm" />
          </GridLayout>
          
          <!-- Bio section -->
          <StackLayout class="px-4 pb-4">
            <Label :text="displayName" class="font-bold text-base" />
            <Label text="Photography | Travel | Food" class="text-sm mt-0.5" />
            <Label text="www.instagram.com" class="text-sm mt-0.5 text-blue-500" />
          </StackLayout>
          
          <!-- Tab navigation -->
          <GridLayout rows="auto" columns="auto, auto, auto, auto" class="tab-navigation p-2 border-b border-gray-200">
            <Label col="0" text="All Posts" class="tab-item p-2" :class="{'active-tab': activeTab === 'posts'}" @tap="activeTab = 'posts'" />
            <Label col="1" text="Private" class="tab-item p-2" :class="{'active-tab': activeTab === 'private'}" @tap="activeTab = 'private'" />
            <Label col="2" text="Tagged" class="tab-item p-2" :class="{'active-tab': activeTab === 'tagged'}" @tap="activeTab = 'tagged'" />
            <Label col="3" text="Check Ins" class="tab-item p-2" :class="{'active-tab': activeTab === 'checkins'}" @tap="activeTab = 'checkins'" />
          </GridLayout>
          
          <!-- Content based on active tab -->
          <GridLayout rows="auto" class="p-1">
            <!-- Posts grid -->
            <GridLayout v-if="activeTab === 'posts'" columns="1*, 1*" rows="auto, auto, auto" class="m-1">
              <StackLayout v-for="(item, index) in posts" :key="index"
                :row="Math.floor(index / 2)" :col="index % 2" class="m-1">
                <ContentView class="bg-neutral-200 aspect-square justify-center items-center rounded-lg">
                  <Label text="📷" class="text-xl h-64 text-center" />
                </ContentView>
              </StackLayout>
            </GridLayout>
            
            <!-- Other tabs -->
            <StackLayout v-else class="p-4">
              <Label :text="`No ${activeTab} content yet`" class="text-center mt-12 text-gray-500" />
            </StackLayout>
          </GridLayout>
        </StackLayout>
      </StackLayout>
    </ScrollView>
  </GridLayout>
</template>
  
<script>
export default {
  name: 'Profile',
  props: {
    userId: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      username: 'zhamm3',
      displayName: 'Zack Hamm',
      profileImage: '~/assets/profile.png',
      postsCount: 30,
      followersCount: 3300,
      followingCount: 365,
      likesCount: 33300,
      activeTab: 'posts',
      posts: Array(12).fill(null).map((_, i) => ({
        id: i
      }))
    }
  },
  methods: {
    goBack() {
      // Navigate back using $emit instead of $navigateBack
      this.$emit('back');
    }
  }
}
</script>

<style>
.profile-header {
  position: relative;
}

.tab-navigation {
  justify-content: space-around;
}

.tab-item {
  font-size: 14;
  color: #888;
  background-color: #fff;
  text-align: center;
  padding: 8 12;
  border-radius: 16;
}

.active-tab {
  color: #000;
  background-color: #f0f0f0;
  font-weight: bold;
}

.bottom-nav {
  background-color: white;
  border-top-width: 1;
  border-top-color: #eee;
}
</style>