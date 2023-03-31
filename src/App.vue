<template>
  <div class="min-h-screen flex flex-col">
    <header class="border-b px-8 py-6 font-bold">
      Tiptap Collab Live-Demo
    </header>
    <div class="flex flex-grow">
      <main class="flex-grow mt-4 px-8 py-4">
        <Collab/>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import Collab from './pages/Collab.vue'
</script>