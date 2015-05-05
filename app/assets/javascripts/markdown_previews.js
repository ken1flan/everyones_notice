function setup_all_markdown_writing_preview () {
  $(".markdown_writing_preview_tabs").
    children().
    click(set_markdown_writing_preview);
}

function set_markdown_writing_preview () {
  var markdown_writing = $(this).parent().parent().children(".markdown_writing");
  var markdown_preview = $(this).parent().parent().children(".markdown_preview");

  if($(this).hasClass("markdown_writing_tab")) {
    $(this).addClass("active");
    $(this).parent().children(".markdown_preview_tab").removeClass("active");
    markdown_writing.removeClass("sr-only");
    markdown_preview.addClass("sr-only");
  } else {
    $(this).addClass("active");
    $(this).parent().children(".markdown_writing_tab").removeClass("active");
    markdown_writing.addClass("sr-only");
    markdown_preview.removeClass("sr-only");
    $.post("/utils/markdown", { src: markdown_writing.val() }, function (data) {

      markdown_preview.find(".markdown_body").html(data);
    });
  }

  return false;
}
