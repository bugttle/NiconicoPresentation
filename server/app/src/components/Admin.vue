<template>
    <div class="uk-container uk-container-center uk-text-center">
        <div class="panel-heading">
            <!-- Key event -->
            <button type="button" id="left-arrow" class="uk-button uk-button-primary"
                    v-on:click="sendKeyEvent" value="LeftArrow">
                <font-awesome-icon icon="arrow-left"/>
            </button>
            <button type="button" id="right-arrow" class="uk-button uk-button-primary"
                    v-on:click="sendKeyEvent" value="RightArrow">
                <font-awesome-icon icon="arrow-right"/>
            </button>

            <!-- Like -->
            <a href="#" v-on:click="sendLike">
                <img src="../assets/like.png" alt="Like" class="like-image"/>
            </a>
            <span class="uk-badge">{{likeCount}}</span>

            <!-- Test -->
            <button type="button" id="test" class="uk-button uk-button-primary" v-on:click="sendTest">
                <font-awesome-icon icon="bug"/>
            </button>
        </div>
        <div class="panel-body">
            <!-- Comment -->
            <form class="uk-form-horizontal" @submit.prevent="sendComment">
                <div>
                    <input type="text" v-model="comment" class="uk-input uk-form-width-medium"
                           placeholder="Send a comment">
                    <button class="uk-button uk-button-primary" type="submit">Send</button>
                </div>
            </form>
        </div>

        <!-- Received comments -->
        <ul>
            <li class="list-group-item" v-for="(data, index) in receivedComments" :key="index">
                ({{data.date}}) {{data.text}}
            </li>
        </ul>
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
                receivedComments: [],
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

    .like-image {
        margin: 0 0 0 5em;
    }

    #left-arrow {
        margin: 0 1em 0 0;
    }

    #test {
        position: absolute;
        right: 0;
        top: 1.2em;
    }
</style>
