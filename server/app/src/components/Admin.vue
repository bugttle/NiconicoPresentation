<template>
    <div>
        <nav class="uk-navbar uk-margin">
            <div class="uk-navbar-left">
                <!-- Key event -->
                <div class="uk-navbar-item">
                    <button type="button" id="left-arrow" class="uk-button uk-button-primary"
                            v-on:click="sendKeyEvent" value="LeftArrow">
                        <font-awesome-icon icon="arrow-left"/>
                    </button>
                    <button type="button" id="right-arrow" class="uk-button uk-button-primary uk-margin-left"
                            v-on:click="sendKeyEvent" value="RightArrow">
                        <font-awesome-icon icon="arrow-right"/>
                    </button>
                </div>
            </div>
            <div class="uk-navbar-right">
                <!-- Like -->
                <div class="uk-navbar-item">
                    <a href="#" v-on:click="sendLike">
                        <img src="../assets/like.png" alt="Like" class="like-image"/>
                    </a>
                    <span class="uk-badge">{{likeCount}}</span>
                </div>
                <!-- Test -->
                <div class="uk-navbar-item">
                    <button type="button" id="test" class="uk-button uk-button-primary" v-on:click="sendTest">
                        <font-awesome-icon icon="bug"/>
                    </button>
                </div>
            </div>
        </nav>
        <div class="uk-container uk-container-center uk-text-center">
            <!-- Comment -->
            <form class="uk-form-horizontal" @submit.prevent="sendComment">
                <div class="uk-flex">
                    <input type="text" v-model="comment" class="uk-input"
                           placeholder="Send a comment">
                    <button class="uk-button uk-button-primary uk-width-1-4" type="submit">Send</button>
                </div>
            </form>

            <!-- Received comments -->
            <ul class="uk-list uk-list-divider">
                <li v-for="(data, index) in receivedComments" :key="index">
                    <div class="uk-flex">
                        <span class="uk-width-1-4 uk-text-right">{{data.date}}</span><span
                            class="uk-width-auto uk-text-left uk-margin-left">{{data.text}}</span>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
  import io from 'socket.io-client'
  import queryString from 'query-string'

  export default {
    name: 'admin',
    data() {
      return {
        likeCount: 0,
        comment: '',
        receivedComments: [{date: 'YYYY-MM-DD 111111', text: 'aaaaaaa'}, {date: 'YYYY-MM-DD 222222', text: 'aaaaaaa'}],
      }
    },
    mounted() {
      this.socket = io(location.origin)

      this.socket.on('init', (data) => {
        this.likeCount = data.like
      })
      this.socket.on('like', (data) => {
        this.likeCount = data.count
      })
      this.socket.on('comment', (data) => {
        this.receivedComments.push(data)
      })

      // Admin auth key
      const query = queryString.parse(location.search)
      this.socket.emit('join', {key: query.key})
    },
    methods: {
      sendTest() {
        this.socket.emit('test')
      },
      sendLike() {
        this.socket.emit('like')
      },
      sendComment() {
        if (this.comment) {
          this.socket.emit('comment', {'text': this.comment})
          this.comment = ''
        }
      },
      sendKeyEvent(element) {
        this.socket.emit('key', {'code': element.value})
      },
    }
  }
</script>

<style scoped>
    .like-image {
        width: 44px;
        height: 44px;
    }
</style>
