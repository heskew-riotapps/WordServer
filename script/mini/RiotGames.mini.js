
Riot.Games = (function (g) {
    var games = g; num = 0, scroller = null;

    function init(g) {
        //alert("games init");
        setup();
        num = g.t;
        games = g;
        //render();
        //  delete init; ///clean itself up to free up resources
    };

    function setGames(g) {
        games = g;
    };

    function setup() {
        //  $.views.allowCode = true;
        $.views.registerTags({
            agDeclinedAuto: function (n) {
                return $.format(Riot.Resource.Games_DeclinedAuto, n);
            },
            agDeclined: function (n) {
                return $.format(Riot.Resource.Games_Declined, n);
            },
            agTied: function (n) {
                return $.format(Riot.Resource.Games_Tied, n);
            },
            agWon: function (n) {
                return $.format(Riot.Resource.Games_Won, n);
            },
            agLost: function (n) {
                return $.format(Riot.Resource.Games_Lost, n);
            },
            agConceded: function (n) {
                return $.format(Riot.Resource.Games_Conceded, n);
            },
            agLeading: function (p, o) {
                return p > o;
            },
            agTrailing: function (p, o) {
                return p > o;
            },
            agTied: function (p, o) {
                return p > o;
            },
            agRmd: function (n) {
                return $.format(Riot.Resource.Games_RmdRollover, n);
            },
            agCh: function (n) {
                return $.format(Riot.Resource.Games_ChRollover, n);
            },
            agExtra: function (n) {
                return 220 - (n * 30);
            },
            agCExtra: function (n) {
                return 220 - (n * 30) - 30;
            }
        });
    };

    function load(l) {
        games = l;
        num = l.t;
        render();
    }

    function render() {
        // var self = this;
        //  debugger;
        $("#gamesScroll").empty();
        // $("#gamesW//rapper").accordion("destroy");

        debugger;
        $("#gamesScroll").html(
        // $('#games_tmpl').render(games)
            $.render(games, $('#games_tmpl').html())
        );

        if (!scroller) {
            scroller = $("#gamesScroll").scroller({ refresh: false });
        }
        else {
            scroller.scrollTo({ x: 0, y: 0 });
        }
        // var popupGuts = $.render(d, $('#popup_tmpl').html());

        // debugger;
        //$('#sclAc').tinyscrollbar({ minsizethumb: 20 });

        $('[data-ref|=game]').each(function (index) {
            $(this).on("touchstart", function (e) {
                Riot.Hub.Game().GetGame($(this).attr("data-val"));
            });
        });

        $('[data-ref|=page-link]').each(function (index) {
            $(this).off('touchstart');
            $(this).on("touchstart", function (e) {
                Riot.Hub.LoadPage($(this).attr("data-val"));
            });
        });

        $('[data-ref|=remind]').each(function (index) {
            $(this).on("touchstart", function (e) {
                Riot.Games.TurnReminder($(this).attr("data-f"), $(this).attr("data-n"), $(this).attr("data-d"), $(this).attr("data-g"), $(this).attr("id"));
                e.preventDefault();
                e.stopPropagation();
            });
        });

        setGamesTabText();
    };

    function setGamesTabText() {
        if (games.pCount > 0) {
            $("#rrtabpturn").show();
            $("#rrtabpturn").text(games.pCount).attr('title', Riot.Resource.RRPOver);
        }
        else {
            $("#rrtabpturn").hide();
        }
        if (games.oCount > 0) {
            $("#rrtaboturn").show();
            $("#rrtaboturn").text(games.oCount).attr('title', Riot.Resource.RROOver);
        }
        else {
            $("#rrtaboturn").hide();
        }
    };

    function submitReload(r) {
        var d = new Object();
        Riot.Hub.Post("reloadgames", d, Riot.Hub.Games.Go);
    };

    function turnReminder(f, n, d, g, id) {
        // var self = this;
        // $.blockUI();
        try {
            FB.ui({
                method: 'apprequests',
                message: $.format(Riot.Resource.RmdText, n, d),
                to: f,
                title: $.format(Riot.Resource.RmdTitle, n)
            }, function (r) {
                //  $.unblockUI();
                if (r) {
                    //   0
                    //hide reminder div
                    var req = r.request;
                    if (!req) { req = r.request_ids[0]; }
                    $("#" + id).hide();
                    Riot.Hub.Games.SubmitReminder(req, g);
                }
            });
        }
        catch (e) { } // $.unblockUI(); }
    }

    function submitReminder(r, g) {
        var d = new Object();
        d["rId"] = r;
        d["GameId"] = g;
        Riot.Hub.Post("turnreminder", d, Riot.Hub.Games.Go);
    };

    function go(d) {
        debugger;
        // if ($("#ajaxLoader").dialog("isOpen")) { $("#ajaxLoader").dialog("close"); }
        if (d.ReturnCode == 9) {
            Riot.Hub.Popup(d.Context.alT, d.Context.alTx);
            $("#fbText").val("");
        }
        else if (d.ReturnCode == 1) {
            Riot.Hub.Popup(Riot.Resource.GeneralErrorTitle, d.Error);
        }
    };

    return {
        Init: init,
        Go: go,
        SetGames: setGames,
        TurnReminder: turnReminder,
        Render: render 
    };
})();


 