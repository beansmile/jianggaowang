Jianggaowang.ProfilePage = {
  modifyAvatar: function() {
    var $input = $('#modify_avatar'),
        $cover = $('#profiles_edit .edit-avatar');
    Jianggaowang.Common.uploadImage($input, $cover);
  },
  autoSubmitAvatar: function() {
    $('#modify_avatar').change(function() {
      $(".edit_user").submit();
    });
  },
  init: function() {
    this.modifyAvatar();
    this.autoSubmitAvatar();
  }
};

$(function() {
  Jianggaowang.ProfilePage.init();
});
