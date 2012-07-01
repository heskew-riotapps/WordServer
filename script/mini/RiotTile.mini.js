Riot.Tile = function () {
    //x - horizontal, y vertical
    var o = this;
    o.Id = 0;
    o.Row = 0;
    o.Column = 0;
    o.OriginalLetter = "";
    o.Letter = "";
    o.LetterMultiplier = 1;
    o.WordMultiplier = 1;
    o.IsStarterTile = false;
    o.TileClass = "riotTile";
    // o.TileClassZoom = Riot.Constants.TileClassZoom;
    o.TileDivIdPrefix = "riotTile_";
    o.IsLastPlayed = false;
    o.IsReplacement = false;
    o.IsPlacement = false;
    o.PlacedLetter = "";
    o.Element = null;
    o.ValueElement = null;
    o.LetterElement = null;
    o.CornerElement = null;
    o.IsOnLeftBorder = false;
    o.IsOnRightBorder = false;
    o.IsOnTopBorder = false;
    o.IsOnBottomBorder = false;
    o.IsConnected = false;
    o.IsDroppable = false;

    o.PlacedLetterMultiplier = function () {
        return (o.Letter.length > 0) ? 1 : o.LetterMultiplier;
    };

    o.PlacedWordMultiplier = function () {
        return (o.Letter.length > 0) ? 1 : o.WordMultiplier;
    };

    o.IsPlayed = function () {
        return (o.OriginalLetter.length > 0);
    };

    o.GetWordLetter = function () {
        return (o.PlacedLetter.length > 0) ? o.PlacedLetter : o.Letter;
    };

    o.GetDivId = function () {
        return o.TileDivIdPrefix + o.Id;
    };

    o.SetPlacedTile = function (letter) {
        o.PlacedLetter = letter;
        o.IsPlacement = true;
    };

    o.RemovePlacedTile = function () {
        o.PlacedLetter = "";
        o.IsPlacement = false;
    };

    o.IsPlacementAllowed = function (numReplacementsLeft) {
        if (o.IsPlacement === false) {
            if (o.Letter.length === 0 || numReplacementsLeft > 0) {
                return true;
            }
        }
        return false;
    };

    o.GetElement = function () {
        if (!o.Element) {
            o.Element = $('#t_' + o.Id);
        }
        return o.Element;
    };

    o.GetValueElement = function () {
        if (!o.ValueElement) {
            o.ValueElement = $('#tv_' + o.Id);
        }
        return o.ValueElement
    };

    o.GetCornerElement = function () {
        if (!o.CornerElement) {
            o.CornerElement = $('#tc_' + o.Id);
        }
        return o.CornerElement
    };

    o.GetLetterElement = function () {
        if (!o.LetterElement) {
            o.LetterElement = $('#tl_' + o.Id);
        }
        return o.LetterElement
    };

};