$.fn.scrolled = function (waitTime, fn) {
    var tag = "scrollTimer";
    this.scroll(function () {
        var self = $(this);
        var timer = self.data(tag);
        if (timer) {
            clearTimeout(timer);
        }
        timer = setTimeout(function () {
            self.data(tag, null);
            fn();
        }, waitTime);
        self.data(tag, timer);
    });
}