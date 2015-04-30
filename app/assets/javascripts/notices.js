function setup_all_notice_writing_preview () {
  $(".notice_writing_preview_tabs").
    children().
    click(set_notice_writing_preview);
}

function set_notice_writing_preview () {
  var notice_writing = $(this).parent().parent().children(".notice_writing");
  var notice_preview = $(this).parent().parent().children(".notice_preview");

  if($(this).hasClass("notice_writing_tab")) {
    $(this).addClass("active");
    $(this).parent().children(".notice_preview_tab").removeClass("active");
    $(this).parent().parent().children(".notice_writing").removeClass("sr-only");
    $(this).parent().parent().children(".notice_preview").addClass("sr-only");
  } else {
    $(this).addClass("active");
    $(this).parent().children(".notice_writing_tab").removeClass("active");
    $(this).parent().parent().children(".notice_writing").addClass("sr-only");
    $(this).parent().parent().children(".notice_preview").removeClass("sr-only");
    $.get("/utils/markdown", { src: notice_writing.val() }, function (data) {

      notice_preview.children(".panel-body").html(data);
    });
  }
}
