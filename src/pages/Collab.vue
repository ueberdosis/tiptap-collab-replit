<template>
  <div class="container mx-auto">
    <div class="grid gap-8 grid-cols-1 lg:grid-cols-2">
      <div>
        <h1 class="text-3xl mb-8 font-bold">
          Collaborative Editing with Tiptap Collab
        </h1>

        <p class="text-gray-700">Just enter your App ID and secret to get started ✨</p>

        <p class="mt-4">
          <a href="https://tiptap.dev/pricing" class="font-semibold">Need a Tiptap Collab Account? &rarr;</a>
        </p>
      </div>

      <div>
        <div class="grid gap-4">
          <div class="grid gap-1">
            <input
              id="appId"
              type="text"
              placeholder="App ID"
              v-model="appId"
            />
          </div>

          <div class="grid gap-2">
            <input
              id="secret"
              type="text"
              placeholder="App Secret"
              v-model="secret"
            />
          </div>
        </div>
      </div>
    </div>


    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mt-16">
      <div>
        <StatusBar
          v-if="provider"
          :provider="provider"
          :socket="provider.configuration.websocketProvider"
        />
        <div v-if="editor">
          <div class="rounded-xl border-[3px] border-black">
            <editor-content
              :editor="editor"
              class="editor"
            />
          </div>
        </div>
      </div>
      <div>
        <StatusBar
          v-if="provider2"
          :provider="provider2"
          :socket="provider2.configuration.websocketProvider"
        />
        <div v-if="editor2">
          <div class="rounded-xl border-[3px] border-black">
            <editor-content
              :editor="editor2"
              class="editor"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Editor, EditorContent } from '@tiptap/vue-3'
import StarterKit from '@tiptap/starter-kit'
import Collaboration from '@tiptap/extension-collaboration'
import CollaborationCursor from '@tiptap/extension-collaboration-cursor'
import { TiptapCollabProvider, TiptapCollabProviderWebsocket } from '@hocuspocus/provider'
import axios from 'axios'
import {
  nextTick, onMounted, ref, shallowRef, watch,
} from 'vue'
import StatusBar from '../components/StatusBar.vue'

const appId = ref('')
const secret = ref('')
const jwt = ref('')
const socket = shallowRef<TiptapCollabProviderWebsocket>()
const provider = shallowRef<TiptapCollabProvider>()
const provider2 = shallowRef<TiptapCollabProvider>()
const editor = shallowRef<Editor>()
const editor2 = shallowRef<Editor>()

watch(secret, () => {
  // do NOT transfer the secret like this in production, this is just for demoing purposes. The secret should be stored on and never leave the server.
  const hostname = !!window.location.hostname.match(/repl/) ? 'https://TiptapCollab.ueberdosis.repl.co:9000' : 'http://127.0.0.1:1234'

  axios.get(`${hostname}/?secret=${secret.value}`).then(data => {
    jwt.value = data.data
  })
})

onMounted(() => {
  appId.value = window.localStorage.getItem('appId') ?? ''
  secret.value = window.localStorage.getItem('secret') ?? ''

  socket.value = new TiptapCollabProviderWebsocket({
    appId: appId.value,
  })
})

watch([appId, secret], () => {
  window.localStorage.setItem('appId', appId.value)
  window.localStorage.setItem('secret', secret.value)
})

watch([jwt, appId], () => {
  if (editor.value) editor.value.destroy()
  if (editor2.value) editor2.value.destroy()
  if (provider.value) provider.value.destroy()
  if (provider2.value) provider2.value.destroy()

  provider.value = new TiptapCollabProvider({
    appId: appId.value,
    websocketProvider: socket.value,
    name: 'test1',
    token: jwt.value,
  })

  provider2.value = new TiptapCollabProvider({
    appId: appId.value,
    websocketProvider: socket.value,
    name: 'test2',
    token: jwt.value,
  })

  nextTick(() => {
    editor.value = new Editor({
      extensions: [
        StarterKit.configure({
          history: false,
        }),
        Collaboration.configure({
          document: provider.value?.document,
          field: 'default',
        }),
        CollaborationCursor.configure({
          provider: provider.value,
          user: {
            name: 'Editor1',
            color: '#EADDCA',
          },
        }),
      ],
    })

    editor2.value = new Editor({
      extensions: [
        StarterKit.configure({
          history: false,
        }),
        Collaboration.configure({
          document: provider2.value?.document,
          field: 'default',
        }),
        CollaborationCursor.configure({
          provider: provider2.value,
          user: {
            name: 'Editor2',
            color: '#FFA500',
          },
        }),
      ],
    })
  })
})

</script>

<style lang="postcss">
.ProseMirror {
  padding: 1rem;
}

.ProseMirror-focused {
  border: none;
  outline: none;
}

h2 {
  @apply text-lg font-semibold;
}

label {
  @apply text-sm font-medium;
}

input[type="text"] {
  @apply font-mono;
  @apply border-black border-2;
  @apply rounded-xl;
  @apply px-3 py-2;
}

  /* Give a remote user a caret */
.collaboration-cursor__caret {
  border-left: 1px solid #0D0D0D;
  border-right: 1px solid #0D0D0D;
  margin-left: -1px;
  margin-right: -1px;
  pointer-events: none;
  position: relative;
  word-break: normal;
}
/* Render the username above the caret */
.collaboration-cursor__label {
  border-radius: 3px 3px 3px 0;
  color: #0D0D0D;
  font-size: 12px;
  font-style: normal;
  font-weight: 600;
  left: -1px;
  line-height: normal;
  padding: 0.1rem 0.3rem;
  position: absolute;
  top: -1.4em;
  user-select: none;
  white-space: nowrap;
}
</style>
