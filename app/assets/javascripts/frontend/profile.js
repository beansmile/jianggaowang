Jianggaowang.ProfilePage = {
  modifyAvatar: function() {
    var $input = $('#modify_avatar'),
        $cover = $('#profiles_edit .edit-avatar');
    Jianggaowang.Common.uploadImage($input, $cover);
  },
  init: function() {
    this.modifyAvatar();
  }
};

$(function() {
  Jianggaowang.ProfilePage.init();
});
