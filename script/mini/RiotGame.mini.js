//$.namespace('Riot.Game');

Riot.Game = function (context, games, page) {
    //this.Letters = new Array();
    // this.ImgSrc = "";
    //  this.Img = new Image();
    this.BoardTiles = new Array();
    this.TrayTiles = new Array();
    this.Cols = 14;
    this.Rows = 14;
    this.TrayTileIdInClickContext = "";
    this.LetterInDragContext = "";
    this.BoardTileIdInClickContext = "";
    // this.TimerIdInTrayTileIdInDropOverContext = -1;
    //this.BoardTileWidth = 0;
    this.TrayTileWidth = 0;
    this.DragArea = new Array;
    this.RemoveBoardTileDrag = false;
    this.Context = context; // Riot.Context;
    this.Opponent = null;
    this.PlacedTiles = new Array();
    this.PlayedTiles = new Array();
    this.PlacedWords = new Array();
    this.StarterTiles = new Array();
    this.MarkedAsWordTiles = new Array();
    this.Page = page;
    this.StateKey; // = "{Game:'" + this.Context.g + "',Turn:'" + this.Context.tn + "'}";
    this.TrayStateKey; //  = "{Game:'" + this.Context.g + "',Turn:'" + this.Context.tn + "',Type:'ts'}";
    this.BoardStateKey; //  = "{Game:'" + this.Context.g + "',Turn:'" + this.Context.tn + "',Type:'bs'}";
    // this.PlacedTileState = null;
    this.State;
    this.ResetState = false;
    this.interval = null;
    this.asInterval = null;
    this.CalculatedValue = 0;
    this.autoShuffle = false;
    this.autoShuffleCount = 0;
    this.Games;
    this.Alerts = new Array();
    this.wordsScroller = null;
    this.gameScroller = null;

    //    this.BoardTop;
    //    this.BoardLeft;
    this.DragOffsetX;
    this.DragOffsetY;
    this.DragStartX;
    this.DragStartY;
    this.touchActive = '';
    this.dragClone = null;
    this.dragTile = null;


    //this.TrayTileClass = "tt";
    this.TileTrayIdPrefix = "tt_";
    this.TrayTileDragClass = "tt_d",
    this.TrayTileValueDragClass = "ttv_d";
    this.TrayTileLetterDragClass = "ttl_d";
    // this.TrayTileEmptyClass = "tt_e";
    // this.TrayTileValueEmptyClass = "ttv_e";
    // this.TrayTileLetterEmptyClass = "ttl_e";
    this.TrayTileNoDragClass = "riotTrayTileNoDrag"; ///??????
    this.TileDivIdPrefix = "t_";
    this.TileRowIdPrefix = "tr_";
    this.TileRowClass = "tr";
    this.TileDivValueIdPrefix = "tv_";
    this.TileDivCornerIdPrefix = "tc_";
    this.TileDivLetterIdPrefix = "tl_";
    this.TileTrayValueIdPrefix = "ttv_";
    //this.TrayTileValueClass = "ttv";
    //  this.TileTrayLetterIdPrefix = "ttl_";
    // this.TrayTileLetterClass = "ttl";
    this.TileBonusSizeClass = "tbs";
    this.TileClass = "t";
    this.TileValueClass = "tv";
    this.TileLetterClass = "tl";
    this.TilePlacedClass = "t_pl";
    this.TileValuePlacedClass = "tv_pl";
    this.TileLetterPlacedClass = "tl_pl";
    this.TileOPlacedClass = "t_op";
    this.TileValueOPlacedClass = "tv_op";
    this.TileLetterOPlacedClass = "tl_op"
    this.TileReplacementClass = "t_r";
    this.TileValueReplacementClass = "tv_r";
    this.TileLetterReplacementClass = "tl_r";
    this.TilePlayedClass = "t_p";
    this.TileValuePlayedClass = "tv_p";
    this.TileLetterPlayedClass = "tl_p";
    this.TileLastPlayedClass = "t_lp";
    this.TileValueLastPlayedClass = "tv_lp";
    this.TileLetterLastPlayedClass = "tl_lp";
    this.TileDragClass = "t_d";
    this.TileValueDragClass = "tv_d";
    this.TileLetterDragClass = "tl_d";
    this.HideClass = "h";
    this.GameBtnDisabledClass = "gb_d";
    this.Tile4LClass = "t_4l";
    this.TileValue4LClass = "tv_4l";
    this.TileLetter4LClass = "tl_4l";
    this.TileCorner4LClass = "tc_4l";
    this.Tile3LClass = "t_3l";
    this.TileValue3LClass = "tv_3l";
    this.TileLetter3LClass = "tl_3l";
    this.TileCorner3LClass = "tc_3l";
    this.Tile3WClass = "t_3w";
    this.TileValue3WClass = "tv_3w";
    this.TileLetter3WClass = "tl_3w";
    this.TileCorner3WClass = "tc_3w";
    this.Tile2LClass = "t_2l";
    this.TileValue2LClass = "tv_2l";
    this.TileLetter2LClass = "tl_2l";
    this.TileCorner2LClass = "tc_2l";
    this.Tile2WClass = "t_2w";
    this.TileValue2WClass = "tv_2w";
    this.TileLetter2WClass = "tl_2w";
    this.TileCorner2WClass = "tc_2w";
    this.TileEmptyClass = "t_e";
    this.TileValueEmptyClass = "tv_e";
    this.TileLetterEmptyClass = "tl_e";
    this.TileStartClass = "t_s";
    this.TileValueStartClass = "tv_s";
    this.TileLetterStartClass = "tl_s";

    //  this.sb = sb;

    var self = this;
    self.PreInit();
    // self.Init();

    //if clicked on board tile with a played letter and no tray tile in context, 
    //add board tile to context and wait for next click.  if click is on
    //tray, remove board tile from context and wait for next click. 
    //if played letter is on target clicked tile, move played letter back to
    //tray and play new tray context letter
}
Riot.Game.prototype.PreInit = function () {
    //$.template('sb_tmpl', $('#sb_tmpl'));
    //    $.template('info_tmpl', $('#info_tmpl'));
    //    $.template('swap_tmpl', $('#swap_tmpl'));
    this.SetupSB();
    this.SetupTabs();
    //        position: { of: '#gameBg', at: 'center center' },
//    $("#ajaxLoader").dialog({
//        position: [175, 350],
//        autoOpen: false,
//        width: 75,
//        height: 75,
//        title: "",
//        modal: true,
//        draggable: false,
//        resizable: false
//    }).siblings('.ui-dialog-titlebar').remove();

//    $("#dialog").dialog({
//        position: { of: '#divBoard' },
//        autoOpen: false,
//        width: 375,
//        modal: true,
//        draggable: false,
//        resizable: false//,
//        //open: function () {
//        //     $('.ui-dialog-buttonpane').find('button').addClass('dialogButton');
//        // }
//    });


}

Riot.Game.prototype.SetGames = function (g) {
    this.Games = g;
}


Riot.Game.prototype.RefreshState = function () {
    this.SaveState();
    this.State = null;
    this.LoadState();
}

Riot.Game.prototype.PopupAlert = function () {
    // debugger;
    if (this.Context.sa && this.Context.sa == "1") {
        var self = this;
        $.blockUI();
        try {
            FB.ui({
                method: 'apprequests',
                message: this.Context.saText,
                to: this.Context.oFB,
                title: this.Context.saTitle
            }, function (r) {
                $.unblockUI();
                if (r) {
                    var req = r.request;
                    if (!req) { req = r.request_ids[0]; }
                    self.SubmitAlert(req);
                }
            });
        }
        catch (e) { $.unblockUI(); }
    }
}

Riot.Game.prototype.RenderTemplates = function () {
    $('#sb').empty();
    $('#gInfo').empty();
    $("#swap").empty().remove();
    $("#swapWrapper").empty();
    //$("#chWr").empty();

    $("#swap").unbind("dialog");
    // $.tmpl('info_tmpl', this.Context.sb).appendTo('#gInfo');
    //  $.tmpl('sb_tmpl', this.Context.sb).appendTo('#sb');

    $("#sb").html(
        $.render(this.Context.sb, $('#sb_tmpl').html())
    	//    $('#sb_tmpl').render(this.Context.sb)
        );

    $("#gInfo").html(
    	    //$('#info_tmpl').render(this.Context.sb)
            $.render(this.Context.sb, $('#info_tmpl').html())
        );
    $("#swapWrapper").html(
	        $.render(this.Context,$('#swap_tmpl').html())
            //$('#swap_tmpl').render(this.Context)
        );

    this.RenderChatter();

}

Riot.Game.prototype.SetupTabs = function () {
    var self = this;
    debugger;
    $('[data-ref|=railtab]').each(function (index) {
        $(this).on('touchstart', function (e) {
            self.SetTab($(this).attr("id"));
        });
    });

    $('[data-ref|=m-railtab]').each(function (index) {
        $(this).on('touchstart', function (e) {
            self.SetMainTab($(this).attr("id"));
        });
    });
    if (this.Context.g) { this.SetGameTabText("m-rt-gm"); }
}

Riot.Game.prototype.SetGameTabText = function (id) {
    var game0 = (id == "m-rt-gm" ? "rTabTurnActive" : "rTabTurnInactive");
    var game1 = Riot.Resource.PTurn;
    var game2 = (this.Context.active == true && this.Context.sb.pTurn == 1 ? "inline" : "none");
    var game3 = (id == "m-rt-gm" ? "rTabTurnActive" : "rTabTurnInactive");
    var game4 = $.format(Riot.Resource.OTurn, this.Context.sb.oFName);
    var game5 = (this.Context.sb.pTurn == 1 ? "none" : "inline");
    if (this.Context.active == false) { game3 = "none"; }
    var game6 = this.Context.sb.oFName; //opponent name

    $("#m-rt-gm").html($.format(Riot.Resource.RailMainTabGame, game0, game1, game2, game3, game4, game5, game6));
}


Riot.Game.prototype.SetMainTab = function (id) {
    var self = this;
    $('[data-ref|=m-railtab]').each(function (index) {
        var x = $(this).attr("id");
        if ($("#" + x).hasClass("m-railTab-a")) {
            $("#" + x).removeClass('m-railTab-a')
        }
        if (!$("#" + x).hasClass("m-railTab-i")) {
            $("#" + x).addClass('m-railTab-i')
        }
        self.SetGameTabText(id);
    });

    $("#" + id).removeClass('m-railTab-i').addClass('m-railTab-a');

    $("#railGames").hide();
    $("#railGame").hide();

    switch (id) {
        case "m-rt-gm":
            $("#railGame").show();

            break;
        case "m-rt-gms":
            $("#railGames").show();
            Riot.Games.Render();
            /////// $('#sclAc').tinyscrollbar_update(); //hack because scrollbar not working properly if it started within a hidden div when the page rendered


            break;
    }
}

