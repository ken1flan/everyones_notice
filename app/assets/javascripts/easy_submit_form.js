$(document).on("ready page:load", function () {
  setup_all_easy_submit();
});

function setup_all_easy_submit () {
  setup_easy_submit(".easy_submit_form textarea");
}

function setup_easy_submit (selector) {
  $(selector).keypress( function (e) {
    if (event.ctrlKey) {
      if (e.keyCode === 10) {
        $(this).closest("form").find("input.btn-primary[type=submit]").click();
      }
    }
  } );
}
