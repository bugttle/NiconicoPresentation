<template>
    <div class="uk-container uk-container-center uk-text-center">
        <h1 class="uk-heading-large">PRESENTATION</h1>

        <!-- Like -->
        <div class="uk-inline">
            <!--<div class="img-overlay like-image">-->
            <a href="#" v-on:click="sendLike">
                <img src="../assets/like.png" alt="Like"/>
                <!--<div class="project-overlay">-->
                <div class="uk-overlay uk-position-bottom-center uk-padding-remove">
                    <span class="uk-badge">{{likeCount}}</span>
                </div>
            </a>
        </div>

        <!-- Comment -->
        <form class="uk-form-horizontal" @submit.prevent="sendComment">
            <div>
                <input type="text" v-model="comment" class="uk-input uk-form-width-medium"
                       placeholder="Please give me a feedback!">
                <button class="uk-button uk-button-primary" type="submit">Send</button>
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
            this.socket.on('init', function (data) {
                this.likeCount = data.like
            })
            this.socket.on('like', function (data) {
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
</style>