Riot.Game.prototype.SetTab = function (id) {
    $('[data-ref|=railtab]').each(function (index) {
        var x = $(this).attr("id");
        if ($("#" + x).hasClass("railTab-a")) {
            $("#" + x).removeClass('railTab-a')
        }
        if (!$("#" + x).hasClass("railTab-i")) {
            $("#" + x).addClass('railTab-i')
        }
    });

    $("#" + id).removeClass('railTab-i').addClass('railTab-a');

    $("#chWr").hide();
    $("#wWr").hide();

    switch (id) {
        case "rt-ch":
            $("#chWr").show();
            break;
        case "rt-wd":
            $("#wWr").show();
            this.SubmitWords();
            break;
    }
}


Riot.Game.prototype.RenderChatter = function () {
   // $("#chWr").innerHTML = "";
   // $("#chWr_").html("");
    debugger;

    //574 = height of gamePH
    // $("#chWr").height(574 - ($("#rt-ch").position().top + $("#rt-ch").outerHeight(false) - $("#rr").position().top) - 27);
    //  $("#chWr").css("height", 574 - ($("#rt-ch").offset().top + $("#rt-ch").offset().height - $("#rr").offset().top) + "px");
    $("#chWr").css("height", (574 - ($("#rt-ch").offset().top + $("#rt-ch").offset().height - $("#rr").offset().top) - 26) + "px");
    $("#chWr_").html(
	        $.render(this.Context, $('#chatter_tmpl').html())
        );

 //   alert($("#rt-ch").offset().top + " " + $("#rt-ch").offset().height + " " + $("#rr").offset().top);
   // $("#chWr").css("height", "174px");
    
    if ($("#chVP").attr("data-ref") == "noInput") {
        $("#chVP").css('height', $("#chWr").offset().height - 6);
        // $("#chVP").css('height', $("#chWr").offset().height - 6);
    }
    else {
        $("#chVP").css('height', $("#chWr").offset().height - 15);
        //        $("#chVP").css('height', $("#chWr").offset().height - 32);
    }
    if (!this.gameScroller) {
        this.gameScroller = $("#chWr_").scroller({ refresh: false });
    }
    else {
        this.gameScroller.scrollTo({ x: 0, y: 0 });
    }
    // $('#sclC').tinyscrollbar({ minsizethumb: 20 });
    // $('#sclC').tinyscrollbar_update('bottom');
}

//only hit ajax if context.words does not exist
Riot.Game.prototype.RenderWords = function () {
    var self = this;
    debugger;
    //alert(this.Context.Words);
    // $("#game").hide();
    // $("#wWr").show();
  //  $("#wWr_").html("");
   
    //574 = height of gamePH  27 = margin at bottom
    //$("#wWr").height(574 - ($("#rt-ch").position().top + $("#rt-ch").outerHeight(false) - $("#rr").position().top) - 29);
    $("#wWr").css("height", (574 - ($("#rt-ch").offset().top + $("#rt-ch").offset().height - $("#rr").offset().top) - 28) + "px");


    $("#wWr_").html(
    //$('#words_tmpl').render(this.Context)
            $.render(this.Context, $('#words_tmpl').html())
        );

    if (!this.wordsScroller) {
        this.wordsScroller = $("#wWr_").scroller({ refresh: false });
    }
    else {
        this.wordsScroller.scrollTo({ x: 0, y: 0 });
    }

    //$("#wVP").height($("#wWr").height() - 6);

    //  $('#sclW').tinyscrollbar({ minsizethumb: 20 });

    //    $('#btnWList').unbind('click').text(Riot.Resource.SBBackToGameBtn).attr("title", Riot.Resource.SBBackToGameBtnOver);
    //    $('#btnWList').click(function () {
    //        //debugger;
    //        self.GoToGame();
    //    });

//    if (!this.wordsScroller) {
//        this.wordsScroller = $("#w_").scroller({ refresh: false });
//    }
//    else {
//        this.wordsScroller.scrollTo({ x: 0, y: 0 });
//    }
    $('[data-ref|=def]').each(function (index) {
        $(this).on('click', function (e) {
            self.SubmitDefs($(this).attr("data-val"));
        });
    });
    //page.ReloadAds();
}


Riot.Game.prototype.RenderDefs = function () {
    var self = this;
    $("#wWr_").empty();
//    $("#wWr").height(574 - ($("#rt-ch").position().top + $("#rt-ch").outerHeight(false) - $("#rr").position().top) - 29);
    $("#wWr").css("height", (574 - ($("#rt-ch").offset().top + $("#rt-ch").offset().height - $("#rr").offset().top) - 29) + "px");
//    $("#wWr").css("height", (574 - ($("#rt-ch").offset().top + $("#rt-ch").offset().height - $("#rr").offset().top) - 28) + "px");

    $("#wWr_").html(
        $.render(this.Context.Defs, $('#defs_tmpl').html())
	   // $('#defs_tmpl').render(this.Context.Defs)
    );
  //  $("#defsVP").height($("#wWr").height() - 28);

    if (!this.wordsScroller) {
        this.wordsScroller = $("#wWr_").scroller({ refresh: false });
    }
    else {
        this.wordsScroller.scrollTo({ x: 0, y: 0 });
    }


  //  $('#sclD').tinyscrollbar({ minsizethumb: 20 });

    //    $('#btnWList').unbind('click').text(Riot.Resource.SBBackToWordsBtn).attr("title", Riot.Resource.SBBackToWordsBtnOver);
    $('#defB').on('click',function () {
        self.RenderWords();
    });
    // page.ReloadAds();
}
Riot.Game.prototype.GoToGame = function () {
    var self = this;
    $("#game").show();
    $("#gameW").hide();
    $('#btnWList').unbind('click').text(Riot.Resource.SBWordsBtn).attr("title", Riot.Resource.SBWordsBtnRollover);
    $('#btnWList').click(function () {
        self.SubmitWords();
    });
    // page.ReloadAds();
}

Riot.Game.prototype.SetupSB = function () {
    var self = this;
    $.views.allowCode = true;
    $.views.registerTags({
        pTurn: function (s, t) {
            return (s == "1" && t == "1" ? Riot.Resource.PTurn : "");
        },
        pClass: function (s, t) {
            return (s == "1" && t == "1" ? "sbTurnYes" : "sbTurnNo");
        },
        oTurn: function (turn) {
            return (turn == 1 ? $.format(Riot.Resource.OTurn, self.Context.sb.oFName) : "");
        },
        oClass: function (turn) {
            return (turn == 1 ? "sbTurnYes" : "sbTurnNo");
        },
        winner: function () {
            return Riot.Resource.SBWinner;
        },
        points: function (n) {
            return Riot.Resource.SBPotentialPoints;
        },
        pointsOver: function (n) {
            return Riot.Resource.SBPotentialPointsOver;
        },
        overlaysOver: function (n) {
            return $.format(Riot.Resource.SBOverlaysLeftRollover, n);
        },
        overlays: function (n) {
            return (n == 1 ? Riot.Resource.SBOverlayLeft : $.format(Riot.Resource.SBOverlaysLeft, n));
        },
        letters: function (n) {
            //  debugger;
            return ($.format(Riot.Resource.SBLettersLeft, n));
        },
        listOver: function () {
            return Riot.Resource.SBWordsBtnRollover;
        },
        listBtn: function () {
            return Riot.Resource.SBWordsBtn;
        },
        notFirst: function (c) {
            return this.itemNumber != 1;
        },
        lVal: function (l) {
            return self.GetLetterValue(l);
        },
        wD: function (l) {
            return Riot.Resource.Definition;
        },
        wLU: function (w) {
            return ($.format(Riot.Resource.LookupWord, w));
        },
        wPB: function (n, t, p) {
            return ($.format(Riot.Resource.WordPlayedBy, n, t, p));
        },
        wNF: function (w) {
            return ($.format(Riot.Resource.DefNotFound, w));
        },
        lower: function (s) {
            return (!s ? "" : s.toLocaleLowerCase());
        },
        bWL: function (w) {
            return Riot.Resource.SBBackToWordsBtn;
        },
        bWLO: function (w) {
            return Riot.Resource.SBBackToWordsBtnOver;
        },
        ld: function (d) {
            return Riot.Utils.GetLocalDate(d);
        },
        cv: function (c, v) {
            return ($.format(Riot.Resource.Letters, c, v));
        },
        opW: function (n) {
            return (n == "1" ? Riot.Resource.Opp1Win : $.format(Riot.Resource.OppXWins, n));
        },
        opR: function (o) {
            return ($.format(Riot.Resource.OppRecord, o));
        },
        sCh: function (n) {
            return ($.format(Riot.Resource.StartChatter, n));
        },
        noCh: function (n) {
            return ($.format(Riot.Resource.NoChatter, n));
        },
        noSc: function (n) {
            return ($.format(Riot.Resource.NoScoresO, n));
        }
    });
}

Riot.Game.prototype.SubmitAlert = function (r) {
    var data = new Object();
    data["rId"] = r;

    this.Post("turnalert", data, true);
}
Riot.Game.prototype.ClearState = function () {
    var ls = Riot.Utils.LocalStorage();
    //clear localStorage for items within this game.
    if (ls) {
        for (i = 0; i <= ls.length - 1; i++) {
            var o = eval('(' + ls.key(i) + ')');
            if (o.Game && o.Turn) {
                if (o.Game == this.Context.g) {
                    Riot.Utils.RemoveStorageItem(ls.key(i));
                }
            }
        }
    }
}

Riot.Game.prototype.LoadState = function () {

    if (this.State == null) {
        var ls = Riot.Utils.LocalStorage();

        //clear localStorage for items within this game not associated with this turn.
        //they are officially useless
        if (ls) {
            for (i = 0; i <= ls.length - 1; i++) {
                var o = eval('(' + ls.key(i) + ')');
                if (o.Game && o.Turn) {
                    if (o.Game == this.Context.g && o.Turn != this.Context.tn) {
                        Riot.Utils.RemoveStorageItem(ls.key(i));
                    }
                    else if (ls.key(i) == this.StateKey) {
                        this.State = eval('(' + Riot.Utils.GetStorageItem(ls.key(i)) + ')');
                    }
                }
            }
        }
    }
}

Riot.Game.prototype.SetPlayBtn = function () {
    if (this.Context.sb.pTurn == 1) {
        this.LoadPlacedTiles();
        var txt = Riot.Resource.PlayTurn;
        var title = Riot.Resource.PlayTurnTitle;
        if (this.PlacedTiles.length == 0) {
            txt = Riot.Resource.SkipTurn;
            title = Riot.Resource.SkipTurnTitle;
        }
        $("#btnPlay").text(txt).attr('title', title);
    }
}

