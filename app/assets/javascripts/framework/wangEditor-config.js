//= require wangEditor
//
// 简单使用: 在需要富文本的textarea加上 id="wangEditorArea"即可
$(document).ready(function(){
  wangEditor.config.printLog = false;
  var editor = new wangEditor("wangEditorArea");
  // 自定义菜单
  if (editor.config){
    editor.config.menus = [
      'source',
      'bold',
      'underline',
      'italic',
      'strikethrough',
      'eraser',
      'forecolor',
      'bgcolor',
      'quote',
      'fontfamily',
      'fontsize',
      'head',
      'unorderlist',
      'orderlist',
      'alignleft',
      'aligncenter',
      'alignright',
      'link',
      'unlink',
      'table',
      'insertcode',
      'undo',
      'redo',
      'fullscreen'
    ];
    editor.create();
  }
});
