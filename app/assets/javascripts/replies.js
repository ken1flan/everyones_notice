function setup_all_reply_writing_preview () {
  $(".reply_writing_preview_tabs").
    children().
    click(set_reply_writing_preview);
}

function set_reply_writing_preview () {
  var reply_writing = $(this).parent().parent().children(".reply_writing");
  var reply_preview = $(this).parent().parent().children(".reply_preview");

  if($(this).hasClass("reply_writing_tab")) {
    $(this).addClass("active");
    $(this).parent().children(".reply_preview_tab").removeClass("active");
    reply_writing.removeClass("sr-only");
    reply_preview.addClass("sr-only");
  } else {
    $(this).addClass("active");
    $(this).parent().children(".reply_writing_tab").removeClass("active");
    reply_writing.addClass("sr-only");
    reply_preview.removeClass("sr-only");
    $.post("/utils/markdown", { src: reply_writing.val() }, function (data) {

      reply_preview.find(".markdown_body").html(data);
    });
  }

  return false;
}