Riot.Game.prototype.Init = function () {
  //  debugger;

    var self = this;
    $("#game").show();
    $("#gameW").hide();
    $("#miscPH").hide();
    $("#gamePH").show();
    $('#rrAd').hide();
    $('#rrGame').show();
    this.State = null;
    this.StateKey = "{Game:'" + this.Context.g + "',Turn:'" + this.Context.tn + "'}";
    this.TrayStateKey = "{Game:'" + this.Context.g + "',Turn:'" + this.Context.tn + "',Type:'ts'}";
    this.BoardStateKey = "{Game:'" + this.Context.g + "',Turn:'" + this.Context.tn + "',Type:'bs'}";

    //    this.RenderTemplates();

    this.TrayTileWidth = 40; // this.GetTrayTileWidth();
    if (this.Context.active == true) { this.LoadState(); }

    this.LoadBoardTiles();

    //    this.Log("init.top2: " + this.DragArea[1]);
    this.LoadBoard(false);

    // debugger;
    ////////    var dragAreaTop = $('#divTray').offset().top;
    ////////    var dragAreaLeft = $('#divBoardWrapper').offset().left;
    ////////    var dragAreaWidth = $('#divBoardWrapper').outerWidth();
    ////////    var dragAreaHeight = $('#divGameWrapper').outerHeight(); // +this.TrayTileWidth; // +5; //3 is for a little padding  $('#divTray').outerHeight();

    ////////    this.DragArea[0] = dragAreaLeft - (this.TrayTileWidth / 15); //left
    ////////    this.DragArea[1] = dragAreaTop; // -(this.TrayTileWidth / 4);  //top
    ////////    this.DragArea[2] = dragAreaLeft + dragAreaWidth - this.TrayTileWidth + (this.TrayTileWidth / 15);  //right
    ////////    this.DragArea[3] = dragAreaTop + dragAreaHeight; // -this.TrayTileWidth + (this.TrayTileWidth / 15);  //bottom

    //this.Log("dah:" + dragAreaHeight);

    //    this.Log("init.traytilewidth: " + this.TrayTileWidth);
    //    this.Log("init.left: " + this.DragArea[0]);
    //    this.Log("init.top: " + this.DragArea[1]);
    //    this.Log("init.right: " + this.DragArea[2]);
    //    this.Log("init.bottom: " + this.DragArea[3]);

    //this.LoadBoardTiles();

    //    this.Log("init.top2: " + this.DragArea[1]);
    //this.LoadBoard(false);
    //    this.Log("init.top3: " + this.DragArea[1]);
    if (this.Context.active == true) { this.LoadBoardTilesFromState(); }

    this.LoadTrayTiles(true);
    this.LoadTray();

    this.SetTab("rt-ch")
    this.RenderTemplates();

    this.TurnEventSetUp();
    //this.DialogSetup();

    var self = this;

    //if not this player's turn set up interval
    try { this.interval = clearInterval(this.interval); } catch (e) { }
    if (this.Context.active == true) {
        if (this.Context.sb.pTurn == 0) {
            this.interval = setInterval(function () {
                self.CheckTurn();
            }, 240000);
        }
        else {
            this.interval = setInterval(function () {
                self.CheckChatter();
            }, 240000);
        }
    }


    //RefreshState was slowing down the drop events when it was in line so
    //now we just set a var when it should be reset and just check that 
    //flag every 5 seconds
    if (this.Context.active == true) {
        this.SetPlayBtn();

        setInterval(function () {
            self.CheckState();
        }, 5000);
    }
    else {
        this.ClearState();
    }

    this.CalcOnFly();

}


Riot.Game.prototype.DialogSetup = function () {
    return; //change this to template driven

    var self = this;

    var btns = {};

    btns[Riot.Resource.SwapBtn] = function () {
        var arr = new Array();
        $.each($(".riotSwapTile"), function (index, value) {
            if ($(this).hasClass("riotSwapTileSelected")) {
                arr.push(value.id.replace("riotSwap_", ""));
            }
        });
        if (arr.length == 0) {
            $(this).dialog("close");
            self.Dialog(Riot.Resource.SwapEmptyTitle, Riot.Resource.SwapEmptyText);
        }
        else {
            $(this).dialog("close");
            self.SubmitSwap(arr);
        }
    }
    btns[Riot.Resource.Cancel] = function () { $(this).dialog("close"); }

    $("#swap").dialog({
        position: { of: '#divBoard' },
        title: Riot.Resource.SwapTitle,
        autoOpen: false,
        height: 200,
        width: 375,
        modal: true,
        draggable: false,
        resizable: false,
        buttons: btns//,
        //  open: function () {
        //     $('.ui-dialog-buttonpane').find('button').addClass('dialogButton');
        //   }
    });

}

Riot.Game.prototype.CheckState = function () {
    if (this.ResetState == true) {
        this.RefreshState();
        this.ResetState = false;
    }
}

Riot.Game.prototype.LoadBoardTilesFromState = function () {
    if (this.State != null) {
        var store = this.State.Placed;
        if (store != null && store.length > 0) {
            for (i = 0; i <= store.length - 1; i++) {
                var tile = this.GetBoardTileById(store[i].I);
                tile.SetPlacedTile(store[i].V);
                this.SetBoardTile(tile);
            }
        }
    }
}

Riot.Game.prototype.GetLetterValue = function (l) {
    var letterVal = "";
    $(Riot.Alphabet.Letters).each(function (index, value) {
        if (value.C == l) {
            letterVal = value.V;
            return false;
        }
    });

    return letterVal;

}

//Riot.Game.prototype.c = function () {
//    //get width from css
//    var w = 0;
//    var wd = $('<div></div>');
//    wd.html('&nbsp;');
//    { wd.addClass(this.TrayTileClass); }
//    $('#divOutOfViewport').append(wd);
//    w = wd.width();
//    wd.remove();
//    return w;
//}

Riot.Game.prototype.LoadBoardTiles = function () {
    var q = 0;
    for (i = 0; i <= this.Rows; i++) {
        for (j = 0; j <= this.Cols; j++) {

            this.BoardTiles[q] = new Riot.Tile();
            this.BoardTiles[q].Id = q;
            this.BoardTiles[q].Row = i + 1;
            this.BoardTiles[q].Column = j + 1;

            var o = this.GetPlayedTile(q);
            if (o.Letter.length > 0) {

                this.BoardTiles[q].Letter = o.Letter;
                this.BoardTiles[q].OriginalLetter = o.Letter;

                this.BoardTiles[q].IsLastPlayed = (o.LastPlay == "1") ? true : false;
                this.BoardTiles[q].IsReplacement = (o.Replacement == "1") ? true : false;
            }

            var b = this.GetBonusTileById(q);
            if (b) {
                if (b.S == "L") {
                    this.BoardTiles[q].LetterMultiplier = parseInt(b.M);
                }
                else {
                    this.BoardTiles[q].WordMultiplier = parseInt(b.M);
                }
            }
            var s = this.GetStarterTileById(q);
            if (s) {
                this.BoardTiles[q].IsStarterTile = true;
                this.StarterTiles.push(this.BoardTiles[q]);
            }
            if (this.BoardTiles[q].Letter.length > 0) {
                this.PlayedTiles.push(this.BoardTiles[q]);
            }
            q++;

            //check for bonus tiles
        }
    }
}

Riot.Game.prototype.SaveState = function () {
    var state = "";

    //tray state
    var tray = "";
    $(this.TrayTiles).each(function (index, value) {
        tray += "{V:'" + value.Letter + "'},";
    });
    state = state + "Tray:[" + tray.slice(0, -1) + "],";

    //board state
    this.LoadPlacedTiles();
    var tiles = "";
    if (this.PlacedTiles.length > 0) {
        $(this.PlacedTiles).each(function (index, value) {
            tiles += "{I:'" + value.Id + "',V:'" + value.PlacedLetter + "'},";
        });
        tiles = tiles.slice(0, -1);
    }
    state = state + "Placed:[" + tiles + "]";
    Riot.Utils.SetStorageItem(this.StateKey, "{" + state + "}");
}

//Riot.Game.prototype.StoreTrayState = function () {
//    var tiles = "";
//    $(this.TrayTiles).each(function (index, value) {
//        tiles += value.Letter + ".";
//    });
//    Riot.Utils.SetStorageItem(this.TrayStateKey, tiles.slice(0, -1));
//}

//Riot.Game.prototype.StoreBoardState = function () {
//    this.LoadPlacedTiles();
//    var tiles = "";

//    //save state in json
//    $(this.PlacedTiles).each(function (index, value) {
//        tiles += "{ Id: " + value.Id + ", Value: '" + value.PlacedLetter + "'},";
//    });
//    Riot.Utils.SetStorageItem(this.BoardStateKey, "[" + tiles.slice(0, -1) + "]");
//}
Riot.Game.prototype.AutoShuffle = function () {
    //  debugger;
    if (this.autoShuffle == true) {
        if (this.autoShuffleCount < 30) {
            this.autoShuffleCount += 1;
            this.Shuffle();
        }
        //turn it off after it reaches 30 shuffles, just so it does not spin out of control
        else {
            self.autoShuffle = false;
            try { this.asInterval = clearInterval(this.asInterval); } catch (e) { }
        }
    }
    else {
        try { this.asInterval = clearInterval(this.asInterval); } catch (e) { }
    }


}

Riot.Game.prototype.Shuffle = function () {
    //push blank tiles to the end????
    $.shuffle(this.TrayTiles);
   // this.ClearTrayTileClickContext();
    for (i = 0; i <= this.Context.TrayTiles.length - 1; i++) {
        this.TrayTiles[i].Id = i + 1;
        this.TrayTiles[i].Position = i + 1;
    }

    $('#divTray').empty();
    this.LoadTray();
}

Riot.Game.prototype.RecallTrayTiles = function () {
    this.LoadPlacedTiles();
    $("#sbCalc").text("0");

    var numEmptyTrayTilesReplaced = 0;
    if (this.PlacedTiles.length > 0) {
        //  this.LoadState();

        //this.ClearTrayTileClickContext();
        for (i = 0; i <= this.PlacedTiles.length - 1; i++) {

            // and fill empty state with placed tiles
            //            for (j = 0; j <= this.State.Tray.length - 1; j++) {
            //                //using numEmptyTrayTilesReplaced < this.PlacedTiles.length to make sure that empty tray tiles that are supposed to be empty, stay empty
            //                if (this.State.Tray[j].V == "" && numEmptyTrayTilesReplaced < this.PlacedTiles.length) {
            //                    this.State.Tray[j].V = this.PlacedTiles[i].PlacedLetter;
            //                    numEmptyTrayTilesReplaced += 1;
            //                    break;
            //                }
            //            }
            this.PlacedTiles[i].RemovePlacedTile();
            this.SetBoardTile(this.PlacedTiles[i]);
        }
        // this.State.Placed = new Array();

        this.LoadTrayTiles();
        $('#divTray').empty();
        this.LoadTray();
    }
    this.SetPlayBtn();
    this.ResetState = true;
}

Riot.Game.prototype.LoadTrayTiles = function (s) {
    this.TrayTiles = new Array();
    var trayTileSource = new Array();

    var store = null;
    if (this.State != null) { store = this.State.Tray };
    if (arguments[0] && arguments[0] == true && store != null && store.length > 0) {
        for (i = 0; i <= store.length - 1; i++) {
            trayTileSource[i] = store[i].V;
        }
    }
    else {
        for (i = 0; i <= this.Context.TrayTiles.length - 1; i++) {
            trayTileSource[i] = this.Context.TrayTiles[i].L;
        }
    }
    for (i = 0; i <= trayTileSource.length - 1; i++) {

        this.TrayTiles[i] = new Riot.TrayTile();
        this.TrayTiles[i].Position = i + 1;
        this.TrayTiles[i].Id = i + 1;

        var letter = trayTileSource[i];
        if (letter.length > 0) {
            this.TrayTiles[i].Letter = letter;
        }
    }
}

