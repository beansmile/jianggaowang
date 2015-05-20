var initPhotoSwipeFromDOM = function(gallerySelector) {

  // parse slide data (url, title, size ...) from DOM elements
  // (children of gallerySelector)
  var parseThumbnailElements = function(el) {
    var thumbElements = el.childNodes,
      numNodes = thumbElements.length,
      items = [],
      figureEl,
    childElements,
    linkEl,
    size,
    item;

    for(var i = 0; i < numNodes; i++) {

      figureEl = thumbElements[i]; // <figure> element

      // include only element nodes
      if(figureEl.nodeType !== 1) {
        continue;
      }

      linkEl = figureEl.children[0]; // <a> element

      //size = linkEl.getAttribute('data-size').split('x');

      // create slide object
      item = {
        src: linkEl.getAttribute('href'),
        w: linkEl.children[0].naturalWidth,
        h: linkEl.children[0].naturalHeight
        //w: parseInt(size[0], 10),
        //h: parseInt(size[1], 10)
      };

      if(figureEl.children.length > 1) {
        // <figcaption> content
        item.title = figureEl.children[1].innerHTML;
      }

      if(linkEl.children.length > 0) {
        // <img> thumbnail element, retrieving thumbnail url
        item.msrc = linkEl.children[0].getAttribute('src');
      }

      item.el = figureEl; // save link to element for getThumbBoundsFn
      items.push(item);
    }

    return items;
  };

  // find nearest parent element
  var closest = function closest(el, fn) {
    return el && ( fn(el) ? el : closest(el.parentNode, fn) );
  };

  // triggers when user clicks on thumbnail
  var onThumbnailsClick = function(e) {
    e = e || window.event;
    e.preventDefault ? e.preventDefault() : e.returnValue = false;

    var eTarget = e.target || e.srcElement;

    var clickedListItem = closest(eTarget, function(el) {
      return (el.tagName && el.tagName.toUpperCase() === 'FIGURE');
    });

    if(!clickedListItem) {
      return;
    }

    // find index of clicked item
    var clickedGallery = clickedListItem.parentNode,
      childNodes = clickedListItem.parentNode.childNodes,
      numChildNodes = childNodes.length,
      nodeIndex = 0,
      index;

    for (var i = 0; i < numChildNodes; i++) {
      if(childNodes[i].nodeType !== 1) {
        continue;
      }

      if(childNodes[i] === clickedListItem) {
        index = nodeIndex;
        break;
      }
      nodeIndex++;
    }

    if(index >= 0) {
      openPhotoSwipe( index, clickedGallery );
    }
    return false;
  };

  // parse picture index and gallery index from URL (#&pid=1&gid=2)
  var photoswipeParseHash = function() {
    var hash = window.location.hash.substring(1),
      params = {};

    if(hash.length < 5) {
      return params;
    }

    var vars = hash.split('&');
    for (var i = 0; i < vars.length; i++) {
      if(!vars[i]) {
        continue;
      }
      var pair = vars[i].split('=');
      if(pair.length < 2) {
        continue;
      }
      params[pair[0]] = pair[1];
    }

    if(params.gid) {
      params.gid = parseInt(params.gid, 10);
    }

    if(!params.hasOwnProperty('pid')) {
      return params;
    }
    params.pid = parseInt(params.pid, 10);
    return params;
  };

  var openPhotoSwipe = function(index, galleryElement, disableAnimation) {
    var pswpElement = document.querySelectorAll('.pswp')[0],
      gallery,
    options,
    items;

    items = parseThumbnailElements(galleryElement);

    // define options (if needed)
    options = {
      index: index,

      // define gallery index (for URL)
      galleryUID: galleryElement.getAttribute('data-pswp-uid'),

      getThumbBoundsFn: function(index) {
        // See Options -> getThumbBoundsFn section of docs for more info
        var thumbnail = items[index].el.getElementsByTagName('img')[0], // find thumbnail
          pageYScroll = window.pageYOffset || document.documentElement.scrollTop,
          rect = thumbnail.getBoundingClientRect();

        return {x:rect.left, y:rect.top + pageYScroll, w:rect.width};
      },

      // history & focus options are disabled on CodePen
      // remove these lines in real life:
      history: false,
      focus: false

      //,
      //  showHideOpacity:true
    };

    if(disableAnimation) {
      options.showAnimationDuration = 0;
    }

    // Pass data to PhotoSwipe and initialize it
    gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options);

    // in fact, we donot need to use uselargeimages and realviewportwidth now,
    // but it's ok to keep them there.
    //
    // create variable that will store real size of viewport
    var realViewportWidth,
    useLargeImages = false,
      firstResize = true,
      imageSrcWillChange;


    // gettingData event fires each time PhotoSwipe retrieves image source & size
    gallery.listen('gettingData', function(index, item) {

      var $targetImage = $("figure:nth-child("+(index+1)+") img");
      if ( !$targetImage[0].loaded ) {
        $targetImage.trigger("appear");
        $targetImage.one("load", function() {
          if ( item.w !== $targetImage[0].naturalWidth ) {
            item.w = $targetImage[0].naturalWidth;
            item.h = $targetImage[0].naturalHeight;
            gallery.invalidateTargetItem(index); // reinit Items
            gallery.updateSize(true); // reinit Items
          }
        });
      }

      // Set image source & size based on real viewport width
      //if( useLargeImages ) {
        //item.src = item.originalImage.src;
        //item.w = item.originalImage.w;
        //item.h = item.originalImage.h;
      //} else {
        //item.src = item.mediumImage.src;
        //item.w = item.mediumImage.w;
        //item.h = item.mediumImage.h;
      //}

      // It doesn't really matter what will you do here,
      // as long as item.src, item.w and item.h have valid values.
      //
      // Just avoid http requests in this listener, as it fires quite often

    });

    gallery.init();
  };

  // loop through all gallery elements and bind events
  var galleryElements = document.querySelectorAll( gallerySelector );

  for(var i = 0, l = galleryElements.length; i < l; i++) {
    galleryElements[i].setAttribute('data-pswp-uid', i+1);
    galleryElements[i].onclick = onThumbnailsClick;
  }

  // Parse URL and open gallery if it contains #&pid=3&gid=1
  var hashData = photoswipeParseHash();
  if(hashData.pid > 0 && hashData.gid > 0) {
    openPhotoSwipe( hashData.pid - 1 ,  galleryElements[ hashData.gid - 1 ], true );
  }
};

// execute above function
$('document').ready(function(){
  initPhotoSwipeFromDOM('.slide-list');
});
