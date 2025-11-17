<template>
    <div class="container my-5">
        <h1 class="mb-4">Chats</h1>
        <div class="row g-3">

            <!-- SIDEBAR -->
            <div 
                class="col-md-4"
                v-show="!isMobileView || showSidebar"
            >
                <div class="chat-sidebar bg-white rounded shadow-sm p-2">
                    <div
                        v-for="item in sortedItems"
                        :key="item.id"
                        @click="selectInquiry(item)"
                        class="card border-0 mb-2 chat-item p-2"
                        :class="{ active: selectedInquiry && selectedInquiry.id === item.id }"
                    >
                        <p class="mb-0"><strong>{{ item.property?.title }}</strong></p>
                        <span class="text-muted">Owned by {{ item.landlord?.account?.full_name }}</span>
                        <small class="text-secondary text-truncate">
                            {{ item.messages?.length ? item.messages[item.messages.length - 1]?.message : 'No messages yet' }}
                        </small>
                    </div>
                </div>
            </div>

            <!-- MESSAGES -->
            <div 
                class="col-md-8 d-flex flex-column"
                v-show="!isMobileView || !showSidebar"
            >

                <!-- MOBILE BACK BUTTON -->
                <button 
                    v-if="isMobileView"
                    @click="showSidebar = true"
                    class="btn btn-light mb-2 shadow-sm"
                >
                    ← Back to Chats
                </button>

                <!-- MESSAGE VIEW -->
                <div
                    v-if="selectedInquiry"
                    class="card flex-grow-1 border-0 rounded shadow-sm message p-3 d-flex flex-column"
                    ref="messageContainer"
                >
                    <div v-if="loadingMessages" class="shimmer-container flex-grow-1">
                        <div class="shimmer-line" v-for="n in 5" :key="n"></div>
                    </div>

                    <div v-else>
                        <div
                            v-for="message in messages"
                            :key="message.id"
                            class="d-flex w-100 mb-3"
                            :class="isSentByUser(message) ? 'justify-content-end' : 'justify-content-start'">
                            <div
                                class="message-bubble"
                                :class="isSentByUser(message) ? 'sent' : 'received'">
                                <p class="mb-1 fw-bold small">
                                    <span v-if="isSentByUser(message)">You</span>
                                    <span v-else>{{ message.sender?.account?.full_name || 'Unknown' }}</span>
                                </p>
                                <p class="mb-0">{{ message.message }}</p>
                                <small class="text-muted">{{ formatTime(message.created_at) }}</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-else class="card flex-grow-1 border-0 rounded shadow-sm d-flex justify-content-center align-items-center text-muted p-3">
                    Select a chat to view messages
                </div>

                <!-- INPUT -->
                <div class="mt-3 d-flex gap-2">
                    <input type="text" v-model="newMessage" class="form-control rounded-pill px-3" placeholder="Type your message..." @keyup.enter="sendMessage">
                    <button class="btn btn-primary rounded-pill px-4" @click="sendMessage">Send</button>
                </div>

            </div>

        </div>

    </div>
</template>

<script>
import apiClient from '@/services'

