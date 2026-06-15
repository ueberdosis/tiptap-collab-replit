<script setup lang="ts">

import {Editor, EditorContent} from "@tiptap/vue-3";
import StatusBar from "./StatusBar.vue";
import StarterKit from "@tiptap/starter-kit";
import Collaboration from "@tiptap/extension-collaboration";
import CollaborationCursor from "@tiptap/extension-collaboration-cursor";
import {TiptapCollabProvider} from "@hocuspocus/provider";
import {onBeforeUnmount, onMounted, shallowRef, watch} from "vue";

const props = defineProps<{
  mode: string
  appId: string
  appUrl: string
  jwt: string
  user: string
}>()

const provider = shallowRef<TiptapCollabProvider>()
const editor = shallowRef<Editor>()

const recreate = () => {
  provider.value?.destroy()
  editor.value?.destroy()

  provider.value = new TiptapCollabProvider({
    ...(props.mode === 'cloud') ? {
      appId: props.appId
    } : {
      baseUrl: props.appUrl,
    },
    user: props.user,
    name: 'testdocument',
    token: props.jwt,
    preserveConnection: false,
    onSynced(data) {
      const placeholder = 'Hi 👋, this is a collaborative document.<br />Feel free to Edit, comment, and collaborate in real-time!'

      setTimeout(() => {
        if( editor.value?.getText() === '' ) {
          editor.value!.commands.setContent(placeholder)
        }
      }, 1000 * Math.random())
    },
  })

  editor.value = new Editor({
    extensions: [
      StarterKit.configure({
        history: false,
      }),
      Collaboration.configure({
        document: provider.value.document,
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
    enableInputRules: true,
    enablePasteRules: true,
  })
}

watch(props, () => recreate())

onMounted(() => recreate())

onBeforeUnmount(() => {
  provider.value?.destroy()
  editor.value?.destroy()
})

</script>

<template>
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
</template>
