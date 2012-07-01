
Riot.Scores = (function () {
    var scores = [], num = 0, total = 0, opponentId = 0, newOpponentId = 0, w = "#miscWrapper", scroller = null;

    function submitLoad(o) {
        var d = {};
        opponentId = o;
        d.o = o;
        Riot.Hub.Post("loadscores", d, Riot.Scores.Go);
    };

    function destroy() {
        scores = [];
        scroller = null;
    }

    function go(d) {
        //        if ($("#ajaxLoader").dialog("isOpen")) { $("#ajaxLoader").dialog("close"); }
        if (d.ReturnCode === 5) {
            loadMore(d.Context);
        }
        else if (d.ReturnCode === 4) {
            renderScores(d.Context);
        }
        if (d.ReturnCode === 1) {
            Riot.Hub.Popup(Riot.Resource.GeneralErrorTitle, d.Error);
        }
    };

    function renderScores(c) {
        $("#gamePH").hide();
        $("#miscPH").show();
        $("#sclP").hide();
        $("#miscScrollW").hide();
        $(w).show();
        loadScores(c);
        $("#miscPT").text(Riot.Resource.PNScores);
    };

    function loadScores(c) {

        scores = c.g;
        total = c.tc;
        num = c.g.length;
        if (c.ao == "0" && c.g.length == 0) {
            $(w).html(
            $('#scoresE_tmpl').text()
        );
        }
        else if (c.ao != "0" && c.g.length == 0) {
            $(w).html(
            $.render(c, $('#scoresEO_tmpl').html())
        );
        }
        else {
            $(w).html(
                $.render(c, $('#scoresW_tmpl').html())
            );

            $("#scW").html(
                $.render(scores, $('#scores_tmpl').html())
            );

            //   this.Render();
            eventSetup();

            $('#scO-dd').bind('change', function (e) {
                // debugger;
                Riot.Scores.OpponentId = $(this).val();
                Riot.Scores.Num = 0; ///change this to be pure method based
                Riot.Scores.SubmitMore();
            });
        }

        scroller = $("#sclSt_").scroller({ refresh: false });

    }

    function loadMore(c) {
        total = c.tc;
        var go = true;
        var more = true;

        if (c.ao != opponentId) {
            more = false;
            if (c.g.length == 0) {
                $(w).html(
                    $.render(c, $('#scoresEO_tmpl').html())
                );
                go = false;
            }
            else {

                num = c.g.length;
                scores = c.g;
            }
            opponentId = c.ao;
        }
        else {
            //this.NewOpponentId = 0;
            num = num + c.g.length;
            for (i = 0; i < c.g.length; i++) {
                scores.push(c.g[i]);
            }
        }

        debugger;
        if (go === true) {
            var scrollTo = -1 * parseInt($("#scW").offset().height + 20);

            $("#scW").html(
                $.render(scores, $('#scores_tmpl').html())
            );
            if (more == true) {
                scroller.scrollTo({ x: scrollTo });
            }
            else {
                scroller.scrollTo({ x: 0 });
            }
        }

        eventSetup();
    }

    function submitMore() {
        var d = {};
        d.sw = num;
        d.o = opponentId;
        Riot.Hub.Post("loadscoresmore", d, Riot.Scores.Go);
    }

    function eventSetup() {
        $("#_more").unbind("touchstart");
        if (num >= total) {
            $("#_more").hide()
        }
        else {
            $("#_more").show()
            $("#_more").bind('touchstart', function (e) {
                debugger;
                submitMore();
            });
        }

        $('[data-ref|=score-g]').each(function (index) {
            $(this).bind('touchstart', function (e) {
                Riot.Hub.Game().GetGame($(this).attr("data-val"));
            });
        });

    }

    return {
        SubmitLoad: submitLoad,
        Go: go,
        SubmitMore: submitMore,
        OpponentId: opponentId,
        Destroy: destroy
    };
})();


 