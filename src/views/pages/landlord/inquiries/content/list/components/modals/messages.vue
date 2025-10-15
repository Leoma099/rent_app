<template>
    <div
        v-if="inquiry"
        class="modal fade"
        :id="'messageModal-' + inquiry.id"
        tabindex="-1"
        aria-labelledby="messageModalLabel"
        aria-hidden="true"
    >
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content bg-light">
                <div class="modal-header">
                    <h1 class="modal-title fs-5">
                        Messages for {{ inquiry.property.title }}
                    </h1>
                    <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                    ></button>
                </div>

                <div class="modal-body">
                    <ul class="list-group">
                        <li
                            v-for="msg in inquiry.messages"
                            :key="msg.id"
                            class="list-group-item"
                        >
                            <strong>{{ msg.sender.username }}:</strong> {{ msg.message }}
                        </li>
                    </ul>
                </div>

                <div class="modal-footer">
                    <input
                        v-model="newMessage"
                        type="text"
                        placeholder="Type your reply..."
                        class="form-control"
                    />
                    <button
                        type="button"
                        class="btn btn-primary"
                        @click="sendMessage"
                    >
                        Send
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import apiClient from "@/services"

export default {
    props: {
        inquiry: {
            type: Object,
            required: true
        }
    },
    data()
    {
        return {
            newMessage: ""
        }
    },
    methods:
    {
        async sendMessage()
        {
            if (!this.newMessage.trim()) return

            try
            {
                await apiClient.post(`/inquiries/${this.inquiry.id}/messages`, {
                    message: this.newMessage
                })

                this.inquiry.messages.push({
                    id: Date.now(),
                    sender: { username: "Me" },
                    message: this.newMessage,
                    created_at: new Date().toISOString()
                })

                this.newMessage = ""
            }
            catch (error)
            {
                console.error("Failed to send message:", error)
            }
        }
    }
}
</script>