Riot.Game.prototype.GetTrayTileByDivId = function (id) {
    var tileId = id.replace(this.TileTrayIdPrefix , "");
    return this.GetTrayTileById(tileId)
}

Riot.Game.prototype.GetTrayTileById = function (id) {
    var oTile;
    $(this.TrayTiles).each(function (index, value) {
        if (value.Id == id) {
            oTile = value;
            return false;
        }
    });

    return oTile;
}

Riot.Game.prototype.GetBoardTileById = function (id) {
    return this.BoardTiles[id];
}

Riot.Game.prototype.GetBonusTileById = function (id) {
    var oTile;
    $(Riot.Layout.BonusTiles).each(function (index, value) {
        if (parseInt(value.Id) == id) {
            oTile = value;
            return false;
        }
    });

    return oTile;
}

Riot.Game.prototype.GetStarterTileById = function (id) {
    var oTile;
    $(Riot.Layout.StarterTiles).each(function (index, value) {
        if (parseInt(value.Id) == id) {
            oTile = value;
            return false;
        }
    });

    return oTile;
}

Riot.Game.prototype.GetBoardTileByDivId = function (id) {
    var tileId = id.replace(this.TileDivIdPrefix, "");
    return this.GetBoardTileById(tileId)
}

Riot.Game.prototype.GetBoardTileByPos = function (r, c) {
    var oTile;
    $(this.BoardTiles).each(function (index, value) {
        if (value.Row == r && value.Column == c) {
            oTile = value;
            return false;
        }
    });

    return oTile;
}

Riot.Game.prototype.GetBoardTileByCoordinates = function (x, y) {
    var tile;
    var boardTop = $('#divBoard').offset().top;
    var boardLeft = $('#divBoard').offset().left;

    $(this.BoardTiles).each(function (index, value) {
        var t = boardTop + ((value.Row - 1) * 31);
        var l = boardLeft + ((value.Column - 1) * 31);
        ////subtract half the width and height of the dragged clone
        //to get to the center of the dragged div since the browser's pageX and pageY are
        //the lower right hand corner
        if (t <= y &&
            t + 31 >= y &&
            l <= x &&
            l + 31 >= x) {
            tile = value;
            return false;
        }
    });

    return tile;
}

Riot.Game.prototype.GetTrayTileByCoordinates = function (x, y, id) {
    var tile;

    for (i = 1; i <= 7; i++) {
        if ('tt_' + i != id) { ///figure out if its being dropped on itself
            var t = $('#ttbk_' + i).offset().top;
            var l = $('#ttbk_' + i).offset().left;

            if (t <= y &&
            t + 42 >= y &&
            l <= x &&
            l + 42 >= x) {
                tile = this.GetTrayTileByDivId("tt_" + i);
                break;
            }
        }
    }

    return tile;
}

Riot.Game.prototype.GetPlayedTile = function (t) {
    var o = new Object();
    o.Letter = "";
    o.LastPlay = false;
    o.Replacement = false;

    $(this.Context.PT).each(function (index, value) {
        if (value.Id == t) {
            o.Letter = value.L;
            if (value.LP && value.LP == true) { o.LastPlay = true; }
            if (value.R && value.R == true) { o.Replacement = true; }
            //sLetter = value.Letter;
            return false;
        }
    });

    return o;
}


//change tiles with letters to a separate class that does not allow drops (if NumReplacementLeft == 0)
Riot.Game.prototype.LoadBoard = function (zoom) {
    $('#divBoard').empty();

    for (i = 0; i <= this.Rows; i++) {
        var row = $('<div></div>');
        row.id = this.TileRowIdPrefix + (i + 1);
        $(row).addClass(this.TileRowClass)

        for (j = 0; j <= this.Cols; j++) {

            var tile = this.GetBoardTileByPos(i + 1, j + 1);
            var t = $('<div></div>');

            //add divs here and class in Render method, call render from here
            //all classes should be overrides

            //   tile.id = Riot.Constants.TileDivIdPrefix + oTile.Id;
            t.attr('id', this.TileDivIdPrefix + tile.Id);

            var v = $('<div></div>')
            v.attr('id', this.TileDivValueIdPrefix + tile.Id);

            var c = $('<div></div>')
            c.attr('id', this.TileDivCornerIdPrefix + tile.Id);

            var l = $('<div></div>')//.text(letter);
            l.attr('id', this.TileDivLetterIdPrefix + tile.Id);

            t.append(v);
            t.append(c);
            t.append(l);
            row.append(t);

            tile.Element = t;
            tile.ValueElement = v;
            tile.LetterElement = l;
            tile.CornerElement = c;

            this.SetBoardTile(tile);
            //check for bonus tiles
        }
        $('#divBoard').append(row);
    }
}


Riot.Game.prototype.LoadTray = function () {
    $('#divTray').empty();

    for (i = 0; i <= 6; i++) {

        var t = $('<div></div>');
        t.attr('id', "tt_" + (i + 1)).addClass("tt");

        var letter = this.TrayTiles[i].Letter;

        var v = $('<div></div>');
        v.attr('id', "ttv_" + (i + 1)).addClass("ttv").text(this.GetLetterValue(letter));

        //t.append(v);
        var l = $('<div></div>');
        l.attr('id', "ttl_" + (i + 1)).addClass("ttl").text(letter);

        if (letter.length == 0) {
            t.addClass("tt_e");
            v.addClass("ttv_e");
            l.addClass("ttl_e");
            //t.addClass(this.TrayTileNoDragClass);
        }
        else {
            this.SetTrayTileDraggable(t);
        }

        t.css("left", (i * 44) + "px").css('top', '0px');

        t.append(v);
        t.append(l);
       // this.SetTrayTileDraggable(t);

        //empty tile behind the tray tile
        var b = $("<div></div>").attr('id', "ttbk_" + (i + 1)).addClass("tt tt_e").css('left', (i * 44) + "px").css('top', '0px');

        $('#divTray').append(t).append(b);
    }

    this.ResetState = true;

    //    if (this.Context.active == true) {
    //        this.TrayEventSetUp();
    //    }

}

Riot.Game.prototype.SetBoardTileDraggable = function (el) {
    var self = this;
    el.on('touchstart', function (e) {
        //  debugger;
        if (self.touchActive.length > 0) { return false; }

        if (e.touches.length == 1) {
            self.DragOffsetX = (window.outerWidth - this.offsetWidth) / 2;
            self.DragOffsetY = (window.outerHeight - this.offsetHeight) / 2;
            self.DragStartX = e.targetTouches[0].pageX - self.DragOffsetX;
            self.DragStartY = e.targetTouches[0].pageY - self.DragOffsetY;
            e.stopPropagation();
            var id = this.id;
            var tile = self.GetBoardTileByDivId(this.id);
            var letter = tile.PlacedLetter;
            // $(this).addClass('t_d'); //use right css class here
            // $(this).hide();

            var left = 0, top = 0, obj = this;
            do {
                left += obj.offsetLeft;
                top += obj.offsetTop;
            } while (obj = obj.offsetParent);

            //var clone = $(this).clone(true);
            //clone.attr("id", id + "_clone").addClass('t_d').css('left', (left - 5) + 'px').css('top', (top - 5) + 'px');
            var clone = $("<div></div>").attr('letter', letter).attr("id", id + "_clone").addClass("tt tt_d").css('left', (left - 5) + 'px').css('top', (top - 5) + 'px');
            var v = $('<div></div>').addClass("ttv ttv_d").text(self.GetLetterValue(letter));
            var l = $('<div></div>').addClass("ttl ttl_d").text(letter);
            clone.append(v).append(l);

            $('#_body').append(clone);

            //  self.touchActive = clone.attr("id");
            self.dragClone = clone;
            self.dragTile = tile;

            $(document).on('touchmove', function (e) {
                //set this one the document so that on ipad it "sees" the clone as the new element being dragged,
                //else the clone will not drag unless the finger is lifted and reapplied
                //   debugger;
                // if (self.touchActive != this.id) { return false; }
                if (e && e.touches && e.touches.length == 1) { // Only deal with one finger
                    var diffX = (e.changedTouches[0].pageX - self.DragOffsetX) - self.DragStartX;
                    var diffY = (e.changedTouches[0].pageY - self.DragOffsetY) - self.DragStartY;
                    // this.style.webkitTransform = "translate3d(" + diffX + "px," + diffY + "px,0)";
                    self.dragClone.css("-webkit-transform", "translate3d(" + diffX + "px," + diffY + "px,0)");
                }
            });

            $(document).on('touchend', function (e) {
                //set this one the document so that on ipad it "sees" the clone as the new element being dragged,
                //else the clone will not drag unless the finger is lifted and reapplied
                debugger;
                self.touchActive = '';
                var letter = self.dragClone.attr('letter');
                var t = self.GetBoardTileByCoordinates(e.changedTouches[0].pageX, e.changedTouches[0].pageY);
                var tt;
                if (!t) { tt = self.GetTrayTileByCoordinates(e.changedTouches[0].pageX, e.changedTouches[0].pageY); }

                var id = self.dragClone.attr('id');
                if ((!t || !t.IsPlacementAllowed) && !tt) { //or t not a drop target
                    //revert
                    var options = {
                        x: 0, //x axis move. this can be a number (40), percent (50%), or pixels (40px) - if it's a number, px is added to it.
                        y: 0,
                        time: '300ms',
                        callback: function () {
                            self.TileRevertHandler(self.dragTile, letter);
                            // $("#" + id).removeClass('tt_d').css("-webkit-transform", "translate3d(0,0,0)").css("-webkit-transition-property", "none")
                            self.dragClone.remove();
                        }
                    }
                    self.dragClone.css3Animate(options);

//                    $("#sliding").css("-webkit-transform: none");
//                                        setTimeout(
//                      $("#sliding").css("-webkit-transform", "translate3d(0,0,0)")
//                    , 0);
                }
                else if (t) {
                    //drop handler
                    self.TileDropHandler(t, '', letter);
                    self.dragClone.remove();
                }
                else if (tt) {
                    //drop handler
                    //alert("dropped on tray");
                    self.TrayTileDropHandler(id, tt, letter);
                    self.dragClone.remove();
                }

                $(document).off('touchmove');
                $(document).off('touchend');

            });

            self.touchActive = clone.attr("id");
            var tile = self.GetBoardTileByDivId(id);
            self.LetterInDragContext = tile.PlacedLetter;

            tile.RemovePlacedTile();
            self.SetBoardTile(tile, true);

        }
    });
}

