<script setup lang="ts">
import Collab from './pages/Collab.vue'
import svg from './assets/logo.svg'

</script>

<template>
  <div class="min-h-screen flex flex-col mt-4 px-8 py-4">

    <img alt="Tiptap Logo" :src="svg" class="w-32"/>

    <div class="flex flex-grow lg:mt-32 mt-4">
      <main class="flex-grow ">
        <Collab/>
      </main>
    </div>
  </div>
</template>
