$(function() {
  $(".notice_writing_preview_tabs").
    children().
    click(set_notice_writing_preview);
});

function set_notice_writing_preview () {
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
  }
}