Riot.Game.prototype.SetTrayTileDraggable = function (el) {
    var self = this;
    el.on('touchstart', function (e) {
       // debugger;
        if (self.touchActive.length > 0) { return false; }
        self.touchActive = this.id;
        //debugger;
        if (e.touches.length == 1) {
            self.DragOffsetX = (window.outerWidth - this.offsetWidth) / 2;
            self.DragOffsetY = (window.outerHeight - this.offsetHeight) / 2;
            self.DragStartX = e.targetTouches[0].pageX - self.DragOffsetX;
            self.DragStartY = e.targetTouches[0].pageY - self.DragOffsetY;
            $(this).addClass('tt_d');
        }
    });
    el.on('touchend', function (e) {
        //if (e.touches.length == 0) { ///last finger has left the building
        debugger;
        self.touchActive = '';
        var t = self.GetBoardTileByCoordinates(e.changedTouches[0].pageX, e.changedTouches[0].pageY);
        var tt;
        if (!t) { tt = self.GetTrayTileByCoordinates(e.changedTouches[0].pageX, e.changedTouches[0].pageY); }
        //var self = this;
        var id = this.id;
        if ((!t || !t.IsPlacementAllowed) && !tt) { //or t not a drop target
            //revert
            var options = {
                x: 0, //x axis move. this can be a number (40), percent (50%), or pixels (40px) - if it's a number, px is added to it.
                y: 0,
                time: '300ms',
                callback: function () { $("#" + id).removeClass('tt_d').css("-webkit-transform", "translate3d(0,0,0)").css("-webkit-transition-property", "none") }
            }

            //callback function to reset tiles---not needed
            $(this).css3Animate(options);

        }
        else if (t) {
            self.TileDropHandler(t, id);
        }
        else if (tt) {
            self.TrayTileDropHandler(id, tt);
        }
    });
    el.on('touchmove', function (e) {
        if (self.touchActive != this.id) { return false; }
        if (e.touches.length == 1) { // Only deal with one finger
            // var touch = e.touches[0]; // Get the information for finger #1
            //  debugger;
            var diffX = (e.changedTouches[0].pageX - self.DragOffsetX) - self.DragStartX;
            var diffY = (e.changedTouches[0].pageY - self.DragOffsetY) - self.DragStartY;
            this.style.webkitTransform = "translate3d(" + diffX + "px," + diffY + "px,0)";
            // this.style.webkitTransform = "scale3d(1.3, 1.3, 0)";
            // this.css("-webkit-transform", "translate3d(" + diffX + "px, 0, 0)");
        }
    });
}

Riot.Game.prototype.SetBoardTile = function (tile, bypassDropHander) {
    var t = tile.GetElement();
    var v = tile.GetValueElement();
    var l = tile.GetLetterElement();
    var c = tile.GetCornerElement();

    var letter = tile.Letter;
    if (tile.PlacedLetter.length > 0) { letter = tile.PlacedLetter; }

    if (letter.length > 0) {
        v.text(this.GetLetterValue(letter));
        l.text(letter);
    }

    //    var bDropSet = false;
    //    if (tile.IsPlacementAllowed(parseInt(this.Context.pLeft)) == true) {
    //        if (!bypassDropHander || bypassDropHander == false) {
    //            bDropSet = true;
    //            this.SetTileDropEventHandler(tile);
    //        }
    //    }

    //    if (bDropSet == false) {
    //        this.RemoveTileDropEventHandler(tile);
    //    }

    if ((tile.LetterMultiplier == 1 && tile.WordMultiplier == 1) || letter.length == 0) {
        if (c.hasClass('h') == false) { c.addClass('h'); } //hide
    }
    else if (tile.LetterMultiplier > 1) {
        c.removeClass('h');
        // this.AddTileCornerClass(c, "");
        c.addClass("tc");
        // this.AddTileCornerClass(c, tile.LetterMultiplier + "l");
        c.addClass("tc_" + tile.LetterMultiplier + "l");
    }
    else if (tile.WordMultiplier > 1) {
        c.removeClass('h');
        //this.AddTileCornerClass(c, "");
        c.addClass("tc");
        //this.AddTileCornerClass(c, tile.WordMultiplier + "w");
        c.addClass("tc_" + tile.WordMultiplier + "w");

    }

    //determine state of the tile to assign proper class

    ///probably set these up with clones and add entire board at end

    //assign base class, event handlers are based on this class (at container level)
    this.AddTileClass(t, v, l, "");

    //add override for empty tile, remove placement if needed
    if (letter.length == 0) {
        this.RemoveTileClass(t, v, l, "pl"); //placed
        this.RemoveTileClass(t, v, l, "op"); //oplaced

        if (tile.LetterMultiplier > 1) {
            this.AddTileClass(t, v, l, tile.LetterMultiplier + "l");
            l.text(tile.LetterMultiplier + "L"); //get this from resources
            l.addClass("tbs");
        }
        else if (tile.WordMultiplier > 1) {
            this.AddTileClass(t, v, l, tile.WordMultiplier + "w");
            l.text(tile.WordMultiplier + "W"); //get this from resources
            l.addClass("tbs");
        }
        else if (tile.IsStarterTile == true) {
            this.AddTileClass(t, v, l, "s"); //start
        }
        else {
            this.AddTileClass(t, v, l, "e"); //empty
        }
    }
    //add override for currently placed, remove any other overrides
    else if (tile.IsPlacement == true) {
        if (tile.IsPlayed() == true) {
            this.AddTileClass(t, v, l, "op"); //oplaced
        }
        else {
            this.AddTileClass(t, v, l, "pl"); //placed
        }

        this.RemoveTileClass(t, v, l, "e"); //empty

        if (tile.IsReplacement == true) {
            this.RemoveTileClass(t, v, l, "r"); //replacement
        }
        if (tile.LastPlayed == true) {
            this.RemoveTileClass(t, v, l, "lp"); //lastplayed
        }
        if (tile.LetterMultiplier > 1) {
            this.RemoveTileClass(t, v, l, tile.LetterMultiplier + "l");
            l.removeClass("tbs");
        }
        else if (tile.WordMultiplier > 1) {
            this.RemoveTileClass(t, v, l, tile.WordMultiplier + "w");
            l.removeClass("tbs");
        }
        else if (tile.IsStarterTile == true) {
            this.RemoveTileClass(t, v, l, "s"); //start
        }


        // this.SetTileDragEventHandler(tile);
    }
    //add override for last played replacement, remove any other overrides
    else if (tile.IsReplacement == true) {
        this.AddTileClass(t, v, l, "r"); //replacement
        this.RemoveTileClass(t, v, l, "pl"); //placed
        this.RemoveTileClass(t, v, l, "op"); //oplaced
    }
    //add override for last played, remove any other overrides
    else if (tile.IsLastPlayed == true) {
        this.AddTileClass(t, v, l, "lp"); //lastplayed
        this.RemoveTileClass(t, v, l, "pl"); //placed
        this.RemoveTileClass(t, v, l, "op"); //oplaced
    }
    else {
        this.AddTileClass(t, v, l, "p"); //played
        this.RemoveTileClass(t, v, l, "pl"); //placed
        this.RemoveTileClass(t, v, l, "op"); //oplaced
    }

    if (tile.PlacedLetter.length > 0) {
        this.SetBoardTileDraggable(t);
    }
}

//Riot.Game.prototype.AddTileCornerClass = function (cr, cl) {
//    //return; //these evals will break in compiled mode
////    var p = "this.Tile";
////    var c = "Class";
////    var c_cr = eval(p + "Corner" + cl + c)

//    cr.addClass("tc_" +c );
//}

Riot.Game.prototype.AddTileClass = function (t, v, l, c) {
    //    debugger;
    
//    var p = "this.Tile";
//    var c = "Class";
//    var c_e = eval(p + cl + c)
//    var c_v = eval(p + "Value" + cl + c)
//    var c_l = eval(p + "Letter" + cl + c)
    var ca = (c.length > 0 ? "_" + c : "");
    t.addClass("t" + ca);  ///just add prefix and account for blank
    v.addClass("tv" + ca);
    l.addClass("tl" + ca);
}

Riot.Game.prototype.RemoveTileClass = function (t, v, l, c) {
//    var p = "this.Tile";
//    var c = "Class";

//    var c_e = eval(p + cl + c)
//    var c_v = eval(p + "Value" + cl + c)
//    var c_l = eval(p + "Letter" + cl + c)
    var ca = (c.length > 0 ? "_" + c : "");
    t.removeClass("t" + ca);
    v.removeClass("tv" + ca);
    l.removeClass("tl" + ca);
}

Riot.Game.prototype.SetTileDropEventHandler = function (tile) {
    var self = this;
//    if (tile.GetElement().hasClass('ui-droppable') == false) {
//        tile.GetElement().droppable({
//            accept: function (d) {
//                if (d.hasClass(this.TrayTileClass) || d.hasClass(this.TileClass)) {
//                    return true;
//                }
//            }, // hoverClass: 'riotTileZoomHover',  //put in constant
//            drop: function (event, ui) {
//                self.BoardDropHandler(event, ui);
//            }
//        });
//    }
}


Riot.Game.prototype.ShiftTrayTiles = function (targetTile, sourceTile) {
    var j = 1;
    var loopLetter = sourceTile.Letter;
    if (targetTile.Id > sourceTile.Id) { j = -1; }

    var i = targetTile.Id - 1;
    var loopRun = true;
    while (loopRun == true) {
        var letter = this.TrayTiles[i].Letter;
        this.TrayTiles[i].Letter = loopLetter;
        loopLetter = letter;

        if (i == sourceTile.Id - 1) { loopRun = false; }
        i = i + (1 * j);
    }
}

Riot.Game.prototype.ShiftTrayTilesToNearestEmpty = function (trayTile) {
    var j = 1, direction = 0;
    var loopLetter = trayTile.PreviousLetter;
    trayTile.PreviousLetter = "";

    //look to the left first, then look to the right
    //find empty tiles and determine direction of replacement flow
    $(this.TrayTiles).each(function (index, value) {
        if (value.Id != trayTile.Id && value.Letter == "" && direction == 0) {
            if (value.Id < trayTile.Id) { direction = -1; } else { direction = 1; }
        }
    });

    //multiplying by direction will send the loop into the proper direction
    j = j * direction;

    var i = (trayTile.Id - 1) + (1 * direction);
    var loopRun = true;
    while (loopRun == true) {
        var letter = this.TrayTiles[i].Letter;
        this.TrayTiles[i].Letter = loopLetter;
        loopLetter = letter;

        //stop at first formerly empty tile 
        if (letter == "") { loopRun = false; }
        i = i + (1 * j);
    }
}
Riot.Game.prototype.TrayTileDropHandler = function (dragId, targetTile, letter) {
    var dragTile;

    if (dragId.indexOf(this.TileTrayIdPrefix) > -1) {
        dragTile = this.GetTrayTileByDivId(dragId);
        if (targetTile.Id == dragTile.Id) {
            //reload tray with no changes
        }
        else if (targetTile.Letter == "") {
            targetTile.Letter = dragTile.Letter;
            dragTile.Letter = "";
        }
        else {
            this.ShiftTrayTiles(targetTile, dragTile);
        }
        this.LoadTray();
    }
    else {
        dragTile = this.GetBoardTileByDivId(dragId.replace("_clone", ""));
        if (targetTile.Letter == "") {
            targetTile.Letter = letter;
        }
        else {
            //modified shift, move existing tile to closest empty space 
            targetTile.PreviousLetter = targetTile.Letter;
            targetTile.Letter = letter;
            this.ShiftTrayTilesToNearestEmpty(targetTile);
        }
        $(dragTile.GetElement()).off('touchstart');
        this.LoadTray(true);
    }

    this.ResetState = true;
    this.SetPlayBtn();
    this.CalcOnFly();
}


