Riot.Stats = (function () {
    var opponents = [], num = 0, total = 0, scroller = null, w = "#miscWrapper";

    function submitLoad() {
        Riot.Hub.Post("stats", {}, Riot.Stats.Go);
    }

    function destroy() {
        opponents = [];
        scroller = null;
    }

    function render(c) {
        //  debugger; 
        $("#gamePH").hide();
        $("#miscPH").show();
        $("#sclP").hide();
        $("#miscScrollW").hide();
        $("#miscWrapper").show();
        initialLoad(c);
        $("#miscPT").text(Riot.Resource.PNStats);
    }

    function initialLoad(c) {
        //var self = this;
        opponents = c.o;
        total = c.tc;
        num = c.o.length;

        if (opponents.length > 0) {
            $(w).html(
                $.render(c.p, $('#statsW_tmpl').html())
            );

            $("#staW").html(
                $.render(opponents, $('#stats_tmpl').html())
            );

            eventSetup();
        }
        else {
            $(w).html(
                $('#statsE_tmpl').text()
            );
        }

        scroller = $("#sclSt_").scroller({ refresh: false });
    }

    function loadMore(c) {
        total = c.tc;
        //debugger;

        num = num + c.o.length;
        for (i = 0; i < c.o.length; i++) {
            opponents.push(c.o[i]);
        }

        var scrollTo = -1 * parseInt($("#staW").offset().height);

        $("#staW").html(
            $.render(this.Opponents, $('#stats_tmpl').html())
        );

        scroller.scrollTo({ x: scrollTo });

        eventSetup();
    }

    function submitMore() {
        var d = new Object();
        d["sw"] = num;
        Riot.Hub.Post("statsmore", d, Riot.Stats.Go);
    }

    function eventSetup() {
        //this;

        $("#_more").unbind("touchstart");
        if (total == 0 || num >= total) {
            $("#_more").hide()
        }
        else {
            $("#_more").show()
            $("#_more").bind('touchstart', function (e) {
                Riot.Hub.Stats.SubmitMore();
            });
        }

        $('[data-ref|=sta-play]').each(function (index) {
            $(this).unbind('touchstart');
            $(this).bind('touchstart', function (e) {
                Riot.StartGame.SubmitStart($(this).attr("data-val"));
            });
        });

        $('[data-ref|=sta-games]').each(function (index) {
            $(this).unbind('touchstart');
            $(this).bind('touchstart', function (e) {
                Riot.Scores.SubmitLoad($(this).attr("data-val"));
            });
        });

        $('[data-ref|=sta-vg]').each(function (index) {
            $(this).unbind('touchstart');
            $(this).bind('touchstart', function (e) {
                if ($(this).attr("data-val") != "0") {
                    Riot.Hub.Game.GetGame($(this).attr("data-val"));
                }
            });
        });

    }

    function go(d) {
        debugger;
        // if ($("#ajaxLoader").dialog("isOpen")) { $("#ajaxLoader").dialog("close"); }
        if (d.ReturnCode === 6) {
            loadMore(d.Context);
        }
        else if (d.ReturnCode === 7) {
            render(d.Context);
        }
    };

    return {
        SubmitLoad: submitLoad,
        Go: go,
        SubmitMore: submitMore,
        Destroy: destroy
    }
})();
