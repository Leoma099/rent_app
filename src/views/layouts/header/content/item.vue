<template>
    <div @click="markAsUnread">
        <p class="mb-0">
            <span class="vh-text-bold">
                {{ item.notified_by.full_name }}
            </span>{{ item.message }}.
        </p>
        <div class="text-end">
            <small><i>Created at {{ formatDate(item.created_at) }}</i></small>
        </div>
    </div>
</template>

<script>
import apiClient from '@/services/index';


export default
{
    props:
    {
        item: Object,
        selectItem: Function,
        updateItem: Function,
    },

    data()
    {
        return {
            markLoading: false
        }
    },

    methods:
    {
        async markAsUnread()
        {
            try
            {
                if(!this.item.is_read)
                {
                    this.selectItem(this.item);

                    this.markLoading = true;

                    const response = await apiClient.put(`/borrow-notification/${this.item.id}/read`);
                    console.log(response.data);

                    this.markLoading = false;
                    this.updateItem(response.data);
                }
            }
            catch(error)
            {
                console.error(error)
            }
            finally
            {
                this.markLoading = false;
            }
            
        },

        formatDate(datetime)
        {
            const date = new Date(datetime);
            const options = {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: 'numeric',
                minute: '2-digit',
                hour12: true
            };
            return date.toLocaleString('en-US', options);
        }
    }
}
</script>