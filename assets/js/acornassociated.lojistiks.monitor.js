$(document).ready(function(){
    // Whole-website monitor
    if (window.Echo && window.Echo.channel) {
        window.Echo
            .channel('lojistiks')
            .listenToAll(function(channelEvent, lojistiksEvent) {
                acorn_onLojistiksEvent(channelEvent, lojistiksEvent);
            });
    }
});

function acorn_onLojistiksEvent(channelEvent, lojistiksEvent) {
    var audio = new Audio('/plugins/acorn/lojistiks/assets/sounds/data-change.mp3');
    // TODO: This sound will not play without user interaction
    audio.play();

    if (window.console) console.log(channelEvent, lojistiksEvent);
    // TODO: lojistiksEvent should dictate messages
    // TODO: switch based on channelEvent?
    // channelEvent   = .data.change
    // lojistiksEvent = {db:{...}}
    let db         = lojistiksEvent.db;
    let TG_OP      = db.TG_OP; // INSERT
    let modelClass = db.modelClass; // Acorn\Lojistiks\Models\Brand
    let ID         = db.ID;

    let TG_OPPast  = TG_OP.toLowerCase() + 'ed';   // inserted
    let shortClass = modelClass.split('\\').pop(); // Brand
    let classDir   = shortClass.toLowerCase();

    let notifyHTML = 'A new ' + shortClass + ' has been ' + TG_OPPast;
    let updateUrl  = '/backend/acorn/lojistiks/' + classDir + '/update/' + ID;
    let viewHTML   = '<a target="_blank" href="' + updateUrl + '">view</a>';

    // Highlight the incoming row
    $('head').append($('<style>').text('tr.rowlink:has(a[href*=\'' + ID + '\']) td { \
        background-color:#ffbbbb!important; \
        opacity: 1; \
        animation-name: fadeInOpacity; \
        animation-iteration-count: 1; \
        animation-timing-function: ease-in; \
        animation-duration: 2s; \
      }'));

    // Show a flash with a link
    $.wn.flashMsg({
        'text': notifyHTML + '&nbsp;' + viewHTML,
        'class': 'success',
        'interval': 10
    });

    // Refresh and list views
    if ($('#ListWidgetContainer').length) {
      $.request('onRefreshList', {update: { list: '#ListWidgetContainer' }});
    }
}
