//var Riot = (function () {
//    return {};
//} ());

Riot.Hub = (function () {
    var rulesHtml = "", badgesHtml = "", termsHtml = "", privacyHtml = "", feedbackHtml = "", game = null,
        games = null, player = '', numGames = 0, pRulesHtml = "", pBadgesHtml = "", pTermsHtml = "", pPrivacyHtml = "",
        pFeedbackHtml = "", scroller = null, btn1Funct = null, btn2Func = null;

    //debugger;
    $(document).ready(function () { init(); });


    function init(g, gs) {
        games = cGames;
        numGames = games.t;
        player = cPlayer;
        setupNav();
        game = new Riot.Game(cGame);
        if (numGames > 0) {
            game.Init();
            debugger;
            Riot.Games.Init(games);

            //self.LoadAds();
        }

        // popup('title', 'text');
        //        else {
        //            this.SubmitStart();
        //        }

        // Riot.Hub.Feedback.init();
        // Riot.Hub.Feedback.initSB(g);
    }

    function getGame() {
        return game;
    }
    function post(url, data, success) {
        url = "/facebook/canvas/" + url;
        //        if (!arguments[2] || bypassLoader == false) {
        //            $("#ajaxLoader").dialog("open");
        //        }
        $.ajax({
            url: url,
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(data),
            contentType: 'application/json; charset=utf-8',
            success: function (d) {
                success(d);
            }
        });
    };

    function go(d) {
        //if ($("#ajaxLoader").dialog("isOpen")) { $("#ajaxLoader").dialog("close"); }
        if (d.ReturnCode == 1) {
            popup(Riot.Resource.GeneralErrorTitle, d.Error);
        }
        else if (d.ReturnCode == 0) {
            if (d.Url.length > 0) { location.href = d.Url; }
        }
        else if (d.ReturnCode == 3) {
            var p = d.Context.page;
            var h = d.Context.html;
            switch (p) {
                case "1":
                    pRulesHtml = h;
                    break;
                case "2":
                    pBadgesHtml = h;
                    break;
                case "3":
                    pTermsHtml = h;
                    break;
                case "4":
                    pPrivacyHtml = h;
                    break;
                case "7":
                    pFeedbackHtml = h;
                    break;
            };

            renderPage(p, h);
        };

    };

    function hidePopup() {
        $("#_popup").hide().empty(); //remove from dom
        $("#_veil").hide().empty(); //remove from dom
    };

    function veil() {
        // this might be inefficient
    };

    function hideVeil() {

    };
    function popup(t, tx, btn1Text, btn1Action, btn2Text, btn2Action) {
        //create a popup overlay background class: position:absolute; left:0; top:0; width:100%; height:100%;opacity: .80;
        //filter: Alpha(Opacity=80);background-color:black;
        //add a popup background and render popup template

          debugger;
        var d = {};
        if (t.length > 0) { d.t = t; } //title
        d.tx = tx; //text
        d.b1 = (btn1Text ? btn1Text : Riot.Resource.OK);
        if (btn2Text && btn2Action) {
            d.b2 = btn2Text;
        }

        var popupGuts = $.render(d, $('#popup_tmpl').html());
        var veil = $("<div></div>").attr("id", "_veil").addClass("v");
        //if (!popup) { popup = $("<div></div>"); }
        var popup = $("<div></div>").attr("id", "_popup").addClass("pu").html(popupGuts); ;
        // popup

        $('body').append(veil).append(popup);
        popup.css("margin", "-" + document.getElementById("_popup").offsetHeight / 2 + "px 0 0 -" + document.getElementById("_popup").offsetWidth / 2 + "px");
        // popup.css("margin-top", "-" + document.getElementById("_popup").offsetHeight / 2 + "px");
        // popup.css("margin-left", "-" + document.getElementById("_popup").offsetWidth / 2 + "px");


        //        $("#puB1").bind("touchstart", function () {
        //            Riot.Hub.HidePopup();
        //        });

        // $("#puB1").on("touchstart", Riot.Hub.HidePopup());
        if (btn1Action) {
            $("#puB1").on("touchstart", function () {
                btn1Action;
            });
        }
        else {
            $("#puB1").on("touchstart", function () {
                Riot.Hub.HidePopup();
            });
        }
        if (btn2Action) {
            $("#puB2").on("touchstart", function () {
                btn2Action;
            });
        }
        //add a new element, assign to page
        //    <div id="_popup" style="display:none;" >

        //set events

    };

    function setupNav() {

        $('#startG').bind('touchstart', function () {
            Riot.Start.SubmitLoad();
        });

        $('[data-ref|=m-page]').each(function (index) {
            $(this).bind('touchstart', function (e) {
                debugger;
                Riot.Hub.LoadPage($(this).attr("data-val")); return false;
            });
        });

        $('[data-ref|=menuHasChild]').each(function (index) {
            $(this).bind('touchstart', function (e) {
                Riot.Hub.ToggleNav($(this).attr("data-val"));
            });
        });
    };

    function toggleNav(i) {
        $("#" + i).toggle();
    };

    function destroy() {
        scroller = null;
    };

    function loadPage(p) {
        Riot.Stats.Destroy();
        Riot.Scores.Destroy();

        switch (p) {
            case 0:
                if (numGames > 0) { ///add to games
                    $("#miscPH").hide();
                    $("#gamePH").show();
                    $('#rrAd').hide();
                    $('#rrGame').show();
                    game.SetMainTab("m-rt-gm");
                    reloadAds();
                    break;
                }
                else {
                    Riot.Start.SubmitLoad();
                    break;
                }
            case 5:
                Riot.Scores.SubmitLoad('0');
                $('#rrAd').show();
                $('#rrGame').hide();
                reloadAds();
                break;
            case 6:
                Riot.Stats.SubmitLoad();
                $('#rrAd').show();
                $('#rrGame').hide();
                reloadAds();
                break;
            default:
                var html = "";
                switch (p) {
                    case "1":
                        html = pRulesHtml;
                        break;
                    case "2":
                        html = pBadgesHtml;
                        break;
                    case "3":
                        html = pTermsHtml;
                        break;
                    case "4":
                        html = pPrivacyHtml;
                        break;
                    case "7":
                        html = pFeedbackHtml;
                        break;
                }
                if (html.length > 0) {
                    renderPage(p, html);
                }
                else {
                    var data = {};
                    data.p = p;
                    post("page", data, Riot.Hub.Go);
                }

                setTimeout(function () { $("#menuChild-1").hide(); }, 300);
                break;
        }
        $("#toGame").unbind('touchstart');
        $("#toGame").bind('touchstart', function (e) {
            Riot.Hub.LoadPage("0");
        });

        //setBackToGame();
    };

    function renderPage(p, html) {
        $("#gamePH").hide();
        $("#miscPH").show();
        $("#sclP").show();
        $("#miscWrapper").hide();
        $("#miscScrollW").show();

        $("#miscScroll").html(html).show();
        if (!scroller) {
            scroller = $("#miscScroll").scroller({ refresh: false });
        }
        else {
            scroller.scrollTo({ x: 0, y: 0 });
        }

        switch (p) {
            case "1":
                $('#rrAd').show();
                $('#rrGame').hide();

                $("#miscPT").text(Riot.Resource.PNRules);
                break;
            case "2":
                $('#rrAd').show();
                $('#rrGame').hide();
                $("#miscPT").text(Riot.Resource.PNBadges);
                break;
            case "3":
                $('#rrAd').show();
                $('#rrGame').hide();
                $("#miscPT").text(Riot.Resource.PNTerms);
                break;
            case "4":
                $('#rrAd').show();
                $('#rrGame').hide();
                $("#miscPT").text(Riot.Resource.PNPrivacy);
                break;
            case "7":
                $('#rrAd').show();
                $('#rrGame').hide();
                $("#miscPT").text(Riot.Resource.PNFeedback);
                Riot.Feedback.Init();
                break;
        }

        //reloadAds();
        setPageLinks();

    };

    function setPageLinks() {
        $('[data-ref|=page-link]').each(function (index) {
            $(this).unbind('touchstart');
            $(this).bind('touchstart', function (e) {
                Riot.Hub.LoadPage($(this).attr("data-val"));
            });
        });
    };

    return {
        Init: init,
        Post: post,
        Popup: popup,
        Go: go,
        ToggleNav: toggleNav,
        LoadPage: loadPage,
        RenderPage: renderPage,
        HidePopup: hidePopup,
        Game: getGame

    };

})();

 