<template>
  <div class="container mx-auto">
    <div class="grid gap-8 grid-cols-1 lg:grid-cols-2">
      <div>
        <h1 class="text-3xl mb-8 font-bold">
          Collaborative Editing with Tiptap Collab
        </h1>

        <p class="text-gray-700">Just enter your App ID (or URL, if on-premise) and secret to get started. ✨</p><br/>
        <p class="text-gray-700">The JWT is generated client-side and NEVER leaves your device ✨</p>
      </div>

      <div>

        <p>Current mode: {{mode}}. <span @click="switchMode" class="cursor-pointer underline">Click here to switch to {{alternativeMode}}</span></p><br />

        <div class="grid gap-4">
          <div class="grid gap-1" v-if="mode === 'on-premise'">
            <input
              id="appUrl"
              type="text"
              placeholder="App URL (ws://localhost:8080)"
              v-model="appUrl"
            />
          </div>

          <div class="grid gap-1" v-if="mode === 'cloud'">
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
import {Editor, EditorContent} from '@tiptap/vue-3'
import StarterKit from '@tiptap/starter-kit'
import Collaboration from '@tiptap/extension-collaboration'
import CollaborationCursor from '@tiptap/extension-collaboration-cursor'
import {TiptapCollabProvider} from '@hocuspocus/provider'
import {
  nextTick, onMounted, ref, shallowRef, watch,
} from 'vue'
import StatusBar from '../components/StatusBar.vue'
import * as jose from 'jose'

const mode = ref<'cloud' | 'on-premise'>('cloud')
const alternativeMode = ref<'cloud' | 'on-premise'>('on-premise')
const appUrl = ref('')
const appId = ref('')
const secret = ref('')
const jwt = ref('')
const provider = shallowRef<TiptapCollabProvider>()
const provider2 = shallowRef<TiptapCollabProvider>()
const editor = shallowRef<Editor>()
const editor2 = shallowRef<Editor>()

watch(secret, async () => {
  // do NOT generate the JWT like this in production, this is just for demoing purposes. The secret MUST be stored on and never leave the server.
  jwt.value = await new jose.SignJWT({
    allowedDocumentNames: ['test1', 'test2'],
  }).setProtectedHeader({alg: 'HS256'})
    .setIssuedAt()
    .sign(new TextEncoder().encode(secret.value))
})

onMounted(() => {
  appUrl.value = window.localStorage.getItem('appUrl') ?? ''
  appId.value = window.localStorage.getItem('appId') ?? ''
  mode.value = (window.localStorage.getItem('mode') as typeof mode.value) ?? 'cloud'
  secret.value = window.localStorage.getItem('secret') ?? ''

  const urlParams = new URLSearchParams(window.location.search);
  const modeParam = urlParams.get('mode')

  if( modeParam && ['cloud', 'on-premise'].includes(modeParam) ) {
    mode.value = modeParam as typeof mode.value
  }
})

watch(mode, () => {
  if( mode.value === 'cloud' ) {
    alternativeMode.value = 'on-premise'
  } else {
    alternativeMode.value = 'cloud'
  }
})

const switchMode = () => {
  if( mode.value === 'cloud' ) {
    mode.value = 'on-premise'
  } else {
    mode.value = 'cloud'
  }
}

watch([appUrl, secret], () => {
  window.localStorage.setItem('appUrl', appUrl.value)
  window.localStorage.setItem('appId', appId.value)
  window.localStorage.setItem('mode', mode.value)
  window.localStorage.setItem('secret', secret.value)
})

watch([jwt, appUrl, appId, mode], () => {
  if (editor.value) editor.value.destroy()
  if (editor2.value) editor2.value.destroy()
  if (provider.value) provider.value.destroy()
  if (provider2.value) provider2.value.destroy()

  provider.value = new TiptapCollabProvider({
    ...(mode.value === 'cloud') ? {
      appId: appId.value
    } : {
      baseUrl: appUrl.value,
    },
    name: 'test1',
    token: jwt.value,
  })

  provider2.value = new TiptapCollabProvider({
    ...(mode.value === 'cloud') ? {
      appId: appId.value
    } : {
      baseUrl: appUrl.value,
    },
    name: 'test1',
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
