
Riot.TrayTile = function (y) {
    var o = this;
    o.c = "riotTrayTile";
    o.Id = y;
    o.Position = 0;
    o.Letter = "";
    o.PreviousLetter = "";
    o.Left = 0;
    o.Top = 0;
    o.Right = 0;
    o.Bottom = 0;
    o.Offset = {l: 0, t: 0, h: 0, w:0};

    o.GetElement = function () {
        return $('#' + o.c + '_' + o.Id);
    };

    o.GetValueElement = function () {
        return $('#' + o.c + 'Value_' + o.Id);
    };

    o.GetLetterElement = function () {
        return $('#' + o.c + 'Letter_' + o.Id);
    };

//    o.SetClickContext = function () {
//        o.ClickContext = true;
//        o.GetElement().addClass(o.c + 'Click');
//        o.GetValueElement().addClass(o.c + 'ValueClick');
//        o.GetLetterElement().addClass(o.c + 'LetterClick');
//    };

//    o.RemoveClickContext = function () {
//        o.ClickContext = false;
//        o.GetElement().removeClass(o.c + 'Click');
//        o.GetValueElement().removeClass(o.c + 'ValueClick');
//        o.GetLetterElement().removeClass(o.c + 'LetterClick');
//    };
};
