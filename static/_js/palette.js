(function($){


    /*
    * Created a palette around a textfield
    *
    * @param    object  opt     options
    */
    jQuery.fn.palette = function(opt){

        options = jQuery.extend(
            {
                // array colors
                colors: ['#ff0000', '#ffa500', '#ffff00'],
                // palette length
                length: 3,
                onSelect: function() {}

            }, opt);

        return this.each(function() {
            var $self = $(this).wrap('<span class="palettebox"></span>').parent('.palettebox');

            $self.click(function(e) {
                var $clicked = $(e.target);
                if ( $clicked.hasClass('palette') ) {
                    $self.uncolor();
                    $clicked.html('').addClass('coloring');
                };

                options.onSelect.call($self);
            });

            var count = 0;
            for ( i=0; i < options.colors.length; i++ ) {
                count++;
                if(i === 0){
                    var str = options.colors[i].split('#');
                    $('<span id="'+str[1]+'" class="palette" title="Vermelho, nível de importância alto" ></span>')
                    .appendTo( $self )
                    .css( 'background-color', options.colors[i] );
                    $('<p id="descCoresAlta">Peso 9</p><br>').appendTo($self);
                }
                if(i === 1){
                    var str = options.colors[i].split('#');    
                    $('<span id="'+str[1]+'" class="palette" title="Laranja, nível de importância médio" ></span>')
                    .appendTo( $self )
                    .css( 'background-color', options.colors[i] );
                    $('<p id="descCoresMedia">Peso 3</p><br>').appendTo($self);
                }
                if(i === 2){
                    var str = options.colors[i].split('#');    
                    $('<span id="'+str[1]+'" class="palette" title="Amarelo, nível de importância baixo" ></span>')
                    .appendTo( $self )
                    .css( 'background-color', options.colors[i] );
                    $('<p id="descCoresBaixa">Peso 1</b><br>').appendTo($self);
                }
                
                if (count % options.length === 0) {
                    $('.palettebox').append('<br class="clear"/>');
                }
            };
        });
    };

    /*
    * Unselect the selected palette
    *
    * @param	boolean	clearTextfield	option to clear the textfield as well
    * @return	object	each item passed in
    */
    jQuery.fn.uncolor = function(clearTextfield) {
        return this.each(function() {
            $('.coloring', this).html('').removeClass('coloring');
        });
    };

    /*
    * Add palette
    *
    * @param    color
    */
    jQuery.fn.addPalette = function(color) {
        return this.each(function() {
            var $self = $(this).parent('.palettebox');

            $('<span class="palette" title="' + color + '"></span>')
                .appendTo( $self )
                .css( 'background-color', color );
            if (options.colors.length % options.length === 0 )
                $('.palettebox').append('<br class="clear"/>');
        });
    };

    /*
     * Add color
     *
     * @param   color
     */
    jQuery.fn.addColor = function(color) {
        options.colors.push(color);
        $("#paletaCores").addPalette(color);
    };

    /*
     *  Change color
     *
     *  @param  color
     */
    jQuery.fn.changeColor = function(color) {
        $(".coloring").css('background-color', color);
    };
})(jQuery);