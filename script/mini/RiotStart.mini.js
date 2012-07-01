Riot.Start = (function () {

    var dynamic = [], friends = [], name = '', fbId = '', w = "#miscWrapper", scroller = null;

    $.views.registerTags({
        badge: function (b) {
            return Riot.Utils.GetBadgeTitle(b);
        }
    });


    function submitLoad() {
        //  debugger;
        if (friends.length === 0) {
            Riot.Hub.Post("loadfriends", {}, Riot.Start.Go);
        }
        else {
            $("#gamePH").hide();
            $("#miscPH").show();
            $("#sclP").hide();
            $("#miscWrapper").show();
            reloadFriends(c.fr);
            $("#miscPT").text(Riot.Resource.PNStart);
        }
        $('#rrAd').show();
        $('#rrGame').hide();

        //  reloadAds();
        //setBackToGame();
    }

    function render(c) {
        //  debugger; 
        $("#gamePH").hide();
        $("#miscPH").show();
        $("#sclP").hide();
        $(w).show();
        loadFriends(c.fr);
        $("#miscPT").text(Riot.Resource.PNStart);
    }


    function ReloadFriends() {
        dynamic = friends;

        $(w).html(
            $('#startSrch_tmpl').text()
        );

        render();
        inputSetup();
        eventSetup();
    }

    function loadFriends(f) {
        // var fs = f;
        debugger;
        // fs = fs.sort(); // $(fs).sort(sort);
        f.sort(function (a, b) {
            var A = a.n.toLowerCase(), B = b.n.toLowerCase()
            if (A < B) //sort string ascending
                return -1
            if (A > B)
                return 1
            return 0 //default return value (no sorting)
        });
        for (i = 0; i < f.length; i++) {
            var fr = {};
            fr.b = f[i].b;
            fr.p = f[i].p;
            fr.f = f[i].f;
            fr.n = f[i].n;
            friends.push(fr);
        }
        dynamic = friends;

        $(w).html(
            $('#startSrch_tmpl').text()
        );

        renderFriends();
        inputSetup();
        eventSetup();
    }

    function renderFriends() {
        $("#scW").html(
            $.render(dynamic, $('#start_tmpl').html())
        );

        if (!scroller) {
            scroller = $("#scW").scroller({ refresh: false });
        }
        else {
            scroller.scrollTo({ x: 0 });
        }
    }

   // function sort(a, b) {
   //     return (a.p === 0 ? '9' + a.n : 0 + a.n) > (b.p === 0 ? '9' + b.n : 0 + b.n) ? 1 : -1;
   // }

    function inputSetup() {
        var text = Riot.Resource.FindFriend;
        $("#searchbar").attr("value", text);

        //        $("#searchbar").focus(function () {
        //            $(this).addClass("active");
        //            if ($(this).attr("value") == text) $(this).attr("value", "");
        //        });

        //        $("#searchbar").blur(function () {
        //            $(this).removeClass("active");
        //            if ($(this).attr("value") == "") { $(this).attr("value", text); $(this).removeClass("populated"); }
        //            else { $(this).addClass("populated"); }
        //        });

        $("#searchbar").bind('keyup', function () {////?????? is this the same for mobile
            if ($(this).attr("value").length > 0) {
                Riot.Start.Filter($(this).attr("value"));
            }
            else {
                Riot.Start.KeyUp();
            }
        });
    }

    function keyUp() {
        dynamic = friends;
        renderFriends();
        eventSetup();
    }

    function eventSetup() {
        $('[data-ref|=invite]').each(function (index) {
            $(this).bind('touchstart', function (e) {
                Riot.Start.Name = $(this).attr("data-name");
                Riot.Start.FBId = $(this).attr("data-val");
                try {
                    FB.ui({
                        method: 'apprequests',
                        message: $.format(Riot.Resource.InviteText, Riot.Hub.Player),
                        to: $(this).attr("data-val"),
                        title: $.format(Riot.Resource.InviteTitle, $(this).attr("data-name").split(/\b/)[0])
                    }, function (r) {
                        if (r) {
                            var req = r.request;
                            if (!req) { req = r.request_ids[0]; }
                            Riot.Start.SubmitInvite(req);
                        }
                    });
                }
                catch (e) { }
            });
        });
        $('[data-ref|=play]').each(function (index) {
            $(this).bind('touchstart', function (e) {
                Riot.Start.SubmitStart($(this).attr("data-val"));
            });
        });
        $('[data-ref|=limit]').each(function (index) {
            $(this).bind('touchstart', function (e) {
                Riot.Start.OverLimit();
            });
        });
    }

    function submitInvite(r) {
        //$.blockUI();
        var d = {};
        d["fbId"] = fbId;
        d["n"] = name;
        d["rId"] = r;

        Riot.Hub.Post("invite", d, Riot.Start.Go);
    }

    function filter(kw) {
        var arr = $.grep(this.friends, function (n, i) { ///will have to make a plugin for grep
            return (n.n.toLowerCase().indexOf(kw.toLowerCase()) > -1);
        });
        dynamic = arr;
        render();
        eventSetup();
    }

    function submitStart(p) {
        var d = {};
        d["fId"] = p;
        Riot.Hub.Post("start", d, Riot.Start.Go);
    }

    function overLimit(p) {
        var d = "#dialog";
        var t = "#dialogText";
        $(t).html(Riot.Resource.OGameLimitText);
        $(d).dialog("option", "title", Riot.Resource.GeneralErrorTitle);
        $(d).dialog("open");
        $(d).dialog("option", "height", $(t).outerHeight() + 110);
    }

    function go(d) {
        debugger;
        if (d.ReturnCode === 4) {
            Riot.Hub.Game.LoadGame(data);
        }

        if (d.ReturnCode === 1) {
            popup(Riot.Resource.GeneralErrorTitle, d.Error);
            //            var d = "#dialog";
            //            var t = "#dialogText";
            //            $(t).html(d.Error);
            //            $(d).dialog("option", "title", Riot.Resource.GeneralErrorTitle);
            //            $(d).dialog("open");
            //            $(d).dialog("option", "height", $(t).outerHeight() + 110);
        }
        else if (d.ReturnCode === 5) {
            render(d.Context);
        };

    }

    return {
        Name: name,
        FBId: fbId,
        Go: go,
        SubmitInvite: submitInvite,
        SubmitStart: submitStart,
        OverLimit: overLimit,
        KeyUp: keyUp,
        Filter: filter,
        SubmitLoad: submitLoad
    }

})();