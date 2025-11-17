<template>

    <header>

        <div class="left d-flex align-items-center">
            <div class="me-3">
                <a href="javascript:void(0);" @click="toggleSidebar()">
                    <i class="bx bx-menu" style="font-size: 1.5rem; color: #000;"></i>
                </a>
            </div>
            <div>
                <div class="date">{{ date }} ( {{ day }} )</div>
                <div class="time">{{ time }}</div>
            </div>
        </div>

        <div class="right">
            <div class="d-flex align-items-center">

                <div class="icon-badge" ref="dropdownRef" @click="toggleDropdown">

                    <i class="bx bxs-bell icon-size"></i>
                    <span class="badge" v-if="notificationCount > 0">{{ notificationCount }}</span>


                    <!-- ✅ updated dropdown -->
                    <div v-show="dropdownOpen" class="dropdown animation-fade-in scrollable">


                        <div class="container my-3">

                            <div class="d-flex justify-content-between align-items-center" style="padding-inline: 10px;">
                                <div>
                                    <h3 class="mb-0">Notifications</h3>
                                </div>
                            </div>

                            <ul
                                v-if="items.length > 0"
                                class="notification-list mt-3">
                                    <li
                                        v-for="item in items"
                                        :key="item.id"
                                        class="mb-3"
                                        @click="notificationClick(item)"
                                    >
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="mb-0"><strong>{{ item.data.title }}</strong></h6>
                                                <p class="mb-0">{{ item.data.message }}</p>
                                                <small class="text-secondary">{{ formatRelativeTime(item.created_at) }}</small>
                                            </div>
                                        </div>
                                    </li>
                            </ul>

                            <p v-else class="mb-0 text-center empty">No notifications</p>

                        </div>

                    </div>

                </div>

                <router-link :to="'/my-account'">
                    <div>
                        <p class="mb-0">{{ userName }}</p>
                    </div>
                </router-link>

            </div>
        </div>

    </header>

</template>

<script>
import apiClient from '@/services';
import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";
import { useToast } from "vue-toastification";
dayjs.extend(relativeTime);
export default
{
    data()
    {
        return {
            dropdownOpen: false,
            items: [],
            userName: "Guest",
            notificationCount: 0,

            day: "",
            date: "",
            time: "",
            isSidebar: true,
        };
    },

    mounted()
    {
        this.fetchUserName();
        this.updateDateTime();
        this.notificationLoad();
        this.toast = useToast();

        // Poll every 10 seconds
        this.notificationInterval = setInterval(() => 
        {
            this.notificationLoad();
        }, 3000);

        // ✅ click outside listener
        document.addEventListener("click", this.handleClickOutside);

        // ✅ Responsive sidebar default
        this.setSidebarDefault();
        window.addEventListener('resize', this.setSidebarDefault);
    },

    beforeUnmount()
    {
        clearInterval(this.notificationInterval);
        document.removeEventListener("click", this.handleClickOutside);

        window.removeEventListener('resize', this.setSidebarByScreenSize);
    },

    methods:
    {
        formatRelativeTime(date)
        {
            // convert ISO timestamp into human readable form
            return dayjs(date).fromNow(); 
        },

        fetchUserName()
        {
            const fullName = localStorage.getItem("full_name");
            if (fullName)
            {
                this.userName = fullName;
            }
        },

        updateDateTime()
        {
            const now = new Date();

            const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
            this.day = days[now.getDay()];

            const options = { month: 'short', day: '2-digit', year: 'numeric' };
            this.date = now.toLocaleDateString('en-US', options);

            this.time = now.toLocaleTimeString('en-US', { hour12: true });
        },

        async notificationLoad()
        {
            try
            {
                const response = await apiClient.get(`/notifications`);
                this.items = response.data.data;
                this.notificationCount = this.items.filter(n => !n.read_at).length;
            }
            catch (error)
            {
                console.error("Error loading notifications", error);
            }
        },

        async markAllAsRead()
        {
            try
            {
                await apiClient.post(`/notifications/read-all`);
                this.notificationCount = 0;
                this.items = this.items.map(n => ({ ...n, read_at: new Date().toISOString() }));
            }
            catch (error)
            {
                console.error("Error marking all notifications read", error);
            }
        },

        toggleDropdown()
        {
            this.dropdownOpen = !this.dropdownOpen;

            // ✅ if opened, mark all as read
            if (this.dropdownOpen)
            {
                this.markAllAsRead();
            }
        },

        handleClickOutside(event)
        {
            const dropdown = this.$refs.dropdownRef;
            if (dropdown && !dropdown.contains(event.target))
            {
                this.dropdownOpen = false;
            }
        },

        async deleteNotification(id)
        {
            try
            {
                await apiClient.delete(`/notifications/${id}`);
                this.items = this.items.filter(item => item.id !== id);
                this.toast.success("Deleted notification!");
            }
            catch (error)
            {
                console.error("Error deleting notification:", error);
                this.toast.error("Failed to delete notification.");
            }
        },

        async deleteNotificationAll()
        {
            try
            {
                await apiClient.delete(`/notificationAll`);
                this.items = [];
                this.toast.success("Deleted all notifications!");
            }
            catch (error)
            {
                console.error("Error deleting all notifications:", error);
                this.toast.error("Failed to delete all notifications.");
            }
        },

        toggleSidebar()
        {
            const sidebar = document.querySelector('.sidebar');
            const contentArea = document.querySelector('.content-area');

            if (!sidebar || !contentArea) return;

            sidebar.classList.toggle('closed');
            contentArea.style.marginLeft = sidebar.classList.contains('closed') ? '0' : '240px';
        },

        setSidebarDefault()
        {
            const sidebar = document.querySelector('.sidebar');
            const contentArea = document.querySelector('.content-area');

            if (!sidebar || !contentArea) return;

            if (window.innerWidth < 768) {
                // Mobile: default closed
                sidebar.classList.add('closed');
                contentArea.style.marginLeft = '0';
            } else {
                // Desktop: default open
                sidebar.classList.remove('closed');
                contentArea.style.marginLeft = '240px';
            }
        },

        notificationClick(item)
        {
            console.log("Notification clicked:", item);

            if (item.data.inquiry_id)  // only inquiries
            {
                console.log("Redirect to /message for inquiry id:", item.data.inquiry_id);
                this.$router.push('/landlord/inquiries'); // redirect
            }
            else
            {
                console.log("Not an inquiry notification, no redirect.");
            }
        }

    }
};
</script>