Riot.Game.prototype.TileDropHandler = function (tile, trayTileId, letter) {
    if (arguments[1].length > 0) {
        var trayTile = this.GetTrayTileByDivId(trayTileId);
        debugger;
        letter = trayTile.Letter;
        trayTile.Letter = "";
        this.LoadTray(false);
    }

    tile.SetPlacedTile(letter);
    this.SetBoardTile(tile);

    this.ResetState = true;
    this.SetPlayBtn();
    this.CalcOnFly();
}

Riot.Game.prototype.TileRevertHandler = function (tile, letter) {
    debugger;
    tile.SetPlacedTile(letter);
    this.SetBoardTile(tile);

    this.ResetState = true;
    this.SetPlayBtn();
  //  this.CalcOnFly();
}

Riot.Game.prototype.BoardDropHandler = function (event, ui) {
    // this.Log("BoardDropHandler.event.target.id " + event.target.id);
    var tileId = event.target.id;
    //debugger;
    var tile = this.GetBoardTileByDivId(tileId);



    var dragId = $(ui.draggable).attr("id");

    //tray tiles and other board tiles can be dropped on the board.   
    if (dragId.indexOf(this.TileTrayIdPrefix ) > -1) {
        var trayTile = this.GetTrayTileByDivId(dragId);
        var letter = trayTile.Letter;
        trayTile.Letter = "";

        if (tile.IsPlacementAllowed() == true) {
            this.LoadTray(false);
        }
    }
    else {
        letter = this.LetterInDragContext;
        this.RemoveBoardTileDrag = true;
    }
    tile.SetPlacedTile(letter);
    this.SetBoardTile(tile);
    this.LetterInDragContext = "";

    this.ResetState = true;
    this.SetPlayBtn();
    this.CalcOnFly();

}

Riot.Game.prototype.TurnEventSetUp = function () {
    //   $(document).ajaxStop($.unblockUI);

 //   return;

    var d = this.GameBtnDisabledClass;
    var self = this;

    //    if (this.Context.sb.wd > 0) {
    //        $('#btnWList').click(function () {
    //            self.SubmitWords();
    //            //location.href = "/facebook/canvas/listwords?gameId=" + self.Context.g;
    //        });
    //    }
    //    else {
    //        $('#btnWList').unbind('click');
    //    }

    $('#btnRematch').unbind('touchstart');

    //    $("#cAccordion").accordion({
    //        event: "click",
    //        fillSpace: true
    //    });

    //    $("#chT").keyup(function (e) {
    //        var code = (e.keyCode ? e.keyCode : e.which);
    //        if (code == 13) {
    //            self.SubmitChatter($(this).val());
    //        }
    //    });

    //    $("#chB").click(function () {
    //        self.SubmitChatter($("#chT").val());
    //    });

    this.ChatterEventSetUp();

    if (this.Context.active == true) {

        $("#divTurnControls").show();
        $("#divRematch").hide();
        $("#btnShuffle").on("touchstart", function (e) {
            //turn off autoshuffle
            // debugger;
            if (self.autoShuffle == true) {
                self.autoShuffle = false;
                try { this.asInterval = clearInterval(this.asInterval); } catch (e) { }
            }
            else if (e.shiftKey) {
                self.autoShuffleCount = 0;
                self.autoShuffle = true;
                self.Shuffle();
                self.asInterval = setInterval(function () {
                    self.AutoShuffle();
                }, 1300);
            }
            else {
                self.Shuffle();
            }
        })
        $("#btnRecall").on("touchstart", function () {

            self.RecallTrayTiles();
        })

        if (this.Context.sb.pTurn == 1) {
            if (this.Context.tn == "1") {
                $("#btn5").on("touchstart", function () {
                    self.Cancel();
                });
                $("#btn5").text(Riot.Resource.CancelTurn).attr('title', $.format(Riot.Resource.CancelTurnTitle, this.Context.sb.oFName));
            }
            if (this.Context.tn == "2") {
                $("#btn5").on("touchstart", function () {
                    self.Decline();
                });
                $("#btn5").text(Riot.Resource.DeclineTurn).attr('title', $.format(Riot.Resource.DeclineTurnTitle, this.Context.sb.oFName));
            }
            if (parseInt(this.Context.tn) > 2) {
                $("#btn5").on("touchstart", function () {
                    self.Concede();
                });
                $("#btn5").text(Riot.Resource.ConcedeTurn).attr('title', $.format(Riot.Resource.ConcedeTurnTitle, this.Context.sb.oFName));
            }
            if ($("#btn5").hasClass(d) == true) {
                $("#btn5").removeClass(d);
            }
            if (parseInt(this.Context.lLeft) > 0) {
                if ($("#btnSwap").hasClass(d) == true) {
                    $("#btnSwap").removeClass(d);
                }
                $("#btnSwap").attr('title', Riot.Resource.SwapTurnTitle);

                $("#btnSwap").on("touchstart", function () {
                    $.each($(".riotSwapTile"), function (index, value) {
                        $("#" + value.id).removeClass("riotSwapTileSelected");
                    });

                    $("#swap").dialog("open");
                });

                $(".riotSwapTile").on("touchstart", function () {
                    if ($(this).hasClass('riotSwapTileSelected') == false) {
                        $(this).addClass('riotSwapTileSelected');
                    }
                    else {
                        $(this).removeClass("riotSwapTileSelected");
                    }
                });
            }
            else {
                if ($("#btnSwap").hasClass(d) == false) {
                    $("#btnSwap").addClass(d);
                }
                $("#btnSwap").attr('title', Riot.Resource.SwapTurnHopperEmpty);

            }
            $("#btnPlay").on("touchstart", function () {
                self.Play();
            });
            if ($("#btnPlay").hasClass(d) == true) {
                $("#btnPlay").removeClass(d);
            }
        }
        else {
            $('#btn5').off('touchstart');
            if (this.Context.tn == "1") {
                $("#btn5").text(Riot.Resource.DeclineTurn).attr('title', $.format(Riot.Resource.DeclineTurnTitle, this.Context.sb.oFName) + Riot.Resource.NotTurnTitle);
            }
            else if (this.Context.tn == "0") {
                $("#btn5").text(Riot.Resource.CancelTurn).attr('title', $.format(Riot.Resource.CancelTurnTitle, this.Context.sb.oFName) + Riot.Resource.NotTurnTitle);
            }
            else {
                $("#btn5").text(Riot.Resource.ConcedeTurn).attr('title', $.format(Riot.Resource.ConcedeTurnTitle, this.Context.sb.oFName));
            }


            if ($("#btn5").hasClass(d) == false) {
                $("#btn5").addClass(d);
            }
            $("#btnSwap").attr('title', Riot.Resource.SwapTurnTitle + Riot.Resource.NotTurnTitle);
            $("#btnSwap").off('touchstart');
            if ($("#btnSwap").hasClass(d) == false) {
                $("#btnSwap").addClass(d);
            }
            $('#btnPlay').off('touchstart');
            $("#btnPlay").text(Riot.Resource.PlayTurn).attr('title', Riot.Resource.PlayTurnTitle + Riot.Resource.NotTurnTitle);
            $('#btnPlay').off('touchstart');
            if ($("#btnPlay").hasClass(d) == false) {
                $("#btnPlay").addClass(d);
            }
        }

    }
    else {
        $("#btnRematch").on("touchstart", function () {
            self.Rematch();
        });
        $("#btnRematch").text($.format(Riot.Resource.RematchTurn, this.Context.sb.oFName)).attr('title', $.format(Riot.Resource.RematchTurnTitle, this.Context.sb.oFName));
        $("#divTurnControls").hide();
        $("#divRematch").show();
        $('#btnRecall').off('touchstart');
        $('#btn5').off('touchstart');
        $('#btnSwap').off('touchstart');
        $('#btnShuffle').off('touchstart');
        $('#btnPlay').off('touchstart');
    }
}

Riot.Game.prototype.ChatterEventSetUp = function () {
    //check game status and completion date, etc
    var self = this;

    $("#chT").on("keyup", function (e) {
        var code = (e.keyCode ? e.keyCode : e.which);
        if (code == 13) {
            //            var t = $(this).val();
            //            $(this).val("");
            self.SubmitChatter();
        }
    });

    $("#chB").on("touchstart" ,function () {
        //        var t = $("#chT").val();
        //        $("#chT").val("");
        self.SubmitChatter();
    });
}

Riot.Game.prototype.GetPlacedAxis = function () {
    var i = 0, row, col, axis = "";
    if (this.PlacedTiles.length == 1) { return "x"; }
    $(this.PlacedTiles).each(function (index, value) {
        i += 1;

        if (i == 2) {
            if (value.Row != row && value.Column != col) { axis = ""; return; }
            axis = (value.Row == row) ? "x" : "y";
        }
        else if (i > 2) {
            if (axis == "x" && value.Row != row) { axis = ""; return; }
            if (axis == "y" && value.Column != col) { axis = ""; return; }
        }
        else {
            row = value.Row;
            col = value.Column;
        }

    });
    return axis;
}

Riot.Game.prototype.IsMoveInValidStartPosition = function () {
    //if TurnNum=1, must cross a starter tile
    var valid = false;
    if (this.Context.tn == "1") {
        for (i = 0; i < this.PlacedTiles.length; i++) {
            for (j = 0; j < this.StarterTiles.length; j++) {
                if (this.PlacedTiles[i].Id == this.StarterTiles[j].Id) {
                    valid = true;
                }
            }
        }
    }
    else { valid = true; }
    return valid;
}

Riot.Game.prototype.IsMovePositionedNextToPlayedTile = function () {
    //one can start via replacement as well
    //if TurnNum>1, must share a side with a played tile

    var valid = false;

    if (parseInt(this.Context.tn) > 1) {
        var played = this.PlayedTiles;
        if (played.length == 0) {
            valid = true
        }
        else {
            var placed = this.PlacedTiles;
            //loop through all placed letters  
            //and make sure that if this is any turn from #2 on, that the letters touch and existing played tile (or veil over played tile)
            for (i = 0; i < placed.length; i++) {
                if (placed[i].IsReplacement == false) { }
                for (j = 0; j < played.length; j++) {
                    if ((placed[i].Row == played[j].Row - 1) && (placed[i].Column == played[j].Column)) {
                        valid = true;
                    }
                    if ((placed[i].Row == played[j].Row + 1) && (placed[i].Column == played[j].Column)) {
                        valid = true;
                    }
                    if ((placed[i].Column == played[j].Column + 1) && (placed[i].Row == played[j].Row)) {
                        valid = true;
                    }
                    if ((placed[i].Column == played[j].Column - 1) && (placed[i].Row == played[j].Row)) {
                        valid = true;
                    }
                }
            }
        }
    }
    else
    { valid = true; }

    return valid;
}

