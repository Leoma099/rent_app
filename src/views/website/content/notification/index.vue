<template>
    <div class="container my-5">
        <div class="col-md-6 mx-auto">

            <div class="d-flex justify-content-between">
                <div>
                    <h2 class="mb-3">Notifications</h2>
                </div>
                <div v-if="items.length > 0">
                    <button
                        type="button"
                        class="btn btn-sm btn-outline-danger"
                        @click="deleteNotificationAll()">
                        <i class="bx bx-trash me-2"></i>Delete All
                    </button>
                </div>
            </div>

            <div v-if="items.length > 0">
                <div
                    class="card card-body card-white shadow-sm mb-3"
                    v-for="item in items"
                    :key="item.id">
                    <div class="notification-box d-flex justify-content-between">
                        <div>
                            <strong>{{ item.data.title }}</strong>
                            <p class="mb-0">{{ item.data.message }}</p>
                            <small>{{ formatRelativeTime(item.created_at) }}</small>
                        </div>
                        <div>
                            <button
                                type="button"
                                class="btn btn-sm btn-outline-danger"
                                @click="deleteNotification(item.id)">
                                <i class="bx bx-trash text-outline-danger"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <p v-else class="mb-0 text-center empty">No notifications</p>

        </div>
    </div>
</template>

<script>
import apiClient from '@/services';
import { useToast } from "vue-toastification";
import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";
dayjs.extend(relativeTime);

export default {
    data() {
        return {
            items: [],
            notificationCount: 0,
            toast: null,
            relativeInterval: null,
            autoReload: null
        };
    },

    async created() {
        this.toast = useToast();
        await this.notificationLoad();

        // ✅ Immediately mark all as read when page opens
        await this.markAllAsRead();

        // ✅ Notify navbar to remove badge instantly
        window.dispatchEvent(new Event("notifications-read"));

        // Refresh “time ago” every 10 seconds
        this.relativeInterval = setInterval(() => {
            this.$forceUpdate();
        }, 10000);

        // 🔁 Auto-refresh notifications every 10 seconds
        this.autoReload = setInterval(() => {
            this.notificationLoad();
        }, 10000);
    },

    beforeUnmount() {
        clearInterval(this.relativeInterval);
        clearInterval(this.autoReload);
    },

    methods: {
        async notificationLoad() {
            try {
                const response = await apiClient.get(`/notifications`);
                this.items = response.data.data;
                this.notificationCount = this.items.filter(item => !item.read_at).length;
            } catch (error) {
                console.error("Error loading notifications", error);
            }
        },

        async markAllAsRead() {
            try {
                await apiClient.post(`/notifications/read-all`);
                this.notificationCount = 0;
                this.items = this.items.map(n => ({ ...n, read_at: new Date().toISOString() }));
            } catch (error) {
                console.error("Error marking all notifications read", error);
            }
        },

        formatRelativeTime(date) {
            return dayjs(date).fromNow();
        },

        async deleteNotification(id) {
            try {
                await apiClient.delete(`/notifications/${id}`);
                this.items = this.items.filter(item => item.id !== id);
                this.toast.success("Deleted notification!");
            } catch (error) {
                console.error("Error deleting notification:", error);
                this.toast.error("Failed to delete notification.");
            }
        },

        async deleteNotificationAll() {
            try {
                await apiClient.delete(`/notificationAll`);
                this.items = [];
                this.toast.success("Deleted all notifications!");
            } catch (error) {
                console.error("Error deleting all notifications:", error);
                this.toast.error("Failed to delete all notifications.");
            }
        }
    }
};
</script>

<style scoped>
.empty {
    color: gray;
}
</style>
