<template>
  <div class="bg-gray-100 rounded p-4 mb-8 flex flex-wrap content-center rounded-xl">
    <div class="flex-1 flex flex-col justify-center">
      {{ status }} to {{ provider.configuration.name }} at {{ socket.configuration.url }}
    </div>
    <div class="flex-1 flex flex-col justify-center text-center">
      <template v-if="synced">
        synced
      </template>
      <span v-else>
        not synced
      </span>
    </div>
    <div class="flex-1 text-right">
      <button
        v-if="status === 'disconnected'"
        @click="socket.connect()"
        class="ml-3 border-2 border-black bg-black text-white px-4 py-2 rounded"
      >
        connect
      </button>
      <button
        v-else
        @click="socket.disconnect()"
        class="ml-3 border-2 border-black bg-white px-4 py-2 rounded"
      >
        disconnect
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, defineProps, watch } from 'vue'
import type {HocuspocusProvider, HocuspocusProviderWebsocket, onSyncedParameters, onStatusParameters} from '@hocuspocus/provider'

const status = ref('')
const synced = ref(false)

const props = defineProps<{
  provider: HocuspocusProvider,
  socket: HocuspocusProviderWebsocket
}>()

watch(props, () => {
  props.socket.on('status', (event: onStatusParameters) => {
    status.value = event.status
  })

  props.provider.on('synced', (event: onSyncedParameters) => {
    synced.value = event.state
  })
}, {immediate: true})
</script>
