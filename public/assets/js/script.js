function toggleInventoryDropdown1() {
    var dropdown = document.getElementById("inventoryDropdown1");
    var caret = document.getElementById("inventoryCaret1").querySelector("i");

    dropdown.style.display = (dropdown.style.display === "none") ? "block" : "none";

    caret.classList.toggle("bx-caret-right");
    caret.classList.toggle("bx-caret-down");
}

function toggleInventoryDropdown2() {
    var dropdown = document.getElementById("inventoryDropdown2");
    var caret = document.getElementById("inventoryCaret2").querySelector("i");

    dropdown.style.display = (dropdown.style.display === "none") ? "block" : "none";

    caret.classList.toggle("bx-caret-right");
    caret.classList.toggle("bx-caret-down");
}