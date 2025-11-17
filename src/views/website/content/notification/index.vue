<template>
    <div class="container my-5">

        <div class="col-md-8 mx-auto">

            <h1 class="mb-4">Notifications</h1>

            <div class="notification-card">

                <div v-if="items.length > 0">
                
                    <div
                        v-for="item in items"
                        :key="item.id"
                        class="notification-card-inner"
                        @click="notificationClick(item)"
                        style="cursor: pointer;"
                    >
                        <p class="mb-0"><strong>{{ item.data.title }}</strong></p>
                        <div>
                            <span>{{ item.data.message }}</span>
                        </div>
                        <div>
                            <small>{{ formatRelativeTime(item.created_at) }}</small>
                        </div>
                        <hr class="mb-0">
                    </div>


                </div>

                <p v-else class="mb-0 text-center my-5 empty">No notifications</p>

            </div>

        </div>

    </div>
</template>

<script>
import apiClient from '@/services'
import { useToast } from 'vue-toastification'
import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'
dayjs.extend(relativeTime)

export default
{
    data()
    {
        return {
            items: [],
            notificationCount: 0,
            toast: null,
            autoReload: null
        }
    },

    async created()
    {
        this.toast = useToast()
        await this.notificationLoad()
        await this.markAllAsRead()
        window.dispatchEvent(new Event('notifications-read'))
        this.autoReload = setInterval(() =>
        {
            this.notificationLoad()
        }, 3000)
    },

    beforeUnmount()
    {
        clearInterval(this.autoReload)
    },

    methods:
    {
        async notificationLoad()
        {
            try
            {
                const response = await apiClient.get('/notifications')
                this.items = response.data.data
                this.notificationCount = this.items.filter(item => !item.read_at).length
            }
            catch (error)
            {
                console.error('Error loading notifications', error)
            }
        },

        async markAllAsRead()
        {
            try
            {
                await apiClient.post('/notifications/read-all')
                this.notificationCount = 0
                this.items = this.items.map(n => ({ ...n, read_at: new Date().toISOString() }))
            }
            catch (error)
            {
                console.error('Error marking all notifications read', error)
            }
        },

        formatRelativeTime(date)
        {
            return dayjs(date).fromNow()
        },

        async deleteNotification(id)
        {
            try
            {
                await apiClient.delete(`/notifications/${id}`)
                this.items = this.items.filter(item => item.id !== id)
                this.toast.success('Deleted notification!')
            }
            catch (error)
            {
                console.error('Error deleting notification:', error)
                this.toast.error('Failed to delete notification.')
            }
        },

        async deleteNotificationAll()
        {
            try
            {
                await apiClient.delete('/notificationAll')
                this.items = []
                this.toast.success('Deleted all notifications!')
            }
            catch (error)
            {
                console.error('Error deleting all notifications:', error)
                this.toast.error('Failed to delete all notifications.')
            }
        },

        notificationClick(item)
        {
            console.log("Notification clicked:", item);

            if (item.data.inquiry_id)  // only inquiries
            {
                console.log("Redirect to /message for inquiry id:", item.data.inquiry_id);
                this.$router.push('/message'); // redirect
            }
            else
            {
                console.log("Not an inquiry notification, no redirect.");
            }
        }
    }
}
</script>

<style scoped>
.empty
{
    color: gray;
    font-style: italic;
}
.notification-card
{
    height: 600px;
    overflow-y: auto;
    background-color: #ffffff;
    border-radius: 15px;
    padding: 20px;
    display: flex;
    flex-direction: column;
}

.notification-card-inner
{
    border-radius: 5px;
    transition: all 0.2s ease-in;
    padding: 10px;
}

.notification-card-inner:hover
{
    background: #f0f0f0;
}
.text-truncate
{
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
.card-body
{
    padding: 0.75rem 1rem;
}
@media (max-width: 767px)
{
    .text-truncate
    {
        white-space: normal;
    }
}
</style>
