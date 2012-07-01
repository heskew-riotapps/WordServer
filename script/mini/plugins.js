(function ($) {

    $.fn.shuffle = function () {
        return this.each(function () {
            var items = $(this).children().clone(true);
            return (items.length) ? $(this).html($.shuffle(items)) : this;
        });
    }

    $.shuffle = function (arr) {
        for (var j, x, i = arr.length; i; j = parseInt(Math.random() * i), x = arr[--i], arr[i] = arr[j], arr[j] = x);
        return arr;
    }

})(jq);


$.fn.getOverlapPct = function (draggable) {
    //  debugger;
    var a = $(this);
    var a_x1 = a.offset().left;
    var a_x2 = a_x1 + a.outerWidth();
    var a_y1 = a.offset().top;
    var a_y2 = a_y1 + a.outerHeight();

    var d_x1 = draggable.offset().left;
    var d_x2 = d_x1 + draggable.outerWidth();
    var d_y1 = draggable.offset().top;
    var d_y2 = d_y1 + draggable.outerHeight()

    //if draggable's left edge is to the right of the elem's right edge, 
    //then draggable is totally to the right of elem
    if (a_x1 > d_x2) { return 0; }

    //if draggable's right edge is to the left of the elem's left edge, 
    //then draggable is totally to the left of elem
    if (a_x2 < d_x1) { return 0; }

    //if draggable's top edge is below elem's bottom edge, 
    //then draggable is totally below the elem
    if (a_y1 > d_y2) { return 0; }

    //if draggable's bottom edge is above elem's top edge, 
    //then draggable is totally above the elem
    if (a_y2 < d_y1) { return 0; }

    //ok we've passed the basics, there is some overlap to discover...let's find it, shall we?
    var o_x1 = a_x1, o_x2 = a_x2, o_y1 = a_y1, o_y2 = a_y2, o_w = 0, o_h = 0;

    //var o_x1 = (d_x1 > a_x1) ? d_x1 : a_x1;

    if (d_x1 > a_x1) { o_x1 = d_x1; }
    if (d_x2 < a_x2) { o_x2 = d_x2; }
    if (d_y1 > a_y1) { o_y1 = d_y1; }
    if (d_y2 < a_y2) { o_y2 = d_y2; }
    o_w = o_x2 - o_x1;
    o_h = o_y2 - o_y1;

    var a_sa = a.outerWidth() * a.outerHeight(), o_sa = o_w * o_h;

    return Math.round((o_sa / a_sa) * 100);

};

jq.format = function jQuery_dotnet_string_format(text) {
    //check if there are two arguments in the arguments list
    if (arguments.length <= 1) {
        //if there are not 2 or more arguments there's nothing to replace
        //just return the text
        return text;
    }
    //decrement to move to the second argument in the array
    var tokenCount = arguments.length - 2;
    for (var token = 0; token <= tokenCount; ++token) {
        //iterate through the tokens and replace their placeholders from the text in order
        text = text.replace(new RegExp("\\{" + token + "\\}", "gi"), arguments[token + 1]);
    }
    return text;
};

//jq.fn.sort = function () {
//    return this.pushStack([].sort.apply(this, arguments), []);
//};

jq.fn.grep = function (elems, callback, inv) {
    var ret = [], retVal;
    inv = !!inv;

    // Go through the array, only saving the items
    // that pass the validator function
    for (var i = 0, length = elems.length; i < length; i++) {
        retVal = !!callback(elems[i], i);
        if (inv !== retVal) {
            ret.push(elems[i]);
        }
    }

    return ret;
};

//function numOnly(val) {
//    if (isNaN(parseFloat(val)))
//        val = val.replace(/[^0-9.-]/, "");

//    return parseFloat(val);
//}

var _offsetX, _offsetY, _startX, _startY;

jq.fn.draggable = function (elems, callback, inv) {
    this.on('touchstart', function (e) {
        //   debugger;
        _offsetX = (window.outerWidth - this.offsetWidth) / 2;
        _offsetY = (window.outerHeight - this.offsetHeight) / 2;
        _startX = e.targetTouches[0].pageX - _offsetX;
        _startY = e.targetTouches[0].pageY - _offsetY;


        this.style.position = "absolute";
        //debugger;
        ///////clone thiss div here!!!!

        // alert($(this).attr('id
        //var touch = e.touches[0]

        //  touch.target.x_ = touch.pageX;
        //  touch.target.y_ = touch.pageY;
    });
    this.on('touchend', function (e) {
        debugger;
//        var diffX = (e.touches[0].pageX - _offsetX) - _startX;
//        var diffY = (e.touches[0].pageY - _offsetY) - _startY;
        //        var el = document.elementFromPoint(diffX, diffY);

//        var temp = $("<div style='width:5px;height:5px;background-color:green;position:absolute;z-index:1100;left:" + e.touches[0].pageX + "px;top:" + e.touches[0].pageY + "px;'>&nbsp;</div>");
//        $("body").append(temp);
//      
        var t = Riot.Hub.Game().GetBoardTileByCoordinates(e.touches[0].pageX, e.touches[0].pageY);

        alert(t.Id + " l:" + t.Letter + " r:" + t.Row + " c:" + t.Column);
        //        _offsetX = 0;
        //        _offsetY = 0;
        //        _startX = 0;
        //        _startY = 0;
    });
    this.on('touchmove', function (e) {
        if (e.touches.length == 1) { // Only deal with one finger
            // var touch = e.touches[0]; // Get the information for finger #1

            var diffX = (e.changedTouches[0].pageX - _offsetX) - _startX;
            var diffY = (e.changedTouches[0].pageY - _offsetY) - _startY;
            this.style.webkitTransform = "translate3d(" + diffX + "px," + diffY + "px,0)";
            // this.css("-webkit-transform", "translate3d(" + diffX + "px, 0, 0)");


            //            var node = touch.target; // Find the node the drag started from
            //            node.style.position = "absolute";
            // var startTop = numOnly(new WebKitCSSMatrix(window.getComputedStyle(this).webkitTransform).f) - numOnly(this.scrollTop);
            // var startLeft = numOnly(new WebKitCSSMatrix(window.getComputedStyle(this).webkitTransform).e) - numOnly(this.scrollLeft);

            //            var translateOpen = 'm11' in new WebKitCSSMatrix() ? "3d(" : "(";
            //            var translateClose = 'm11' in new WebKitCSSMatrix() ? ",0)" : ")";
            ////            this.style.position = "absolute";
            ////           this.style.webkitTransform = "translate3d(" + touch.clientX + "px," + touch.clientY + "px,0)";
            // $(this).attr('x_', touch.pageX).attr('y_', touch.pageY);
            // touch.target.x_ = touch.pageX;
            // touch.target.y_ = touch.pageY;
            //            this.style.webkitTransitionDuration = time + "ms";
            //            this.style.webkitBackfaceVisiblity = "hidden";
            //            this.style.webkitTransitionTimingFunction = timingFunction;

            //            // -webkit-transform: translate3d(300px, 0, 0);
            //            this.style.left = touch.pageX + "px";
            //            this.style.top = touch.pageY + "px";
        }
    });

};