// function toggleInventoryDropdown() {
//     var dropdown = document.getElementById("inventoryDropdown");
//     var caret = document.getElementById("inventoryCaret").querySelector("i");

//     dropdown.style.display = (dropdown.style.display === "none") ? "block" : "none";

//     caret.classList.toggle("bx-caret-right");
//     caret.classList.toggle("bx-caret-down");
// }
document.addEventListener("DOMContentLoaded", function () {
    const sidebarLinks = document.querySelectorAll(".sidebar-nav li");

    sidebarLinks.forEach(link => {
        link.addEventListener("click", function () {
            // Remove active class from all links
            sidebarLinks.forEach(item => item.classList.remove("active"));

            // Add active class to the clicked link
            this.classList.add("active");
        });
    });
});
