Jianggaowang.SlidesPage = {

  uploadSlideAudio: function() {
    function progress() {
      var $progress =  $('#file_upload .progress'),
          $uploadDone = $('#file_upload .upload-done'),
          current = 0;

      $uploadDone.hide();
      $progress.fadeIn();
      var intervalId = setInterval(function() {
        current++;
        $progress.text(current+'%');
        if(current == 100) {
          clearInterval(intervalId);
          $progress.fadeOut(100);
          setTimeout(function() {
            $uploadDone.fadeIn();
          },110);
        }
      },100);
    };

    $('#upload_lecture').change(function() {
      progress();
    });
  },

  init: function() {
    this.uploadSlideAudio();
  }
};

$(function() {
  Jianggaowang.SlidesPage.init();

  var audioCloseForDelete = function() {
    $("#live_record .icon").unbind("click").bind("click", function() {
      $("#live_record").addClass("hidden");
      $("#slide_audio").val('');
      $("#upload_slide").removeAttr('disabled');
    })
  }

  var audioCloseForStop = function() {
    $("#live_record .icon").unbind("click").bind("click", function() {
      up.stop()
      var origin_audio = $("#live_record").data('origin-audio');
      if (origin_audio === '') {
        $("#live_record").addClass("hidden");
        $("#slide_audio").val('');
      } else {
        $("#live_record .file-name").text(origin_audio);
        $("#slide_audio").val(origin_audio);
      }
      $("#upload_slide").removeAttr('disabled');
      audioCloseForDelete();
    })
  }

  if ($("#upload_audio").length > 0) {
    audioCloseForDelete();

    $.get('/uploader_config', function(json) {
      var uploader = Qiniu.uploader($.extend(json, {
        runtimes: 'html5,html4',
        browse_button: 'upload_audio',
        get_new_uptoken: false,
        max_file_size: '50mb',
        multi_selection: false,
        filters: {
          mime_types : [
            { title : "Audio files", extensions : "mp3,wav,ogg" },
          ]
        },
        max_retries: 3,
        dragdrop: false,
        drop_element: 'container',
        chunk_size: '4mb',
        auto_start: true,
        init: {
          'FilesAdded': function(up, files) {
            plupload.each(files, function(file) {
              // 文件添加进队列后,处理相关的事情
            });
          },
          'BeforeUpload': function(up, file) {
            // 每个文件上传前,处理相关的事情
            $("#live_record .file-name").text("0%");
            $("#upload_slide").attr('disabled', 'disabled');
            audioCloseForStop();
            $("#live_record").removeClass("hidden");
          },
          'UploadProgress': function(up, file) {
            $("#live_record .file-name").text(file.percent + "%");
          },
          'FileUploaded': function(up, file, info) {
            // 每个文件上传成功后,处理相关的事情
            // 其中 info 是文件上传成功后，服务端返回的json，形式如
            // {
            //    "hash": "Fh8xVqod2MQ1mocfI4S4KpRL6D98",
            //    "key": "gogopher.jpg"
            //  }
            // 参考http://developer.qiniu.com/docs/v6/api/overview/up/response/simple-response.html

            var res = JSON.parse(info);
            $("#slide_audio").val(res.key);
            var key_arr = res.key.split('/');
            $("#live_record .file-name").text(key_arr[key_arr.length - 1]);
            $("#upload_slide").removeAttr('disabled');
          },
          'Error': function(up, err, errTip) {
            //上传出错时,处理相关的事情
          },
          'UploadComplete': function() {
            //队列文件处理完毕后,处理相关的事情
          },
          'Key': function(up, file) {
            // 若想在前端对每个文件的key进行个性化处理，可以配置该函数
            // 该配置必须要在 unique_names: false , save_key: false 时才生效
            var date = new Date()
            return ['audios', date.getFullYear(), date.getMonth(), date.getDate(), file.name].join('/');
          }
        }
      }));
    })
  }
});
