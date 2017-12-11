// JQUERY PLUGIN FOR DATE SHORT
jQuery.extend( jQuery.fn.dataTableExt.oSort, {
    "order-data-pre": function ( d ) {
        var split = d.split('/');
        return new Date(split[2]+"-"+split[1]+ "-" + split[0]).getTime();
    },
 
    "order-data-asc": function ( a, b ) {
        return ((a < b) ? -1 : ((a > b) ? 1 : 0));
    },
 
    "order-data-desc": function ( a, b ) {
        return ((a < b) ? 1 : ((a > b) ? -1 : 0));
    }
} );