Riot.Game.prototype.IsGapOK = function (axis) {
    var placed = this.PlacedTiles;
    var played = this.PlayedTiles;

    if (placed.length == 1) { return true; }

    //if direction is horizontal, add 1 until we get to the last placed letter
    //if direction is vertical, add 15 until we get to the last placed letter
    //start at first and loop until the last...not looping each one because a previously played tile
    //might be in between
    var i = (axis == "x" ? 1 : 15);
    var x = placed[0].Id;
    while (x < placed[placed.length - 1].Id) {
        if (this.BoardTiles[x + i].IsPlacement == false && this.BoardTiles[x + i].IsPlayed() == false) {
            return false;
        }
        x += i;
    }

    return true;
}

Riot.Game.prototype.LoadPlacedWords = function (placedAxis) {
    var played = this.PlayedTiles;
    var placed = this.PlacedTiles;

    this.CalculatedValue = 0;
    var calc = 0;
    var loopWordMult = 1;
    var wordValue = 0;

    //first mark all PlacedTiles as disconneced.  this will allow us to to
    //determine if there are any gaps in the letters after this function runs
    for (i = 0; i < placed.length; i++) {
        placed[i].IsConnected = false;
    }


    var valid = false;
    //    debugger;

    this.PlacedWords = new Array();

    var words = new Array(), word = "", loopTile;

    //start at first played letter and go down main axis, left first, then right,
    //then search out words in each played letter on opposite axis
    var word = placed[0].PlacedLetter;
    loopTile = placed[0];

    //first tile is always connected (gap-free), since we have already passed invalid placement, invalid axis, etc tests.
    placed[0].IsConnected = true;

    //calculate the value on the fly for the first letter
    wordValue += parseInt(this.GetLetterValue(placed[0].PlacedLetter)) * parseInt(placed[0].PlacedLetterMultiplier());
    loopWordMult = parseInt(loopWordMult) * parseInt(placed[0].PlacedWordMultiplier());

    //look horizontally or vertically, depending on playedAxis
    //first go backward
    var loop = true;
    while (loop == true) {
        var tile = this.GetBoardTileByPos((placedAxis == "x") ? loopTile.Row : loopTile.Row - 1, (placedAxis == "x") ? loopTile.Column - 1 : loopTile.Column);
        if (!tile || tile.GetWordLetter().length == 0) { loop = false; }
        else {
            word = tile.GetWordLetter() + word;
            loopTile = tile;
            //if this is a placed tile, mark it as connected
            if (tile.IsPlacement == true) { tile.IsConnected = true; }

            //calculate the value on the fly
            wordValue += parseInt(this.GetLetterValue(tile.GetWordLetter())) * parseInt(tile.PlacedLetterMultiplier());
            loopWordMult = parseInt(loopWordMult) * parseInt(tile.PlacedWordMultiplier());
        }
    }
    //then go forward
    loop = true;
    loopTile = placed[0];
    while (loop == true) {
        var tile = this.GetBoardTileByPos((placedAxis == "x") ? loopTile.Row : loopTile.Row + 1, (placedAxis == "x") ? loopTile.Column + 1 : loopTile.Column);
        if (!tile || tile.GetWordLetter().length == 0) { loop = false; }
        else {
            word = word + tile.GetWordLetter();
            loopTile = tile;
            //if this is a placed tile, mark it as connected
            if (tile.IsPlacement == true) { tile.IsConnected = true; }

            //calculate the value on the fly
            wordValue += parseInt(this.GetLetterValue(tile.GetWordLetter())) * parseInt(tile.PlacedLetterMultiplier());
            loopWordMult = parseInt(loopWordMult) * parseInt(tile.PlacedWordMultiplier());
        }
    }


    if (word.length > 1) {
        this.PlacedWords.push(word);

        //only calculate the value if the word is valid (longer than single letter)
        wordValue = wordValue * parseInt(loopWordMult);
        calc += wordValue;
    }

    wordValue = 0;
    loopWordMult = 1;


    //now let's wander down the main word looking at the opposite axis for every placed tile,
    //trying to find the rest of the played letters
    for (i = 0; i < placed.length; i++) {
        word = placed[i].PlacedLetter;
        loop = true;
        loopTile = placed[i];

        //calculate the value on the fly for the first letter
        wordValue += parseInt(this.GetLetterValue(placed[i].PlacedLetter)) * parseInt(placed[i].PlacedLetterMultiplier());
        loopWordMult = parseInt(loopWordMult) * parseInt(placed[i].PlacedWordMultiplier());

        //lets go backward first
        while (loop == true) {
            var tile = this.GetBoardTileByPos((placedAxis == "x") ? loopTile.Row - 1 : loopTile.Row, (placedAxis == "x") ? loopTile.Column : loopTile.Column - 1);
            if (!tile || tile.GetWordLetter().length == 0) { loop = false; }
            else {
                word = tile.GetWordLetter() + word;
                loopTile = tile;

                //calculate the value on the fly
                wordValue += parseInt(this.GetLetterValue(tile.GetWordLetter())) * parseInt(tile.PlacedLetterMultiplier());
                loopWordMult = parseInt(loopWordMult) * parseInt(tile.PlacedWordMultiplier());
            }
        }
        //then go forward
        loop = true;
        loopTile = placed[i];
        while (loop == true) {
            var tile = this.GetBoardTileByPos((placedAxis == "x") ? loopTile.Row + 1 : loopTile.Row, (placedAxis == "x") ? loopTile.Column : loopTile.Column + 1);
            if (!tile || tile.GetWordLetter().length == 0) { loop = false; }
            else {
                word = word + tile.GetWordLetter();
                loopTile = tile;

                //calculate the value on the fly
                wordValue += parseInt(this.GetLetterValue(tile.GetWordLetter())) * parseInt(tile.PlacedLetterMultiplier());
                loopWordMult = parseInt(loopWordMult) * parseInt(tile.PlacedWordMultiplier());
            }
        }

        if (word.length > 1) {
            this.PlacedWords.push(word);
            placed[i].IsConnected = true;

            wordValue = wordValue * parseInt(loopWordMult);
            calc += wordValue;
        }

        wordValue = 0;
        loopWordMult = 1;
    };

    this.CalculatedValue = calc;
}


Riot.Game.prototype.LoadPlacedTiles = function () {
    this.PlacedTiles = new Array();

    for (i = 0; i < this.BoardTiles.length; i++) {
        if (this.BoardTiles[i].IsPlacement == true) {
            this.PlacedTiles.push(this.BoardTiles[i]);
        }
    }
}

Riot.Game.prototype.CalcOnFly = function () {
    //debugger;
    var s = $("#sbCalc");
    this.LoadPlacedTiles();
    if (this.PlacedTiles.length == 0) {
        s.text("0");
        return;
    }

    if (this.Context.tn == 1 && this.PlacedTiles.length == 1) {
        s.text("0");
        return;
    }

    if (this.IsMoveInValidStartPosition() == false) {
        s.text("0");
        return;
    }

    var axis = this.GetPlacedAxis();
    if (axis == "") {
        s.text("0");
        return;
    }

    if (this.IsMovePositionedNextToPlayedTile() == false) {
        s.text("0");
        return;
    }
    if (this.IsGapOK(axis) == false) {
        s.text("0");
        return;
    }

    this.LoadPlacedWords(axis);

    if (this.PlacedTiles.length == 7) {
        var add = 40;
        for (i = 0; i < this.PlacedTiles.length; i++) {
            if (this.PlacedTiles[i].IsPlayed() == true) {
                add = 20;
            }
        }
        this.CalculatedValue += parseInt(add);
    }
    s.text(this.CalculatedValue);

}

Riot.Game.prototype.Play = function () {
    debugger; //
    this.LoadPlacedTiles();
    if (this.PlacedTiles.length == 0) {
        Riot.Hub.Popup(Riot.Resource.SkipTitle, Riot.Resource.SkipText, Riot.Resource.SkipBtn, function () { Riot.Hub.HidePopup(); self.SubmitSkip(); }, Riot.Resource.Cancel, function () { Riot.Hub.HidePopup(); });
        return;
    }

    //not correct
    if (this.Context.tn == 1 && this.PlacedTiles.length == 1) {
        Riot.Hub.Popup(Riot.Resource.InvalidCountTitle, Riot.Resource.InvalidCountText);
        return;
    }

    if (this.IsMoveInValidStartPosition() == false) {
        Riot.Hub.Popup(Riot.Resource.InvalidStartTitle, Riot.Resource.InvalidStartText);
        return;
    }

    var axis = this.GetPlacedAxis();
    if (axis == "") {
        Riot.Hub.Popup(Riot.Resource.InvalidAxisTitle, Riot.Resource.InvalidAxisText);
        return;
    }

    if (this.IsMovePositionedNextToPlayedTile() == false) {
        Riot.Hub.Popup(Riot.Resource.InvalidMoveTitle, Riot.Resource.InvalidMoveText);
        return;
    }
    if (this.IsGapOK(axis) == false) {
        Riot.Hub.Popup(Riot.Resource.InvalidGapTitle, Riot.Resource.InvalidGapText);
        return;
    }

    this.LoadPlacedWords(axis);  //kickout single letter words

    //check for gaps
    //    var hasGap = false;
    //    for (i = 0; i < this.PlacedTiles.length; i++) {
    //        if (this.PlacedTiles[i].IsConnected == false) { hasGap = true; }
    //    }
    //    if (hasGap == true) {
    //        this.Dialog(Riot.Resource.InvalidGapTitle, Riot.Resource.InvalidGapText);
    //        return;
    //    }

    var words = "";
    var self = this;
    for (i = 0; i < this.PlacedWords.length; i++) {
        words = words + $.format(Riot.Resource.ConfirmationWord, this.PlacedWords[i]);
    }

    Riot.Hub.Popup(Riot.Resource.ConfirmationTitle, $.format(Riot.Resource.ConfirmationText, words), Riot.Resource.PlayBtn, function () { Riot.Hub.HidePopup(); self.SubmitPlay(); }, Riot.Resource.Cancel, function () { Riot.Hub.HidePopup(); });
    //    this.Dialog(Riot.Resource.ConfirmationTitle, $.format(Riot.Resource.ConfirmationText, words), Riot.Resource.PlayBtn, function () { $(this).dialog("close"); self.SubmitPlay(); })
    return;
}

