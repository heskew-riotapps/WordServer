 
Riot.Utils = {

    GetStorageItem: function (key) {
        try { return localStorage[key]; } catch (e) { return null; }
    },

    SetStorageItem: function (key, value) {
        try { localStorage[key] = value; } catch (e) { }
    },

    RemoveStorageItem: function (key) {
        try { localStorage.removeItem(key); } catch (e) { }

    },

    LocalStorage: function () {
        try { return localStorage; } catch (e) { return null; }
    },

    SetLocalDate: function (d, ms) {
        var t = new Date();
        t.setTime(ms);
        $("#" + d).text(Riot.Resource.Months[t.getMonth()] + " " + t.getDate() + ", " + Riot.Utils.FormatTime(t));
        $("#" + d).text(Riot.Utils.GetLocalDate(ms));
    },

    GetLocalDate: function (ms) {
        var t = new Date();
        t.setTime(ms);
        return Riot.Resource.Months[t.getMonth()] + " " + t.getDate() + ", " + Riot.Utils.FormatTime(t);
    },

    IsChrome: function () {
        return navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
    },

    FormatTime: function (dt) {
        var a_p = "";
        var d = new Date();
        var curr_hour = dt.getHours();
        if (curr_hour > 11) {
            a_p = "PM"; /////resource
        }
        else {
            a_p = "AM";
        }
        if (curr_hour == 0) {
            curr_hour = 12;
        }
        if (curr_hour > 11) {
            curr_hour = curr_hour - 12;
        }

        var curr_min = dt.getMinutes();

        curr_min = curr_min + "";

        if (curr_min.length == 1) {
            curr_min = "0" + curr_min;
        }
        return curr_hour + ":" + curr_min + " " + a_p;
    },

    GetBadgeTitle: function (b) {
        return eval("Riot.Resource.Badge_" + b);
    },

    GetRandomInt: function (min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

}