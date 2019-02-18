<template>
    <div class="uk-container uk-container-center uk-text-center">
        <h1 class="uk-heading-divider uk-text-uppercase uk-text-bold">PRESENTATION</h1>

        <!-- Like -->
        <div class="uk-card uk-card-default uk-margin">
            <div class="uk-card-media-top">
                <a href="#" v-on:click="sendLike">
                    <img src="../assets/like.png" alt="Like" class="like-image"/>
                </a>
            </div>
            <div class="uk-card-media-bottom uk-text-large uk-text-bold">{{likeCount}}</div>
        </div>

        <!-- Comment -->
        <form class="uk-form-horizontal" @submit.prevent="sendComment">
            <div class="uk-flex">
                <input type="text" v-model="comment" class="uk-input"
                       placeholder="Please give me a feedback!">
                <button class="uk-button uk-button-primary uk-width-1-4" type="submit">Send</button>
            </div>
        </form>
    </div>
</template>

<script>
  import io from 'socket.io-client'
  import 'uikit/dist/css/uikit.css'

  export default {
    name: 'User',
    data() {
      return {
        likeCount: 0,
        comment: '',
      }
    },
    mounted() {
      this.socket = io(location.origin)
      this.socket.on('init', function(data) {
        this.likeCount = data.like
      })
      this.socket.on('like', function(data) {
        this.likeCount = data.count
      })
      this.socket.emit('join')
    },
    methods: {
      sendLike() {
        this.socket.emit('like')
      },
      sendComment() {
        if (this.comment) {
          this.socket.emit('comment', {text: this.comment})
          this.comment = ''
        }
      },
    }
  }
</script>

<style scoped>
    .like-image {
        width: 260px;
        height: 260px;
    }
</style>
