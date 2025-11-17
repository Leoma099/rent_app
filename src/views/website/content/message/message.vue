<template>

    <div class="container my-5">

        <h1 class="mb-4">Chats</h1>

        <div class="row">

            <div class="col-md-4">
                <div class="chat-sidebar bg-white rounded shadow-sm p-2">
                    <div
                        v-for="item in sortedItems"
                        :key="item.id"
                        @click="selectInquiry(item)"
                        class="card border-0 mb-2 chat-item p-2"
                        :class="{ active: selectedInquiry && selectedInquiry.id === item.id }"
                    >
                        <p class="mb-1"><strong>{{ item.landlord?.account?.full_name || 'Unknown Landlord' }}</strong></p>
                        <small class="text-muted text-truncate">
                            {{ item.messages?.length ? item.messages[item.messages.length - 1]?.message : 'No messages yet' }}
                        </small>
                    </div>
                </div>
            </div>

            <div class="col-md-8 d-flex flex-column">

                <div v-if="selectedInquiry" class="card flex-grow-1 border-0 rounded shadow-sm message p-3">

                    <div class="d-flex flex-column" ref="messagesEl">

                        <div
                            v-for="message in messages"
                            :key="message.id"
                            class="d-flex mb-2"
                            :class="message.sender?.id === userId ? 'justify-content-end' : 'justify-content-start'"
                        >
                            <div
                                class="p-2 rounded message-bubble"
                                :class="message.sender?.id === userId ? 'sent' : 'received'"
                                style="max-width: 75%;"
                            >
                                <p class="mb-1 fw-bold small">
                                    {{ message.sender?.account?.full_name || loggedInUserFullName || 'You' }}
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

                <div class="mt-3 d-flex gap-2">
                    <input
                        type="text"
                        v-model="newMessage"
                        class="form-control rounded-pill px-3"
                        placeholder="Type your message..."
                        @keyup.enter="sendMessage"
                    />
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
            loggedInUserFullName: ''
        }
    },

    async created()
    {
        await this.getAuthUser()
        await this.loadSender()
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

                if (this.items.length > 0)
                {
                    this.selectInquiry(this.items[0])
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
            await this.loadMessages()
        },

        async loadMessages()
        {
            if (!this.selectedInquiry) return

            try
            {
                const response = await apiClient.get(`/inquiries/${this.selectedInquiry.id}/messages`)
                this.messages = response.data

                this.$nextTick(() =>
                {
                    this.scrollToBottom()
                })
            }
            catch (error)
            {
                console.error("Failed to load messages:", error)
            }
        },

        async sendMessage()
        {
            if (!this.newMessage.trim() || !this.selectedInquiry) return

            try
            {
                const response = await apiClient.post(
                    `/inquiries/${this.selectedInquiry.id}/messages`,
                    { message: this.newMessage }
                )

                let newMsg = response.data

                if (!newMsg.sender.account)
                {
                    newMsg.sender.account = {
                        full_name: this.loggedInUserFullName || 'You',
                        id: this.userId
                    }
                }

                this.messages.push(newMsg)
                this.newMessage = ""

                this.selectedInquiry.messages = this.messages
                this.items = this.items.filter(i => i.id !== this.selectedInquiry.id)
                this.items.unshift(this.selectedInquiry)

                this.$nextTick(() =>
                {
                    this.scrollToBottom()
                })
            }
            catch (error)
            {
                console.error("Failed to send message:", error)
            }
        },

        scrollToBottom()
        {
            const el = this.$refs.messagesEl
            if (!el) return

            el.scrollTop = el.scrollHeight
        },

        formatTime(datetime)
        {
            if (!datetime) return ''
            const date = new Date(datetime)
            return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
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
    max-width: 75%;
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
    background-color: #e9ecef;
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
</style>
