// noticeのいいねボタン処理
$(document).on('click', '.likeNotice', function () {
  var id = $(this).attr("id").substring(12);
  var up_down;
  if($(this).children(".star").attr("class").indexOf("star-empty") > 0){
    up_down = 'up';
  } else {
    up_down = 'down';
  }
  $.getJSON('/reputation/notice/' + id + '/' + up_down + '.json', function (json) {
    var button = $("#like_notice_" + json.id);
    if(json.evaluation_value == 0){
      button.children(".star").removeClass("glyphicon-star");
      button.children(".star").addClass("glyphicon-star-empty");
    } else {
      button.children(".star").removeClass("glyphicon-star-empty");
      button.children(".star").addClass("glyphicon-star");
    }
    button.children(".value").text(json.likes_count);
  });
});

// noticeの既読ボタン処理
$(document).on('click', '.openedNotice', function () {
  var id = $(this).attr("id").substring(14);
  var opened_or_not;
  if($(this).children(".opened").attr("class").indexOf("minus") > 0){
    opened_or_not = 'opened';
  } else {
    opened_or_not = 'not_opened';
  }
  $.getJSON('/notices/' + id + '/' + opened_or_not + '.json', function (json) {
    var button = $("#opened_notice_" + json.id);
    if(json.opened_or_not == "not_opened"){
      button.children(".opened").removeClass("glyphicon-ok");
      button.children(".opened").addClass("glyphicon-minus");
    } else {
      button.children(".opened").removeClass("glyphicon-minus");
      button.children(".opened").addClass("glyphicon-ok");
    }
  });
});

$(document).on('click', '.likeReply', function () {
  var id = $(this).attr("id").substring(11);
  var up_down;
  if($(this).children(".star").attr("class").indexOf("star-empty") > 0){
    up_down = 'up';
  } else {
    up_down = 'down';
  }
  $.getJSON('/reputation/reply/' + id + '/' + up_down + '.json', function (json) {
    var button = $("#like_reply_" + json.id);
    if(json.evaluation_value == 0){
      button.children(".star").removeClass("glyphicon-star");
      button.children(".star").addClass("glyphicon-star-empty");
    } else {
      button.children(".star").removeClass("glyphicon-star-empty");
      button.children(".star").addClass("glyphicon-star");
    }
    button.children(".value").text(json.likes_count);
  });
});
