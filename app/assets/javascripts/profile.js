function send_message(){
    var from_user_id = $("#from_user").val();
    var to_user_id = $("#to_user").val();
    var message_title = $(".message_title").val();
    var message_body = $(".message_body").val();
    if(to_user_id == ""){
        alert("Please select user to send message.");
    }else{
        $.ajax({
            url: "send_message",
            type: "post",
            dataType: 'json',
            data: {
                "from_user_id": from_user_id,
                "to_user_id": to_user_id,
                "message_title": message_title,
                "message_body": message_body,
            },
            beforeSend: function() {
                $("#ajaxloading").css({
                    'display': 'inline-block'
                });
            },
            complete: function() {
                $("#ajaxloading").css({
                    'display': 'none'
                });
            },
            success: function() {
                $("#success_msg").text("Message sent Successfully").css('color', 'green');
                $("#to_user").val("");
                $("input#message_title").val("");
                $("#message_body").val("");
            }
        });        
    }
             
}
