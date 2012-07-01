
Riot.Feedback = (function () {
    function init() {
        //alert("feedback init");
        debugger;
        $("#fbSave").unbind("touchstart");
        $("#fbSave").bind("touchstart", function (e) {
            Riot.Feedback.Submit();
        });
    };

    function submit() {
        if ($("#fbText").val().length == 0) {
            Riot.Hub.Popup(Riot.Resource.GeneralErrorTitle, Riot.Resource.FBNotEntered);
        }
        else {
            var d = {};
            d.fb = $("#fbText").val();
            Riot.Hub.Post("SaveFeedback", d, Riot.Feedback.Go);
        }
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
        Submit: submit,
        Go: go
    };
})();


 