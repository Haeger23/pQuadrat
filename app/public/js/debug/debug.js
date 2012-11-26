(function($) {
    var $form = $("#debugForm"),
        $parameters = $("#parameters"),
        $accept = $form.find("#accept"),
        $url = $form.find("#url"),
        $type = $form.find("#type");

    $form
        .submit(function() {
            var type = $accept.val(),
                $params = $parameters.children(),
                parameter = {},
                $button = $form.find("button[type=submit]").button("loading");

            $params.each(function() {
                var $inputs = $(this).children("input");
                parameter[$inputs.eq(0).val()] = $inputs.eq(1).val();
            });

            $.ajax({
                url: pSquared.baseUrl + "/" +$url.val(),
                type: $type.val(),
                dataType: type,
                data: parameter,
                success: function(data, textStatus, jqXHR) {
                    var $success = $("<p class='text-success'>Success: "+jqXHR.status+"</p>");
                    if(type == "html") {
                        $("#result").html(data).prepend($success)
                    } else if(type == "json") {
                        $("#result").html($("<pre></pre>").text(JSON.stringify(data))).prepend($success);
                        console.log(data);
                    } else if(type == "xml") {
                        var xmlString = window.ActiveXObject ? $(data).xml : (new XMLSerializer()).serializeToString(data);
                        $("#result").html($("<pre></pre>").text(xmlString)).prepend($success);
                        console.log(dom2js($($.parseXML(xmlString)).find("data").get(0)));
                    }
                    $button.button("reset");
                },
                error: function(jqXHR, textStatus) {
                    var $error = $("<p class='text-error'>Error: "+jqXHR.status+"</p>");
                    if(type == "html") {
                        $("#result").html(jqXHR.responseText).prepend($error)
                    } else if(type == "json") {
                        $("#result").html($("<pre></pre>").text(jqXHR.responseText)).prepend($error);
                        console.log(JSON.parse(jqXHR.responseText));
                    } else if(type == "xml") {
                        $("#result").html($("<pre></pre>").text(jqXHR.responseText)).prepend($error);
                        console.log(dom2js($($.parseXML(jqXHR.responseText)).find("data").get(0)));
                    }
                    $button.button("reset");
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

