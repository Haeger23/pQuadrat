(function($) {
    var $parameters = $("#parameters");
    $("form")
        .submit(function() {
            var $form = $(this),
                type = $form.children("#accept").val(),
                $params = $parameters.children(),
                parameter = {};

            $params.each(function() {
                var $inputs = $(this).children("input");
                parameter[$inputs.eq(0).val()] = $inputs.eq(1).val();
            });

            $.ajax({
                url: $form.children("#url").val(),
                type: $form.children("#type").val(),
                dataType: type,
                data: parameter,
                success: function(data, textStatus) {
                    console.log(textStatus, data);
                    if(type == "html") {
                        $("#result").html(data)
                    } else if(type == "json") {
                        $("#result").html("").text(JSON.stringify(data));
                    } else if(type == "xml") {
                        $("#result").text(window.ActiveXObject ? $(data).xml : (new XMLSerializer()).serializeToString(data));
                    }
                },
                error: function(jqXHR, textStatus) {
                    $("#result").html(jqXHR.status+": "+jqXHR.responseText)
                }
            })
            return false;
        })
        .children("a")
            .click(function() {
                $("<div class='parameters'><input /><input /></div>")
                    .append($("<a href='#'>remove</a>").click(function() { $(this).parent().remove()}))
                    .appendTo($parameters);
            });
}(jQuery));

