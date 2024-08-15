$(function(){
  $.getScript("/plugins/acorn/lojistiks/assets/js/html5-qrcode.js", function( data, textStatus, jqxhr ) {
    if (jqxhr.status != 200) console.error( "html5-qrcode.js load fail" );
    $.getScript("/plugins/acorn/lojistiks/assets/js/findbyqrcode.js", function( data, textStatus, jqxhr ) {
      if (jqxhr.status != 200) console.error( "html5-qrcode.js load fail" );
    });
  });
  $.getScript("/plugins/acorn/lojistiks/assets/js/forms.js", function( data, textStatus, jqxhr ) {
    if (jqxhr.status != 200) console.error( "forms.js load fail" );
  });
});