<style scoped>
.icon-badge 
{
    position: relative;
    cursor: pointer;
    margin-right: 20px;
}

.badge 
{
    position: absolute;
    top: -5px;
    left: 18px;
    background: red;
    color: white;
    font-size: 0.7rem;
    border-radius: 100px;
}

/* Notification Dropdown */
.notification-container 
{
    position: relative;
}

.dropdown {
    position: absolute;
    right: -5px;
    top: 80px;
    background: white;
    color: black;
    width: 500px;
    box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
    border-radius: 5px;
    overflow: hidden;
    z-index: 1000;
    min-height: 600px;
    padding: 10px;
    animation-duration: 0.3s;
    animation-fill-mode: none;
}

@media (max-width: 767px) {
    .dropdown {
        right: -100px;   /* adjust offset for small screens */
        top: 80px;       /* same or adjust as needed */
        width: 300px;    /* smaller width for mobile */
        min-height: 600px;
        padding: 10px;
    }
    .left > div:nth-child(2)    
    {
        display: none;
    }
}

.animation-fade-in
{
    animation-name: fadeIn;
}

@keyframes fadeIn
{
    from
    {
        opacity: 0;
    }
    to
    {
        opacity: 1;
    }
}

.dropdown li 
{
    padding: 10px;
    border-bottom: 1px solid #7e1e1e;
}

.dropdown li:hover 
{
    background: #f5f5f5;
}

.dropdown .empty 
{
    text-align: center;
    padding: 10px;
    color: gray;
}

.scrollable 
{
    max-height: 300px;
    overflow-y: auto;
}

.scrollable::-webkit-scrollbar 
{
    width: 6px;
}

.scrollable::-webkit-scrollbar-track 
{
    background: #f1f1f1;
    border-radius: 10px;
}

.scrollable::-webkit-scrollbar-thumb 
{
    background: #888;
    border-radius: 10px;
}

.scrollable::-webkit-scrollbar-thumb:hover 
{
    background: #555;
}

.icon-size
{
    font-size: 1.5rem;
    color: #007bff;
    padding: 5px;
    border-radius: 5px;
}

.notification-list
{
  list-style: none;
  margin: 0;
  padding: 0;
}
.notification-list li
{
  padding: 10px;
  border-bottom: none; /* no borders */
  border-radius: 0.375rem;
}
</style>
