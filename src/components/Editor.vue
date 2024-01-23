<script setup lang="ts">

import {Editor, EditorContent} from "@tiptap/vue-3";
import StatusBar from "./StatusBar.vue";
import StarterKit from "@tiptap/starter-kit";
import Collaboration from "@tiptap/extension-collaboration";
import CollaborationCursor from "@tiptap/extension-collaboration-cursor";
import {Ai} from "@tiptap-pro/extension-ai";
import {TiptapCollabProvider} from "@hocuspocus/provider";
import {onBeforeUnmount, onMounted, ref, shallowRef, watch} from "vue";

const props = defineProps<{
  mode: string
  appId: string
  appUrl: string
  jwt: string
  aiEnabled: boolean
  aiUrl: string
  aiId: string
  aiJwt: string
}>()

const provider = shallowRef<TiptapCollabProvider>()
const editor = shallowRef<Editor>()

const isDisabled = ref(false)
const streamMode = ref(true)
const isLoading = ref(false)
const errorMessage = ref('')

const recreate = () => {
  provider.value?.destroy()
  editor.value?.destroy()

  provider.value = new TiptapCollabProvider({
    ...(props.mode === 'cloud') ? {
      appId: props.appId
    } : {
      baseUrl: props.appUrl,
    },
    name: props.aiEnabled ? 'ai-test1' : 'test2',
    token: props.jwt,
    preserveConnection: false,
    onSynced(data) {
      const placeholder = 'Hi 👋, this is a collaborative document.<br />Feel free to Edit, comment, and collaborate in real-time!'

      setTimeout(() => {
        if( editor.value?.getText() === '' ) {
          editor.value!.commands.setContent(placeholder)
        }
      }, 350)
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
      ...(props.aiEnabled) ? [
        Ai.configure({
          baseUrl: props.mode === 'on-premise' ? props.aiUrl : undefined,
          appId: props.mode === 'cloud' ? props.aiId : undefined,
          token: props.aiJwt,
          autocompletion: false,
          onLoading: () => {
            isLoading.value = !streamMode.value
            errorMessage.value = ''
          },
          onSuccess: () => {
            isLoading.value = false
          },
          onError: error => {
            isLoading.value = false
            errorMessage.value = error.message
          },

        })
      ] : []
    ],
    enableInputRules: true,
    enablePasteRules: true,
    // content: `
    //   <p>
    //     Rocking like a mobile?
    //   </p>
    //   <p>
    //     Did you hear about the mobile phone that joined a rock band? Yeah, it was a real smartTONE!
    //     It rocked the stage with its gigabytes of rhythm and had everyone calling for an encore, but
    //     it couldn't resist the temptation to drop a few bars and left the audience in absolute silence.
    //     Turns out, it wasn't quite cut out for the music industry.
    //   </p>
    //   <p>
    //     They say it's now pursuing a career in ringtone composition. Who knows, maybe one day it'll top
    //     the charts with its catchy melodies!
    //   </p>
    //   <p></p>
    // `,
    onSelectionUpdate(props) {
      const {empty: selectionIsEmpty, from: selectionFrom, to: selectionTo} = props.editor.state.selection
      const selectionContainsText = props.editor.state.doc.textBetween(selectionFrom, selectionTo, ' ')

      isDisabled.value = selectionIsEmpty || !selectionContainsText
    },
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

        <div v-if="aiEnabled">
          <div>
            <button
              @click="() => streamMode = false"
              :class="{'text-white': !streamMode, 'bg-black': !streamMode}"
            >
              Classic
            </button>
            <button
              @click="() => streamMode = true"
              :class="{'text-white': streamMode, 'bg-black': streamMode}"
            >
              Stream
            </button>
          </div>
          <div>
            <p :class="{'text-red': isDisabled}">
              Select some text and click one of the buttons to see the AI improving your text.
            </p>

            <button
              @click="() => editor?.chain().focus().aiRephrase({ stream: streamMode, modelName: 'gpt-4-1106-preview' }).run()"
              :disabled="isDisabled"
            >
              Rephrase
            </button>
            <button
              @click="() => editor?.chain().focus().aiShorten({ stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              Shorten
            </button>
            <button
              @click="() => editor?.chain().focus().aiExtend({ stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              Extend
            </button>
            <button
              @click="() => editor?.chain().focus().aiSummarize({ stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              Summarize
            </button>

            <button
              @click="() => editor?.chain().focus().aiSimplify({ stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              Simplify
            </button>

            <button
              @click="() => editor?.chain().focus().aiFixSpellingAndGrammar({ stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              Fix spelling
            </button>
            <button
              @click="() => editor?.chain().focus().aiComplete({ append: true, stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              Continue writing
            </button>

            <button
              @click="() => editor?.chain().focus().aiAdjustTone('excited', { stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              Use&nbsp;<i>excited</i>&nbsp;tone of voice
            </button>
            <button
              @click="() => editor?.chain().focus().aiEmojify({ stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              Enrich with 🙂
            </button>
            <button
              @click="() => editor?.chain().focus().aiDeEmojify({ stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              De-Emojify
            </button>
            <button
              @click="() => editor?.chain().focus().aiTranslate('sv', { stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              Translate to&nbsp;<i>Swedish</i>
            </button>
            <button
              @click="() => editor?.chain().focus().aiTranslate('de', { stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              Translate to&nbsp;<i>German</i>
            </button>
            <button
              @click="() => editor?.chain().focus().aiTldr({ stream: streamMode }).run()"
              :disabled="isDisabled"
            >
              tl;dr
            </button>
          </div>

          <div class="has-error" v-if="errorMessage">{errorMessage}</div>

          <div class="is-loading" v-if="isLoading">
            <span>Loading</span>
            <small>(may take a few moments)</small>
          </div>
        </div>
        <editor-content
          :editor="editor"
          class="editor"
        />
      </div>
    </div>
  </div>
</template>
