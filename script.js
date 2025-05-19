window.addEventListener("message", function(event) {
    if (event.data.action === "openMiningUI") {
        document.getElementById("miningUI").style.display = "block";
    } else if (event.data.action === "closeMiningUI") {
        document.getElementById("miningUI").style.display = "none";
    }
});

document.getElementById("startBtn").addEventListener("click", function () {
    fetch(`https://${GetParentResourceName()}/startMiningClick`, { method: "POST" });
});
document.getElementById("closeBtn").addEventListener("click", function () {
    fetch(`https://${GetParentResourceName()}/close`, { method: "POST" });
});