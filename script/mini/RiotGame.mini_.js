
Riot.Hub.Game = (function () {

    this.BoardTiles = new Array();
    this.TrayTiles = new Array();
    this.Cols = parseInt(Riot.Constants.NumCols) - 1;
    this.Rows = parseInt(Riot.Constants.NumRows) - 1;
    this.TrayTileIdInClickContext = "";
    this.LetterInDragContext = "";
    this.BoardTileIdInClickContext = "";
    // this.TimerIdInTrayTileIdInDropOverContext = -1;
    this.BoardTileWidth = 0;
    this.TrayTileWidth = 50;
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

    function init(g) {
        initOuter();
        //        setupSB();
        //        setupTabs();
    };

    function submit() {
        debugger;
        if ($("#fbText").val().length == 0) {
            Riot.Hub.Dialog(Riot.Resource.GeneralErrorTitle, Riot.Resource.FBNotEntered);
        }
        else {
            var data = new Object()
            data["fb"] = $("#fbText").val();
            Riot.Hub.post("SaveFeedback", data, Riot.Hub.Feedback.go);
        }
    };

    function goToGame() {
        var self = this;
        $("#game").show();
        $("#gameW").hide();
        $('#btnWList').unbind('click').text(Riot.Resource.SBWordsBtn).attr("title", Riot.Resource.SBWordsBtnRollover);
        $('#btnWList').click(function () {
            Riot.Hub.Game.SubmitWords();
        });
        // page.ReloadAds();
    };

    function submitPlay() {

        var d = new Object();
        var tiles = new Array();
        for (i = 0; i < this.PlacedTiles.length; i++) {
            var tile = new Object();
            tile["Id"] = this.PlacedTiles[i].Id;
            tile["Letter"] = this.PlacedTiles[i].PlacedLetter;
            tiles.push(tile);
        }
        d["Tiles"] = tiles;


        Riot.Hub.Post("play", d, Riot.Hub.Game.Go);
    };


    function go(d) {
        debugger;
        // if ($("#ajaxLoader").dialog("isOpen")) { $("#ajaxLoader").dialog("close"); }
        if (d.ReturnCode == 9) {
            Riot.Hub.popup(d.Context.alT, d.Context.alTx);
            $("#fbText").val("");
        }
        else if (d.ReturnCode == 1) {
            Riot.Hub.popup(Riot.Resource.GeneralErrorTitle, d.Error);
        }
    };

    function refreshState() {
        this.SaveState();
        this.State = null;
        this.LoadState();
    }

    function popupAlert() {
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
    };

    function clearState() {
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
    };

    function loadState() {

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
    };

    function setPlayBtn() {
        if (this.Context.sb.pTurn == 1) {
            this.LoadPlacedTiles();
            var txt = Riot.Resource.PlayTurn;
            var title = Riot.Resource.PlayTurnTitle;
            if (PlacedTiles.length == 0) {
                txt = Riot.Resource.SkipTurn;
                title = Riot.Resource.SkipTurnTitle;
            }
            $("#btnPlay").text(txt).attr('title', title);
        }
    };

    function init() {
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

        // this.TrayTileWidth = this.GetTrayTileWidth();
        if (this.Context.active == true) { this.LoadState(); }

        this.LoadBoardTiles();

        //    this.Log("init.top2: " + this.DragArea[1]);
        this.LoadBoard(false);

        if (this.Context.active == true) { loadBoardTilesFromState(); }

        this.LoadTrayTiles(true);
        this.LoadTray();

        this.SetTab("rt-ch")
        this.RenderTemplates();

        this.TurnEventSetUp();
        this.DialogSetup();

        var self = this;

        //if not this player's turn set up interval
        try { this.interval = clearInterval(this.interval); } catch (e) { }
        if (this.Context.active == true) {
            if (this.Context.sb.pTurn == 0) {
                this.interval = setInterval(function () {
                    self.CheckTurn();
                }, 180000);
            }
            else {
                this.interval = setInterval(function () {
                    self.CheckChatter();
                }, 180000);
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

    };

    function CheckState() {
        if (this.ResetState == true) {
            this.RefreshState();
            this.ResetState = false;
        }
    }

    function LoadBoardTilesFromState() {
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

    function getLetterValue(l) {
        var letterVal = "";
        $(Riot.Alphabet.Letters).each(function (index, value) {
            if (value.C == l) {
                letterVal = value.V;
                return false;
            }
        });

        return letterVal;

    }

    function LoadBoardTiles() {
        var q = 0;
        for (i = 0; i <= this.Rows; i++) {
            for (j = 0; j <= this.Cols; j++) {

                this.BoardTiles[q] = new Riot.BoardTile();
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
    };

    function SaveState() {
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
    };

    function AutoShuffle() {
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

function Shuffle() {
    //push blank tiles to the end????
    $.shuffle(this.TrayTiles);
    this.ClearTrayTileClickContext();
    for (i = 0; i <= this.Context.TrayTiles.length - 1; i++) {
        this.TrayTiles[i].Id = i + 1;
        this.TrayTiles[i].Position = i + 1;
    }

    $('#divTray').empty();
    this.LoadTray();
}

function RecallTrayTiles() {
    this.LoadPlacedTiles();
    $("#sbCalc").text("0");

    var numEmptyTrayTilesReplaced = 0;
    if (this.PlacedTiles.length > 0) {
        //  this.LoadState();

        this.ClearTrayTileClickContext();
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

function LoadTrayTiles(s) {
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

function GetTrayTileByDivId(id) {
    var tileId = id.replace(Riot.Constants.TileTrayIdPrefix, "");
    return this.GetTrayTileById(tileId)
}

function GetTrayTileById(id) {
    var oTile;
    $(this.TrayTiles).each(function (index, value) {
        if (value.Id == id) {
            oTile = value;
            return false;
        }
    });

    return oTile;
}

function GetBoardTileById(id) {
    return this.BoardTiles[id];
}

function GetBonusTileById(id) {
    var oTile;
    $(Riot.Layout.BonusTiles).each(function (index, value) {
        if (parseInt(value.Id) == id) {
            oTile = value;
            return false;
        }
    });

    return oTile;
}

function GetStarterTileById(id) {
    var oTile;
    $(Riot.Layout.StarterTiles).each(function (index, value) {
        if (parseInt(value.Id) == id) {
            oTile = value;
            return false;
        }
    });

    return oTile;
}

function GetBoardTileByDivId = function (id) {
    var tileId = id.replace(Riot.Constants.TileDivIdPrefix, "");
    return this.GetBoardTileById(tileId)
}

function GetBoardTileByPos = function (r, c) {
    var oTile;
    $(this.BoardTiles).each(function (index, value) {
        if (value.Row == r && value.Column == c) {
            oTile = value;
            return false;
        }
    });

    return oTile;
}

function GetPlayedTile(t) {
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
function LoadBoard(zoom) {
    $('#divBoard').empty();

    for (i = 0; i <= this.Rows; i++) {
        var row = $('<div></div>');
        row.id = Riot.Constants.TileRowIdPrefix + (i + 1);
        $(row).addClass(Riot.Constants.TileRowClass)

        for (j = 0; j <= this.Cols; j++) {

            var tile = this.GetBoardTileByPos(i + 1, j + 1);
            var t = $('<div></div>');

            //add divs here and class in Render method, call render from here
            //all classes should be overrides

            //   tile.id = Riot.Constants.TileDivIdPrefix + oTile.Id;
            t.attr('id', Riot.Constants.TileDivIdPrefix + tile.Id);

            var v = $('<div></div>')
            v.attr('id', Riot.Constants.TileDivValueIdPrefix + tile.Id);

            var c = $('<div></div>')
            c.attr('id', Riot.Constants.TileDivCornerIdPrefix + tile.Id);

            var l = $('<div></div>')//.text(letter);
            l.attr('id', Riot.Constants.TileDivLetterIdPrefix + tile.Id);

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


function LoadTray() {
    // var w = this.TrayTileWidth; parseInt(Riot.Constants.TrayTileImgWidth);
    $('#divTray').empty();

    for (i = 0; i <= 6; i++) {

        var t = $('<div></div>');
        t.attr('id', Riot.Constants.TileTrayIdPrefix + (i + 1));

        t.addClass(Riot.Constants.TrayTileClass);

        var letter = this.TrayTiles[i].Letter;

        var v = $('<div></div>');
        v.attr('id', Riot.Constants.TileTrayValueIdPrefix + (i + 1));
        v.addClass(Riot.Constants.TrayTileValueClass).text(this.GetLetterValue(letter));

        t.append(v);
        var l = $('<div></div>');
        l.attr('id', Riot.Constants.TileTrayLetterIdPrefix + (i + 1));
        l.addClass(Riot.Constants.TrayTileLetterClass).text(letter);

        if (letter.length == 0) {
            t.addClass(Riot.Constants.TrayTileEmptyClass);
            v.addClass(Riot.Constants.TrayTileValueEmptyClass);
            l.addClass(Riot.Constants.TrayTileLetterEmptyClass);
            t.addClass(Riot.Constants.TrayTileNoDragClass);
        }

        t.append(l);

        $('#divTray').append(t);
    }

    this.ResetState = true;

    if (this.Context.active == true) {
        this.TrayEventSetUp();
    }

}
    return {
        init: init,
        submit: submit,
        go: go
    };
})();


 