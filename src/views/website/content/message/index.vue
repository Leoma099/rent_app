<template>
    <div class="container my-5">
        <h2>
            <b>MESSAGES FROM LANDLORD</b>
        </h2>

        <div class="row mt-3">
            <!-- LEFT SIDEBAR: Conversations -->
            <div class="col-md-4">
                <div
                    v-for="item in sortedItems"
                    :key="item.id"
                    @click="selectInquiry(item)"
                    class="card card-body border-0 mb-3 chat-item"
                    :class="{ active: selectedInquiry && selectedInquiry.id === item.id }"
                >
                    <p class="fw-bold mb-1">
                        {{ item.landlord?.account?.full_name || 'Unknown Landlord' }}
                    </p>
                    <small class="text-muted text-truncate">
                        {{ item.messages?.length ? item.messages[item.messages.length - 1]?.message : 'No messages yet' }}
                    </small>
                </div>
            </div>

            <!-- RIGHT SIDE: Chat box -->
            <div class="col-md-8">
                <div class="card card-body border-0 message">
                    <ul class="list-unstyled">
                        <li
                            v-for="message in messages"
                            :key="message.id"
                            class="d-flex mb-2"
                            :class="message.sender?.id === userId ? 'justify-content-end' : 'justify-content-start'"
                        >
                            <div
                                class="p-2 rounded message-bubble"
                                :class="message.sender?.id === userId ? 'sent' : 'received'"
                            >
                                <p class="mb-1 fw-bold small">
                                    {{ message.sender?.account?.full_name || 'You' }}
                                </p>
                                <p class="mb-0">
                                    {{ message.message }}
                                </p>
                            </div>
                        </li>
                    </ul>
                </div>

                <!-- Input box -->
                <div class="mt-3 d-flex">
                    <input
                        type="text"
                        v-model="newMessage"
                        class="form-control me-2"
                        placeholder="Type your message..."
                        @keyup.enter="sendMessage"
                    />
                    <button class="btn btn-primary" @click="sendMessage">
                        Send
                    </button>
                </div>
            </div>

        </div>
    </div>
</template>

<script>
import apiClient from '@/services';

export default
{
    data()
    {
        return {
            items: [],
            messages: [],
            newMessage: "",
            selectedInquiry: null,
            userId: null, // store logged-in user ID
        };
    },

    created()
    {
        this.loadSender();
        this.getAuthUser();
    },

    computed:
    {
        // Sort inquiries so the most recent message appears on top
        sortedItems()
        {
            return [...this.items].sort((a, b) =>
            {
                const aTime = a.messages?.length ? new Date(a.messages[a.messages.length - 1].created_at) : 0;
                const bTime = b.messages?.length ? new Date(b.messages[b.messages.length - 1].created_at) : 0;
                return bTime - aTime;
            });
        },
    },

    methods:
    {
        async getAuthUser()
        {
            try
            {
                const response = await apiClient.get('/user'); // your auth endpoint
                this.userId = response.data.id;
            }
            catch (error)
            {
                console.error('Failed to fetch user:', error);
            }
        },

        async loadSender()
        {
            try
            {
                const response = await apiClient.get('/inquiries');
                this.items = response.data;
            }
            catch (error)
            {
                console.error("Failed to load senders:", error);
            }
        },

        async selectInquiry(inquiry)
        {
            this.selectedInquiry = inquiry;
            await this.loadMessages();
        },

        async loadMessages()
        {
            if (!this.selectedInquiry)
            {
                return;
            }

            try
            {
                const response = await apiClient.get(`/inquiries/${this.selectedInquiry.id}/messages`);
                this.messages = response.data;
            }
            catch (error)
            {
                console.error("Failed to load messages:", error);
            }
        },

        async sendMessage()
        {
            if (!this.newMessage.trim() || !this.selectedInquiry)
            {
                return;
            }

            try
            {
                const response = await apiClient.post(
                    `/inquiries/${this.selectedInquiry.id}/messages`,
                    { message: this.newMessage }
                );

                this.messages.push(response.data);
                this.newMessage = "";

                // move the conversation to the top
                this.selectedInquiry.messages = this.messages;
                this.items = this.items.filter(i => i.id !== this.selectedInquiry.id);
                this.items.unshift(this.selectedInquiry);

                // auto-scroll to bottom
                this.$nextTick(() =>
                {
                    const container = this.$el.querySelector('.message');
                    container.scrollTop = container.scrollHeight;
                });
            }
            catch (error)
            {
                console.error("Failed to send message:", error);
            }
        },
    },
};
</script>

<style scoped>
.message
{
    min-height: 600px;
    max-height: 600px;
    overflow-y: auto;
    background-color: #f8f9fa;
    border-radius: 10px;
    padding: 15px;
}

/* Shared message style */
.message-bubble
{
    max-width: 70%;
    word-wrap: break-word;
    padding: 10px 15px;
}

/* Blue bubble (You) – right side */
.sent
{
    background-color: #0084ff;
    color: white;
    border-radius: 18px 18px 0px 18px;
    text-align: right;
}

/* Gray bubble (Other) – left side */
.received
{
    background-color: #e4e6eb;
    color: black;
    border-radius: 18px 18px 18px 0px;
    text-align: left;
}


.chat-item
{
    transition: 0.2s;
}

.chat-item:hover
{
    background-color: #f1f1f1;
}

.chat-item.active
{
    background-color: #e7f1ff;
}

.text-truncate
{
    display: block;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
</style>
