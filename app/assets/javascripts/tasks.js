document.addEventListener("turbolinks:load", function() {
  (function refreshTasks(){
    var url = $('[data-tasks-index-url]').data('tasks-index-url');
    if (url) {
      $.ajax({ url: url, dataType: 'script'});
      setTimeout(refreshTasks, 5000);
    }
  })();
})
