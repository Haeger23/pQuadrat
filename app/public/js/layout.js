(function($) {
    var url = pSquared.baseUrl;
    $("#search ul").on("click", "a", function() {
        var $this = $(this),
            text = $this.text(),
            $buttonGroup = $this.closest(".btn-group"),
            $button = $buttonGroup.find("button");
        $button.children(".text").text(text);
        $button.children("i").attr("class", $this.children("i").attr("class"));

        $buttonGroup.next()
            .attr("placeholder", "Search for "+{All: "Projects and Users", Projects: "Projects", Users: "Users"}[$.trim(text)])
    });
    $("#search")
        .submit(function() {
            var $form = $(this),
                session = pSquared.session;

            $form.attr("action", url+"/search/"+ $.trim($form.find(".text").text().toLowerCase()));
        })
        .find("input").keydown(function(e) {
            if(e.which == 13) {
                $("#search").submit();
                return false;
            }
        });

    $("#logout").click(function() {
        var $this = $(this),
            href = $this.attr("href");

        $.ajax({
            url: href+"/logout",
            type: "post",
            data: {session: pSquared.session},
            dataType: "json",
            success: function(data) {
                window.location.href = href
            }
        });

        return false;
    });


    $("form:not(.noAjax)").ajaxForm({
        data: {session: pSquared.session},
        dataType: "json",
        forceSync: true,
        beforeSubmit: function(arr, $form, options) {
            if($form.valid()){
                $form.find("button[type=submit]").after("<div class='ajax-load'></div>");
            }else{
                return false;
            }
        },
        success: function(data, statusText, xhr, $form) {
            $form.find(".ajax-load").remove();

            var $messages = $("#messages"),
                $message = $("<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert'>×</button><h4>Success!</h4></div>");

            if(data.message) {
                $message.append("<div>"+data.message+"</div>");
            }
            $messages.html($message);

            if(pSquared.success instanceof Function) {
                pSquared.success(data, statusText, xhr, $form);
            }
            var href = $form.attr("data-href");

            if(href) {
                if(pSquared.session) {
                    var connection = href.indexOf("?") == -1 ? "?" : "&";
                    href += connection+"session="+pSquared.session;
                }
                setTimeout(function() {
                    window.location.href = pSquared.baseUrl + href;
                }, 500);
            }
        },
        error: function(xhr) {
            $(".ajax-load").remove();
            var response = $.parseJSON(xhr.responseText),
                errors = response.errors;

            var $element,
                $messages = $("#messages"),
                $message = $("<div class='alert alert-error'><button type='button' class='close' data-dismiss='alert'>×</button><h4>Validation failed!</h4></div>");

            if(errors) {
                $element = $("<ul></ul>");
                for(var field in errors) {
                    var $li = $("<li>"+field+"</li>"),
                        $innerUl = $("<ul></ul>").appendTo($li),
                        fieldErrors = errors[field];


                    for(var i = 0, length = fieldErrors.length; i < length; i++) {
                        $innerUl.append("<li>"+fieldErrors[i]+"</li>");
                    }
                    $element.append($li)
                }
            } else if(response.message) {
                $element = $("<div>"+response.message+"</div>");
            }
            if($element) {
                $message.append($element);
            }
            $messages.html($message);
        }
    });
}(jQuery))
