<template>
  <div class="container mx-auto">
    <div class="grid gap-8 grid-cols-1">
      <div>
        <h1 class="text-3xl mb-8 font-bold">
          Tiptap Startup
        </h1>

        <p class="text-gray-700">This startup help offers an interactive testing ground for collaboration
          features within the Tiptap environment. Experiment and validate your integration in a controlled setting,
          ensuring a seamless and efficient user experience in your applications.</p>

        <p class="text-gray-700">Just enter your App ID (or URL, if on-premise) and secret to get started. ✨</p><br/>

        <p class="text-gray-700">Click <a href="https://www.tiptap.dev/docs/cloud" class="underline" target="_blank">here</a> to  open the documentation.</p>
      </div>

      <div>

        <p>Current mode: {{ mode }}. <span @click="switchMode" class="cursor-pointer underline">Click here to switch to {{
            alternativeMode
          }}</span>
        </p><br/>

        <br/>

        <div class="grid gap-4">
          <h2 class="text-2xl mt-48 mb-8 font-bold">
            Test your Collaboration setup
          </h2>

          <p class="text-gray-700">Verify the functionality of your collaborative editor… in real-time. Simply input
            your App key and App ID, and you'll gain access to a live playground where you can see your Collaboration
            setup in action.</p><br/>

          <div class="grid gap-1" v-if="mode === 'on-premise'">
            <div>
              <h3>App URL</h3>
              <div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
                <div class="col-span-1">
                  <p class="text-sm text-gray-500">
                    App URL (e.g. ws://localhost:8080)
                  </p>
                </div>
                <div class="col-span-2">
                  <div>
                    <div class="">
                      <form>
                        <div class="flex items-center flex-1 gap-4">
                          <div x-id="['input']" class="w-full">
                            <div>
                              <input
                                id="appUrl"
                                type="text"
                                class="w-full"
                                placeholder="ws://"
                                v-model="appUrl"
                              />
                            </div>

                          </div>
                        </div>
                      </form>
                    </div>
                  </div>

                </div>
              </div>
            </div>
          </div>

          <div class="grid gap-1" v-if="mode === 'cloud'">
            <div>
              <h3>App ID</h3>
              <div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
                <div class="col-span-1">
                  <p class="text-sm text-gray-500">
                    App ID
                    This is the ID shown on collab.tiptap.dev.
                  </p>
                </div>
                <div class="col-span-2">
                  <div>
                    <div class="">
                      <form>
                        <div class="flex items-center flex-1 gap-4">
                          <div x-id="['input']" class="w-full">
                            <div>
                              <input
                                id="appId"
                                type="text"
                                class="w-full"
                                placeholder="App ID"
                                v-model="appId"
                              />
                            </div>

                          </div>
                        </div>
                      </form>
                    </div>
                  </div>

                </div>
              </div>
            </div>
          </div>

          <div class="grid gap-1">
            <div>
              <h3>App Secret</h3>
              <div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
                <div class="col-span-1">
                  <p class="text-sm text-gray-500">
                    App Secret
                    <span v-if="mode==='on-premise'">
                    (on-premise): the secret is generated on first boot and printed to the console. If you lost it, you can retrieve it from the settings table (key: secret).
                    </span>
                    <span v-else>
                    (cloud): the secret is shown on collab.tiptap.dev.
                    </span>

                    <span>Our JWT is generated client-side and NEVER leaves your device. For your security, the secret is not stored and must be re-entered after a reload.</span>
                  </p>
                </div>
                <div class="col-span-2">
                  <div>
                    <div class="">
                      <form>
                        <div class="flex items-center flex-1 gap-4">
                          <div x-id="['input']" class="w-full">
                            <div>
                              <input
                                id="secret"
                                :type="showSecret ? 'text' : 'password'"
                                class="w-full"
                                placeholder="App Secret"
                                autocomplete="off"
                                v-model="secret"
                              />
                            </div>

                          </div>
                          <button
                            type="button"
                            class="underline text-sm whitespace-nowrap"
                            @click="showSecret = !showSecret"
                          >
                            {{ showSecret ? 'Hide' : 'Show' }}
                          </button>
                        </div>
                      </form>
                    </div>
                  </div>

                </div>
              </div>
            </div>
          </div>

        </div>


        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mt-16">
          <Editor
            :mode="mode"
            :appUrl="appUrl"
            :appId="appId"
            :jwt="jwt"
            user="user_1"
          ></Editor>

          <Editor
            :mode="mode"
            :appUrl="appUrl"
            :appId="appId"
            :jwt="jwt2"
            user="user_2"
          ></Editor>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import Editor from '../components/Editor.vue'
import {
  onMounted, ref, watch,
} from 'vue'
import * as jose from 'jose'

const mode = ref<'cloud' | 'on-premise'>('cloud')
const alternativeMode = ref<'cloud' | 'on-premise'>('on-premise')

const appUrl = ref('')
const appId = ref('')
const secret = ref('')
const jwt = ref('')
const jwt2 = ref('')

const showSecret = ref(false)

watch(secret, async () => {
  // do NOT generate the JWT like this in production, this is just for demoing purposes. The secret MUST be stored on and never leave the server.
  jwt.value = await new jose.SignJWT({
    allowedDocumentNames: ['testdocument'],
    sub: 'user_1',
  }).setProtectedHeader({alg: 'HS256'})
    .setIssuedAt()
    .sign(new TextEncoder().encode(secret.value))

  jwt2.value = await new jose.SignJWT({
    allowedDocumentNames: ['testdocument'],
    sub: 'user_2',
  }).setProtectedHeader({alg: 'HS256'})
    .setIssuedAt()
    .sign(new TextEncoder().encode(secret.value))
})

onMounted(() => {
  // Secrets are intentionally NOT loaded from storage. Remove any that may have
  // been persisted by older versions so they can't leak (e.g. while screen sharing).
  window.localStorage.removeItem('secret')

  appUrl.value = window.localStorage.getItem('appUrl') ?? ''
  appId.value = window.localStorage.getItem('appId') ?? ''
  mode.value = (window.localStorage.getItem('mode') as typeof mode.value) ?? 'cloud'

  const urlParams = new URLSearchParams(window.location.search);
  const modeParam = urlParams.get('mode')

  if (modeParam && ['cloud', 'on-premise'].includes(modeParam)) {
    mode.value = modeParam as typeof mode.value
  }
})

watch(mode, () => {
  if (mode.value === 'cloud') {
    alternativeMode.value = 'on-premise'
  } else {
    alternativeMode.value = 'cloud'
  }
})

const switchMode = () => {
  if (mode.value === 'cloud') {
    mode.value = 'on-premise'
  } else {
    mode.value = 'cloud'
  }
}

// The secret is deliberately excluded here — it is never persisted.
watch([appUrl, appId, mode], () => {
  window.localStorage.setItem('appUrl', appUrl.value)
  window.localStorage.setItem('appId', appId.value)
  window.localStorage.setItem('mode', mode.value)
})

</script>

<style lang="postcss">
@import "tailwindcss";

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

input[type="text"],
input[type="password"] {
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
