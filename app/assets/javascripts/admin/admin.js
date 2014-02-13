
function approve_selected_users(action) {
    $("#success_msg").text("");
    var user_ids = [];
    $("td input#brandslip_user").each(function() {
        if ($(this).is(':checked')) {
            user_ids.push($(this).attr('value'));
        }
    });
    var is_approved = 0;
    if(action == "approve"){
        is_approved = 1;
    }else if(action == 'reject'){
        is_approved = 2;
    }
    alert(user_ids);
    if (user_ids.length > 0) {
        $.ajax({
            url: "action_on_selected_user",
            type: "post",
            dataType: 'json',
            data: {
                "user_id": user_ids,
                "is_approved": is_approved
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
            success: function(data) {
                
                for(var index = 0; index < user_ids.length; index ++){
                    var status = "";
                    if(action == 'approve'){
                        status = "Approved";
                        $("#tr_"+user_ids[index]).find("td#td_status").text(status).css("color", "green");
                    }else if(action == 'reject'){
                        status = "Rejected";
                        $("#tr_"+user_ids[index]).find("td#td_status").text(status).css("color", "red");
                    }
                }
                if(action=='approve'){
                    $("span#success_msg").text("User(s) approved Successfully ").css("color", "green");
                }else{
                    $("span#success_msg").text("User(s) rejected Successfully ").css("color", "red");
                }
                
            }
        });  
    } else {
        alert('Please select atleast one user to ' + action);
    }
    return false;
}

function delete_selected_users() {
    $("#success_msg").text("");
    var user_ids = [];
    $("td input#brandslip_user").each(function() {
        if ($(this).is(':checked')) {
            user_ids.push($(this).attr('value'));
        }
    });
    
    if (user_ids.length > 0) {
        $.ajax({
            url: "delete_selected_user",
            type: "post",
            dataType: 'json',
            data: {
                "user_id": user_ids
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
            success: function(data) {
                
                for(var index = 0; index < user_ids.length; index ++){
                    var status = "";                    
                    $("#tr_"+user_ids[index]).remove();
                }
                $("span#success_msg").text("User(s) deleted Successfully ").css("color", "green");                
                
            }
        });  
    } else {
        alert('Please select atleast one post to delete');
    }
    return false;
}

function delete_selected_posts() {
    $("#success_msg").text("");
    var post_ids = [];
    $("td input#brandslip_user").each(function() {
        if ($(this).is(':checked')) {
            post_ids.push($(this).attr('value'));
        }
    });
    
    if (post_ids.length > 0) {
        $.ajax({
            url: "delete_selected_posts",
            type: "post",
            dataType: 'json',
            data: {
                "post_ids": post_ids
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
            success: function(data) {
                
                for(var index = 0; index < post_ids.length; index ++){
                    var status = "";                    
                    $("#tr_"+post_ids[index]).remove();
                }
                $("span#success_msg").text("Post(s) has been deleted Successfully ").css("color", "green");                
                
            }
        });  
    } else {
        alert('Please select atleast one post to delete');
    }
    return false;
}


function delete_selected_suggested_posts() {
    $("#success_msg").text("");
    var post_ids = [];
    $("td input#brandslip_user").each(function() {
        if ($(this).is(':checked')) {
            post_ids.push($(this).attr('value'));
        }
    });
    
    if (post_ids.length > 0) {
        $.ajax({
            url: "delete_selected_suggested_posts",
            type: "post",
            dataType: 'json',
            data: {
                "post_ids": post_ids
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
            success: function(data) {
                
                for(var index = 0; index < post_ids.length; index ++){
                    var status = "";                    
                    $("#tr_"+post_ids[index]).remove();
                }
                $("span#success_msg").text("Suggested Post(s) has been deleted Successfully ").css("color", "green");                
                
            }
        });  
    } else {
        alert('Please select atleast one to delete');
    }
    return false;
}
function delete_selected_bids() {
    $("#success_msg").text("");
    var bid_ids = [];
    $("td input#brandslip_user").each(function() {
        if ($(this).is(':checked')) {
            bid_ids.push($(this).attr('value'));
        }
    });
    
    if (bid_ids.length > 0) {
        $.ajax({
            url: "delete_selected_bids",
            type: "post",
            dataType: 'json',
            data: {
                "bid_ids": bid_ids
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
            success: function(data) {
                
                for(var index = 0; index < bid_ids.length; index ++){
                    var status = "";                    
                    $("#tr_"+bid_ids[index]).remove();
                }
                $("span#success_msg").text("Bid(s) has been canceled Successfully ").css("color", "green");                
                
            }
        });  
    } else {
        alert('Please select atleast one bid to delete');
    }
    return false;
}
function delete_selected_suggestion_bids() {
    $("#success_msg").text("");
    var bid_ids = [];
    $("td input#brandslip_user").each(function() {
        if ($(this).is(':checked')) {
            bid_ids.push($(this).attr('value'));
        }
    });
    
    if (bid_ids.length > 0) {
        $.ajax({
            url: "delete_selected_suggestion_bids",
            type: "post",
            dataType: 'json',
            data: {
                "bid_ids": bid_ids
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
            success: function(data) {
                
                for(var index = 0; index < bid_ids.length; index ++){
                    var status = "";                    
                    $("#tr_"+bid_ids[index]).remove();
                }
                $("span#success_msg").text("Suggestion Bid(s) has been canceled Successfully ").css("color", "green");                
                
            }
        });  
    } else {
        alert('Please select atleast one bid to delete');
    }
    return false;
}

function delete_selected_reviews() {
    $("#success_msg").text("");
    var bid_ids = [];
    $("td input#brandslip_user").each(function() {
        if ($(this).is(':checked')) {
            bid_ids.push($(this).attr('value'));
        }
    });
    
    if (bid_ids.length > 0) {
        $.ajax({
            url: "delete_selected_reviews",
            type: "post",
            dataType: 'json',
            data: {
                "review_ids": bid_ids
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
            success: function(data) {
                
                for(var index = 0; index < bid_ids.length; index ++){
                    var status = "";                    
                    $("#tr_"+bid_ids[index]).remove();
                }
                $("span#success_msg").text("Suggestion Bid(s) has been canceled Successfully ").css("color", "green");                
                
            }
        });  
    } else {
        alert('Please select atleast one bid to delete');
    }
    return false;
}
