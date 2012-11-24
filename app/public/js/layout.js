(function($) {
    var url = p_squared.base_url;
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
            var $form = $(this);
            $form.attr("action", url+"/search/"+ $.trim($form.find(".text").text().toLowerCase()) +"?"+$form.find("input").serialize());
        })
        .find("input").keydown(function(e) {
            if(e.which == 13) {
                $("#search").submit();
                return false;
            }
        })
}(jQuery))
