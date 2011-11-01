/*
 * jQuery outside events - v1.1 - 3/16/2010
 * http://benalman.com/projects/jquery-outside-events-plugin/
 * 
 * Copyright (c) 2010 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 */
(function(a,b,c){function d(d,e){function h(b){a(f).each(function(){var c=a(this);this!==b.target&&!c.has(b.target).length&&c.triggerHandler(e,[b.target])})}e=e||d+c;var f=a(),g=d+"."+e+"-special-event";a.event.special[e]={setup:function(){f=f.add(this),f.length===1&&a(b).bind(g,h)},teardown:function(){f=f.not(this),f.length===0&&a(b).unbind(g)},add:function(a){var b=a.handler;a.handler=function(a,c){a.target=c,b.apply(this,arguments)}}}}a.map("click dblclick mousemove mousedown mouseup mouseover mouseout change select submit keydown keypress keyup".split(" "),function(a){d(a)}),d("focusin","focus"+c),d("focusout","blur"+c),a.addOutsideEvent=d})(jQuery,document,"outside")