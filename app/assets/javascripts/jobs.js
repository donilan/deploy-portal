document.addEventListener("turbolinks:load", function() {
  (function fetchTrace(state){
    var $traceEl = $('.trace[data-trace-url]');
    var url = $traceEl.data('trace-url');
    if (url) {
      $.ajax({
        url: url,
        data: { state: state },
        dataType: 'json',
        success: function(data) {
          $traceEl.append(data.html);
          if (data.status === 'running') {
            setTimeout(function(){ fetchTrace(data.state) }, 5000);
          }
        }
      });

    }
  })();
});