Riot.Game.prototype.Cancel = function () {
    var self = this;
    Riot.Hub.Popup(Riot.Resource.CancelTitle, Riot.Resource.CancelText, Riot.Resource.CancelBtn, function () { Riot.Hub.HidePopup(); self.SubmitCancel(); }, Riot.Resource.NoThanks, function () { Riot.Hub.HidePopup(); });
    // this.Dialog(Riot.Resource.CancelTitle, Riot.Resource.CancelText, Riot.Resource.CancelBtn, function () { $(this).dialog("close"); self.SubmitCancel(); }, Riot.Resource.NoThanks)
    return;
}

Riot.Game.prototype.Decline = function () {
    var self = this;
    Riot.Hub.Popup(Riot.Resource.DeclineTitle, Riot.Resource.DeclineText, Riot.Resource.DeclineBtn, function () { Riot.Hub.HidePopup(); self.SubmitDecline(); }, Riot.Resource.Cancel, function () { Riot.Hub.HidePopup(); });
    //  this.Dialog(Riot.Resource.DeclineTitle, Riot.Resource.DeclineText, Riot.Resource.DeclineBtn, function () { $(this).dialog("close"); self.SubmitDecline(); })
    return;
}

Riot.Game.prototype.Concede = function () {
    var self = this;
    Riot.Hub.Popup(Riot.Resource.ConcedeTitle, Riot.Resource.ConcedeText, Riot.Resource.ConcedeBtn, function () { Riot.Hub.HidePopup(); self.SubmitConcede(); }, Riot.Resource.Cancel, function () { Riot.Hub.HidePopup(); });
    //    this.Dialog(Riot.Resource.ConcedeTitle, Riot.Resource.ConcedeText, Riot.Resource.ConcedeBtn, function () { $(this).dialog("close"); self.SubmitConcede(); })
    return;
}

//Riot.Game.prototype.Dialog = function (title, txt, btnTxt, btnAction, btnCancelTxt, hideCancel, pos) {
//    var d = "#dialog";
//    var t = "#dialogText";
//    var c = Riot.Resource.Cancel;
//    if (arguments[4] && btnCancelTxt.length) { c = btnCancelTxt; }
//    $(t).html(txt);
//    var btns = new Object();
//    if (arguments[2] && btnTxt.length > 0) {
//        btns[btnTxt] = btnAction;
//        if (!arguments[5] && arguments[5] != true) { btns[c] = function () { $(this).dialog("close"); }; }
//    }
//    else {
//        btns[Riot.Resource.OK] = function () { $(this).dialog("close"); };
//    }
//    if (arguments[6] && pos.length > 0) {
//        $(d).dialog("option", "position", { of: pos });
//    }
//    else {
//        $(d).dialog("option", "position", { of: '#divBoard' });
//    }
//    $(d).dialog("option", "title", title);
//    $(d).dialog("option", "buttons", btns);
//    $(d).dialog("open");
//    $(d).dialog("option", "height", $(t).outerHeight() + 125);
//    //$(d).dialog("option", "height", "auto");
//    //    

//}

Riot.Game.prototype.SubmitPlay = function () {

    var data = new Object();
    var tiles = new Array();
    for (i = 0; i < this.PlacedTiles.length; i++) {
        var tile = new Object();
        tile["Id"] = this.PlacedTiles[i].Id;
        tile["Letter"] = this.PlacedTiles[i].PlacedLetter;
        tiles.push(tile);
    }
    data["Tiles"] = tiles;


    this.Post("play", data);
}

//FB.ui({
//    method: 'apprequests',
//    message: $.format(Riot.Resource.InviteText, self.fName),
//    to: $(this).attr("data-val"),
//    title: $.format(Riot.Resource.InviteTitle, $(this).attr("data-name").split(/\b/)[0])
//}, function (r) {
//    if (r) { self.SubmitInvite(r.request_ids[0]); }
//    else { $.unblockUI(); }
//});

Riot.Game.prototype.SubmitSkip = function () {
    this.Post("skip", new Object());
}

Riot.Game.prototype.SubmitCancel = function () {
    //  debugger;
    this.Post("cancel", new Object());
}

Riot.Game.prototype.SubmitDecline = function () {
    this.Post("decline", new Object());
}

Riot.Game.prototype.SubmitConcede = function () {
    this.Post("concede", new Object());
}

Riot.Game.prototype.SubmitWords = function () {
    if (this.Context.Words) {
        this.RenderWords();
    }
    else {
        this.Post("words", new Object(), true);
    }
}

Riot.Game.prototype.SubmitDefs = function (w) {
    var data = new Object();
    data["word"] = w;
    this.Post("definitions", data, true);
}

Riot.Game.prototype.SubmitChatter = function (t) {
    var t = $("#chT").val();
    $("#chT").focus().val("");
    setTimeout(function () {
        $("#chT").focus();
    }, 100);
    if (t && t.length > 0) {
        t = t.replace(/[^\w\s.%!$,€()'"? ;:-]/g, '');
        t = t.substr(0, 500);
        var data = {};
        data.Chatter = t;
        data.LatestDate = this.Context.lch;

        //just to make this chatter add immediately and not wait on ajax post
        //do this here, then do again after ajax post to catch any new chatter that might have
        //come in from the opponent
        var o = {};
        o.t = t;
        o.p = "1";
        this.Context.chI = "1";
        this.Context.ch.push(o);
        this.RenderChatter();
        this.ChatterEventSetUp();

        //change this to hub post
        this.Post("chatter", data, true);
    }
}


Riot.Game.prototype.SubmitSwap = function (l) {
    var data = new Object();
    data["Positions"] = l;
    this.Post("swap", data);
}

Riot.Game.prototype.Rematch = function (l) {
    var self = this, o = {};
    o.Id = this.Context.oId;
    this.Post("rematch", o, self.Go);
}

Riot.Game.prototype.CheckTurn = function () {
    var self = this, o = {};
    o.LatestDate = this.Context.lch;
    this.Post("TurnCheck", o, self.Go);
}

Riot.Game.prototype.CheckChatter = function () {
    var data = new Object();
    data["LatestDate"] = this.Context.lch;
    this.Post("ChatterCheck", data, true);
}

Riot.Game.prototype.GetGame = function (g) {
    var data = new Object();
    this.Context.g = g;
    this.Post("GetGame", data);
}

Riot.Game.prototype.Post = function (url, postData, bypassLoader) {
    postData["GameId"] = this.Context.g;
    if (this.Context.tn) { postData["Turn"] = this.Context.tn; }
    var self = this;

   // Riot.Hub.Post(url, postData, Riot.Hub.Game().Go);

//    //    $.blockUI();
//    //    $("#ajaxLoader").dialog("option", "position", { of: '#gameBg', at: 'center center' }); 
//    if (!arguments[2] || bypassLoader == false) { $("#ajaxLoader").dialog("open"); }

    $.ajax({
        url: url,
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify(postData),
        contentType: 'application/json; charset=utf-8',
        success: function (data) {
            self.Go(data);
        }
    });
}

Riot.Game.prototype.Go = function (data) {
    var self = this;

    //if ($("#ajaxLoader").dialog("isOpen")) { $("#ajaxLoader").dialog("close"); }
    if (data.ReturnCode == 4) {
        this.LoadGame(data);
    }
    else if (data.ReturnCode == 0) {
        if (data.Url.length > 0) { location.href = data.Url; }
    }
    else if (data.ReturnCode == 1) {
        this.Dialog(Riot.Resource.InvalidMoveTitle, data.Error);
    }
    else if (data.ReturnCode == 2) {
        return false;
    }
    else if (data.ReturnCode == 5 || data.ReturnCode == 7) {//chatter
        if (data.Context.ch) {
            this.Context.lch = data.Context.lch;
            this.Context.chAl = data.Context.chAl;
            if (data.Context.ch.length > 0) { //if ch is empty then we are done because we added the chatter msg before the ajax post
                if (data.ReturnCode == 5) { this.Context.ch.pop(); } //remove the last item which was added before the ajax post
                for (i = 0; i < data.Context.ch.length; i++) {
                    this.Context.ch.push(data.Context.ch[i]);
                }
                this.Context.chI = (this.Context.ch.length > 0 ? "1" : "0");
                this.RenderChatter();
                this.ChatterEventSetUp();
            }
        }
    }
    else if (data.ReturnCode == 6) {//chatter is not allowed for some reason, let's get rid of the msg added before the ajax post
        if (data.Context.ch) {
            this.Context.lch = data.Context.lch;
            this.Context.chAl = data.Context.chAl;
        }
        this.Context.ch.pop(); //remove the last item which was added before the ajax post       
        this.RenderChatter();
        this.ChatterEventSetUp();

        this.Dialog(Riot.Resource.InvalidChatterTitle, data.Error);
    }
    else if (data.ReturnCode == 8) {
        debugger;
        this.Context.Words = data.Context;
        this.RenderWords();
    }
    else if (data.ReturnCode == 9) {
        this.Context.Defs = data.Context;
        this.RenderDefs();
    }
    else if (data.ReturnCode == 10) {
        if (data.Context.al) {
            var al = $("<div></div>");
            for (i = 0; i < data.Context.al.length; i++) {
                al.html(al.html() + $.format(Riot.Resource.AlertLine, data.Context.al[i].tx));
            }
            this.Dialog(Riot.Resource.AlertTitle, al.html());
        }
        this.Page.SubmitStart();
    }
}

Riot.Game.prototype.LoadGame = function (data) {
    var self = this;
    this.Context = data.Context.game;
    this.SetMainTab("m-rt-gm");

    this.Init();
    //    debugger;
    //check for independent alerts... 
    var alerts = "";
    if (data.Context.al && data.Context.al.length > 0) {
        var alT = (data.Context.al.length == 1 ? data.Context.al[0].t : Riot.Resource.AlertTitle);
        var al = $("<div></div>");
        for (i = 0; i < data.Context.al.length; i++) {
            if (this.Context.pu && this.Context.pu == "1") {
                //add these alerts to the popup that will already happen
                al.html(al.html() + $.format(Riot.Resource.AlertTitleAndLine, data.Context.al[i].t, data.Context.al[i].tx));
            }
            else {
                al.html(al.html() + $.format(Riot.Resource.AlertLine, data.Context.al[i].tx));
            }
        }
        if (!this.Context.pu || this.Context.pu != "1") {
            this.Dialog(alT, al.html());
        }
        else {
            alerts = Riot.Resource.OtherAlertTitle + al.html()
        }
    }

    ///check this out and change if needed
//    if (data.Context.games) {
//        this.Games.lists = data.Context.games;
//        this.NumGames = data.Context.games;
//        this.Games.Render();
//    }

    //page.ReloadAds();

    ///show dialog with current messages...then upon ok click, show alert...
    if (this.Context.pu && this.Context.pu == "1") {
        this.Dialog(this.Context.puTitle, this.Context.puText + alerts, Riot.Resource.OK, function () { $(this).dialog("close"); self.PopupAlert(); }, "", true)
    }
    else {
        this.PopupAlert();
    }

}

Riot.Game.prototype.Log = function (s) {
    //if (this.Context.Log == "1") {
    var msg = $('<div></div>').html(s);
    $('#divLog').prepend(msg);
    //  }
}
