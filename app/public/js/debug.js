(function($) {
    var $form = $("form"),
        $parameters = $("#parameters"),
        $accept = $form.find("#accept"),
        $url = $form.find("#url"),
        $type = $form.find("#type");

    $form
        .submit(function() {
            var $form = $(this),
                type = $accept.val(),
                $params = $parameters.children(),
                parameter = {};

            $params.each(function() {
                var $inputs = $(this).children("input");
                parameter[$inputs.eq(0).val()] = $inputs.eq(1).val();
            });

            $.ajax({
                url: $url.val(),
                type: $type.val(),
                dataType: type,
                data: parameter,
                success: function(data) {
                    console.log(data);
                    if(type == "html") {
                        $("#result").html(data)
                    } else if(type == "json") {
                        $("#result").html("").append($("<pre></pre>").text(JSON.stringify(data)));
                    } else if(type == "xml") {
                        $("#result").html("").append($("<pre></pre>").text(window.ActiveXObject ? $(data).xml : (new XMLSerializer()).serializeToString(data)));
                    }
                },
                error: function(jqXHR, textStatus) {
                    $("#result").html(jqXHR.status+": "+jqXHR.responseText)
                }
            })
            return false;
        })
        .find("#addParameter")
            .click(function() {
                $("<div class='parameters'><input type='text' class='input-small'/><input type='text'/></div>")
                    .append($("<button class='btn btn-danger'><i class='icon-remove icon-white'></i></button>").click(function() { $(this).parent().remove()}))
                    .appendTo($parameters);
            })
            .end()
        .find("#removeAllParameter")
            .click(function() {
                $parameters.html("");
            })
}(jQuery));

