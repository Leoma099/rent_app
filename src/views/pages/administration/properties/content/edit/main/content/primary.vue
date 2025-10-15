<template>

    <h3 class="fw-bold text-primary mb-0">Property Basic Info</h3>

    <div class="mt-3">
        <label class="form-label">* Property Name:</label>
        <input
            type="text"
            placeholder="ex. BUILDIN 1"
            class="form-control rounded-0"
            v-model="form.title">
    </div>

    <div class="mt-3">
        <label class="form-label">* Description:</label>
        <textarea rows="10" class="form-control rounded-0" v-model="form.description"></textarea>
    </div>

    <div class="mt-3">
        <label class="form-label">* Property Address:</label>
        <input
            type="text"
            placeholder="ex. ADDRESS 1"
            class="form-control rounded-0"
            v-model="form.address">
    </div>

    <div class="mt-3">
        <div class="row">
            <div class="col-md-6">
                <label class="form-label">* Business Type:</label>
                <select class="form-select rounded-0" v-model="form.property_type">
                    <option value="" disabled selected>-- select business type --</option>
                    <option value="1">Retail Orientation</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">* Price:</label>
                <input
                    type="number"
                    placeholder="ex. 25"
                    class="form-control rounded-0"
                    v-model="form.price">
            </div>
            <div class="col-md-3">
                <label class="form-label">* Size:</label>
                <input
                    type="number"
                    placeholder="ex. 25"
                    class="form-control rounded-0"
                    v-model="form.size">
            </div>
        </div>
    </div>

    <div class="mt-3">
        <label class="form-label">* Property Image:</label>
        <input
            type="file"
            class="form-control rounded-0">
    </div>

    <div class="mt-3">
        <label class="form-label">* Property Floor Plan:</label>
        <input
            type="file"
            class="form-control rounded-0">
    </div>

</template>

<script>
export default
{
    computed:
    {
        form()
        {
            return this.$parent.$data.form;
        }
    }
}
</script>