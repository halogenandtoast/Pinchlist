// Copyright (c) 2009 Stefano J. Attardi, http://attardi.org/

(function($) {
    function toggleLabel() {
        var input = $(this);
        setTimeout(function() {
            var def = input.attr('title');
            if (!input.val() || (input.val() == def)) {
                input.prev('span').css('visibility', '');
                if (def) {
                    var dummy = $('<label></label>').text(def).css('visibility','hidden').appendTo('body');
                    input.prev('span').css('margin-left', dummy.width() + 3 + 'px');
                    dummy.remove();
                }
            } else {
                input.prev('span').css('visibility', 'hidden');
            }
        }, 0);
    };

    function resetField() {
        var def = $(this).attr('title');
        if (!$(this).val() || ($(this).val() == def)) {
            $(this).val(def);
            $(this).prev('span').css('visibility', '');
        }
    };

    $('input, textarea').on('keydown', toggleLabel);
    $('input, textarea').on('paste', toggleLabel);
    $('select').on('change', toggleLabel);

    $('input, textarea').on('focusin', function() {
        $(this).prev('span').css('color', '#E2D264');
    });
    $('input, textarea').on('focusout', function() {
        $(this).prev('span').css('color', '#eee');
    });

    $(function() {
        $('input, textarea').each(function() { toggleLabel.call(this); });
    });

})(jQuery);
