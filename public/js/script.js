function confirmDelete(delUrl, params) {
    if (confirm("Are you sure you want to delete this entry?")) {
        $.post(delUrl, params, function (data) { window.location.reload() })
    }
}
