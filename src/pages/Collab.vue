<template>
  <div class="container mx-auto">
    <div class="grid gap-8 grid-cols-1">
      <div>
        <h1 class="text-3xl mb-8 font-bold">
          Tiptap Startup
        </h1>

        <p class="text-gray-700">This startup help offers an interactive testing ground for both collaboration and AI
          features within the
          Tiptap environment. Experiment and validate your integrations in a controlled setting.

          Test the functionality of your Collaboration tools alongside the AI features, ensuring a seamless and
          efficient user experience in your applications.</p>

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
          <hr/>

          <h2>Test your Collaboration setup</h2>

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
                    Give your app an individual name. This is helpful to distinguish between prod and staging apps.
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

                    <span>Our JWT is generated client-side and NEVER leaves your device</span>
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
                                type="text"
                                class="w-full"
                                placeholder="App Secret"
                                v-model="secret"
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

        </div>


        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mt-16">
          <Editor
            :mode="mode"
            :appUrl="appUrl"
            :appId="appId"
            :jwt="jwt"
            :aiEnabled="false"
            :aiUrl="aiUrl"
            :aiId="aiId"
            :aiJwt="aiJwt"
          ></Editor>

          <Editor
            :mode="mode"
            :appUrl="appUrl"
            :appId="appId"
            :jwt="jwt"
            :aiEnabled="false"
            :aiUrl="aiUrl"
            :aiId="aiId"
            :aiJwt="aiJwt"
          ></Editor>
        </div>

        <div class="mt-5">
          <h1 class="text-3xl mb-8 font-bold">
            Test your AI integration
          </h1>

          <p class="text-gray-700">After setting up your AI environment, you can utilize this section to verify your
            setup. Test your credentials and server to confirm everything is operating as intended, ensuring your AI
            server is optimally prepared for both development and deployment.</p><br/>
          <p class="text-gray-700">Just enter your App ID (or URL, if on-premise) and secret to get started. ✨</p><br/>

          <p class="text-gray-700">Click <a href="https://www.tiptap.dev/docs/cloud" class="underline" target="_blank">here</a> to open the documentation.</p>
        </div>

        <div v-if="aiEnabled" class="grid gap-4 mt-4">

          <h2>Ai settings</h2>

          <div class="grid gap-1" v-if="mode === 'on-premise'">
            <div>
              <h3>AI URL</h3>
              <div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
                <div class="col-span-1">
                  <p class="text-sm text-gray-500">
                    AI URL (e.g. http://localhost:8080)
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
                                id="aiUrl"
                                type="text"
                                class="w-full"
                                placeholder="http://"
                                v-model="aiUrl"
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
              <h3>AI ID</h3>
              <div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
                <div class="col-span-1">
                  <p class="text-sm text-gray-500">
                    AI ID
                    This is the AI ID shown on collab.tiptap.dev.
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
                                v-model="aiId"
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
              <h3>AI Secret (not the demo JWT, the secret)</h3>
              <div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
                <div class="col-span-1">
                  <p class="text-sm text-gray-500">
                    AI Secret
                    <span v-if="mode==='on-premise'">
                    (on-premise): the secret needs to be configured in the environment variables (as JWT_SECRET) of the AI server.
                    </span>
                    <span v-else>
                    (cloud): the secret is shown on collab.tiptap.dev.
                    </span>

                    <span>Our JWT is generated client-side and NEVER leaves your device</span>
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
                                type="text"
                                class="w-full"
                                placeholder="AI Secret"
                                v-model="aiSecret"
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
        </div>

      </div>
    </div>


    <div class="gap-8 mt-16">
      <Editor
        :mode="mode"
        :appUrl="appUrl"
        :appId="appId"
        :jwt="jwt"
        :aiEnabled="true"
        :aiUrl="aiUrl"
        :aiId="aiId"
        :aiJwt="aiJwt"
      ></Editor>
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
const aiEnabled = ref(true)

const appUrl = ref('')
const appId = ref('')
const secret = ref('')
const jwt = ref('')

const aiUrl = ref('')
const aiId = ref('')
const aiSecret = ref('')
const aiJwt = ref('')

watch(secret, async () => {
  // do NOT generate the JWT like this in production, this is just for demoing purposes. The secret MUST be stored on and never leave the server.
  jwt.value = await new jose.SignJWT({
    allowedDocumentNames: ['test1', 'test2'],
  }).setProtectedHeader({alg: 'HS256'})
    .setIssuedAt()
    .sign(new TextEncoder().encode(secret.value))
})

watch(aiSecret, async () => {
  // do NOT generate the JWT like this in production, this is just for demoing purposes. The secret MUST be stored on and never leave the server.
  aiJwt.value = await new jose.SignJWT({}).setProtectedHeader({alg: 'HS256'})
    .setIssuedAt()
    .sign(new TextEncoder().encode(aiSecret.value))
})

onMounted(() => {
  appUrl.value = window.localStorage.getItem('appUrl') ?? ''
  appId.value = window.localStorage.getItem('appId') ?? ''
  mode.value = (window.localStorage.getItem('mode') as typeof mode.value) ?? 'cloud'
  secret.value = window.localStorage.getItem('secret') ?? ''

  aiEnabled.value = window.localStorage.getItem('aiEnabled') === '1'
  aiUrl.value = window.localStorage.getItem('aiUrl') ?? ''
  aiId.value = window.localStorage.getItem('aiId') ?? ''
  aiSecret.value = window.localStorage.getItem('aiSecret') ?? ''

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

watch([appUrl, appId, mode, secret, aiEnabled, aiUrl, aiId, aiSecret], () => {
  window.localStorage.setItem('appUrl', appUrl.value)
  window.localStorage.setItem('appId', appId.value)
  window.localStorage.setItem('mode', mode.value)
  window.localStorage.setItem('secret', secret.value)

  window.localStorage.setItem('aiEnabled', aiEnabled ? '1' : '0')
  window.localStorage.setItem('aiUrl', aiUrl.value)
  window.localStorage.setItem('aiId', aiId.value)
  window.localStorage.setItem('aiSecret', aiSecret.value)
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