export default
{
    data()
    {
        return {
            items: [],
            messages: [],
            newMessage: "",
            selectedInquiry: null,
            userId: null,
            loggedInUserFullName: '',
            loadingMessages: false,
            isMobileView: false,
            showSidebar: true
        }
    },

    async created()
    {
        this.checkScreen()
        window.addEventListener('resize', this.checkScreen)
        await this.getAuthUser()
        await this.loadSender()
    },

    beforeUnmount()
    {
        window.removeEventListener('resize', this.checkScreen)
    },

    computed:
    {
        sortedItems()
        {
            return [...this.items].sort((a, b) =>
            {
                const aTime = a.messages?.length ? new Date(a.messages[a.messages.length - 1].created_at) : 0
                const bTime = b.messages?.length ? new Date(b.messages[b.messages.length - 1].created_at) : 0
                return bTime - aTime
            })
        }
    },

    methods:
    {
        checkScreen()
        {
            this.isMobileView = window.innerWidth <= 768
        },

        isSentByUser(message)
        {
            const senderId = message.sender?.id || message.sender?.account?.id
            return senderId === this.userId
        },

        async getAuthUser()
        {
            try
            {
                const response = await apiClient.get('/user')
                this.userId = response.data.id
                this.loggedInUserFullName = response.data.full_name
            }
            catch (error)
            {
                console.error('Failed to fetch user:', error)
            }
        },

        async loadSender()
        {
            try
            {
                const response = await apiClient.get('/inquiries')
                this.items = response.data

                // Sort items by last message timestamp (descending)
                this.items.sort((a, b) => {
                    const aTime = a.messages?.length
                        ? new Date(a.messages[a.messages.length - 1].created_at)
                        : 0
                    const bTime = b.messages?.length
                        ? new Date(b.messages[b.messages.length - 1].created_at)
                        : 0
                    return bTime - aTime
                })

                if (this.items.length > 0) {
                    this.selectInquiry(this.items[0]) // now picks the most recent message
                }
            }
            catch (error)
            {
                console.error("Failed to load senders:", error)
            }
        },

        async selectInquiry(inquiry)
        {
            this.selectedInquiry = inquiry
            this.loadingMessages = true

            if (this.isMobileView)
            {
                this.showSidebar = false
            }
            
            setTimeout(async () => {
                await this.loadMessages()
                this.loadingMessages = false // stop shimmer
            }, 1000)
        },

        async loadMessages()
        {
            if (!this.selectedInquiry) return

            try {
                const response = await apiClient.get(`/inquiries/${this.selectedInquiry.id}/messages`)

                this.messages = response.data.map(msg => {
                    const senderId = msg.sender?.id || msg.sender?.account?.id
                    if (senderId === this.userId) {
                        return {
                            ...msg,
                            sender: {
                                ...msg.sender,
                                account: {
                                    ...msg.sender.account,
                                    full_name: 'You'
                                }
                            }
                        }
                    }
                    return msg
                })

                // WAIT UNTIL RENDER FINISHES ➜ THEN SCROLL
                this.scrollToBottom()

            } catch (error) {
                console.error("Failed to load messages:", error)
            }
        },

        async sendMessage()
        {
            if (!this.newMessage.trim() || !this.selectedInquiry)
            {
                return
            }

            try
            {
                const response = await apiClient.post(
                    `/inquiries/${this.selectedInquiry.id}/messages`,
                    { message: this.newMessage }
                )

                let newMsg = response.data

                if (!newMsg.sender.account)
                {
                    newMsg.sender.account =
                    {
                        full_name: 'You',
                        id: this.userId
                    }
                }

                this.messages.push(newMsg)
                this.newMessage = ""

                this.selectedInquiry.messages = this.messages
                this.items = this.items.filter(i => i.id !== this.selectedInquiry.id)
                this.items.unshift(this.selectedInquiry)

                this.$nextTick(() => {
                    this.scrollToBottom()
                })

            }
            catch (error)
            {
                console.error("Failed to send message:", error)
            }
        },

        formatTime(datetime)
        {
            if (!datetime)
            {
                return ''
            }

            const date = new Date(datetime)
            let hours = date.getHours()
            const minutes = date.getMinutes().toString().padStart(2, '0')
            const ampm = hours >= 12 ? 'PM' : 'AM'
            hours = hours % 12
            hours = hours ? hours : 12
            return `${hours}:${minutes} ${ampm}`
        },

        scrollToBottom()
        {
            this.$nextTick(() => {
                const el = this.$refs.messageContainer;
                if (el) {
                    el.scrollTop = el.scrollHeight;
                }
            });
        }

    }
}
</script>

<style scoped>
.message
{
    height: 600px;
    overflow-y: auto;
    background-color: #ffffff;
    border-radius: 15px;
    padding: 20px;
    display: flex;
    flex-direction: column;
}

.chat-sidebar
{
    height: 600px;
    overflow-y: auto;
    padding-right: 5px;
    background-color: #ffffff;
    border-radius: 10px;
}

.message-bubble
{
    max-width: 70%;
    word-wrap: break-word;
    padding: 12px 18px;
    font-size: 0.9rem;
    display: inline-block;
}

.sent
{
    background: linear-gradient(135deg,#0d6efd,#0a58ca);
    color: white;
    border-radius: 18px 18px 0 18px;
    text-align: right;
}

.received
{
    background-color: #e9ecef;
    color: black;
    border-radius: 18px 18px 18px 0;
    text-align: left;
}

.chat-item
{
    transition: 0.2s;
    cursor: pointer;
    padding: 10px;
}

.chat-item:hover
{
    background-color: #f1f1f1;
}

.chat-item.active
{
    background-color: #dceeff;
}

.text-truncate
{
    display: block;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}

.shimmer-container {
    display: flex;
    flex-direction: column;
    gap: 10px;
    flex-grow: 1;
}

.shimmer-line {
    height: 50px;
    border-radius: 12px;
    background: linear-gradient(90deg, #e0e0e0 25%, #f0f0f0 50%, #e0e0e0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
    0% {
        background-position: -200% 0;
    }
    100% {
        background-position: 200% 0;
    }
}

@media (min-height: 768px)
{
    .message
    {
        height: 400px;
    }    
}
</style>
