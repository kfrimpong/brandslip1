// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require bootstrap-modal

//= require jquery_ujs
//= require jquery-1.8.2
//= require custom_balanced

function delete_selected_messages(msg_id){
    $.ajax({
        url: "delete_messages",
        type: "post",
        dataType: 'json',
        data: {
            "delete_message_id": msg_id
        },
        beforeSend: function() {

        },
        complete: function() {

        },
        success: function() {
            $('li#li_msg_'+msg_id).remove();
            $("#myModalDelete").find("#btn_close").click();
        }
    }); 
}

function delete_selected_sent_messages(sent_msg_id){
    $.ajax({
        url: "delete_messages",
        type: "post",
        dataType: 'json',
        data: {
            "delete_message_id": sent_msg_id
        },
        beforeSend: function() {

        },
        complete: function() {

        },
        success: function() {
            $('li#li_sent_msg_'+sent_msg_id).remove();
            $("#myModalDelete").find("#btn_close").click();
        }
    }); 
}

function reply_to_message(ctrl,message_body){

  // $("#message_body").html(message_body);
    var msg_from_user = $(ctrl).closest("div#msg_div").find("span#msg_from_user").text();
    var msg_subject = "Re: " + $(ctrl).closest("div#msg_div").find("span#msg_subject").text();
    var user_interest = $(ctrl).attr("data-user-interest-id");
    var user_id = $(ctrl).attr("data-user-id");
    $("#myModal").find("input#message_title").val(msg_subject);
    $("#myModal").find("#msg_user_interest").val(user_interest);
    $("#myModal").find("#to_user option").remove();
    var option_html = "<option value="+user_id+">"+msg_from_user+"</option>"
    $("#myModal").find("#to_user").html(option_html);
    
}

function reset_msg_box(){
    $(".modal-dialog").find("#msg_user_interest").val('');
    $(".modal-dialog").find("#to_user option").remove();
    $(".modal-dialog").find("#to_user").html("<option value=''>Select User</option>");
    $(".modal-dialog").find("#message_title").val('');
    $(".modal-dialog").find("#message_body").val('');
}

//Job filter functions 

$("input.user_group_id").live('click', function(){
   var category_arr = [];
   var sub_category_arr = [];
   var crowd_size_arr = [];
   var money_arr = [];
   var online_media_source_arr = [];
   var follow_sub_arr = [];
   $("ul#category_filter input.user_group_id").each(function(){
       if($(this).is(':checked')){
           category_arr.push($(this).attr('data-val'));
       }
   });
   $("ul#sub_category_filter input.user_group_id").each(function(){
       if($(this).is(':checked')){
           sub_category_arr.push($(this).attr('data-val'));
       }
   });
   $("ul#crowd_size_filter input.user_group_id").each(function(){
       if($(this).is(':checked')){
           crowd_size_arr.push($(this).attr('data-val'));
       }
   });
   $("ul#money_filter input.user_group_id").each(function(){
       if($(this).is(':checked')){
           money_arr.push($(this).attr('data-val'));
       }
   });
   $("ul#media_source_filter input.user_group_id").each(function(){
       if($(this).is(':checked')){
           online_media_source_arr.push($(this).attr('data-val'));
       }
   });
   $("ul#follow_sub_filter input.user_group_id").each(function(){
       if($(this).is(':checked')){
           follow_sub_arr.push($(this).attr('data-val'));
       }
   });
   if(category_arr.length == 0){
       category_arr.push(-1);
   }
   if(sub_category_arr.length == 0){
       sub_category_arr.push(-1);
   }
   if(crowd_size_arr.length == 0){
       crowd_size_arr.push(-1);
   }
   if(money_arr.length == 0){
       money_arr.push(-1);
   }
   if(online_media_source_arr.length == 0){
       online_media_source_arr.push(-1);
   }
   if(follow_sub_arr.length == 0){
       follow_sub_arr.push(-1);
   }
   
    $.ajax({
        url: "search_job_filter",
        type: "post",
        data: {
            "category_arr": category_arr,
            "sub_category_arr": sub_category_arr,
            "crowd_size_arr": crowd_size_arr,
            "money_arr": money_arr,
            "online_media_source_arr": online_media_source_arr,
            "follow_sub_arr": follow_sub_arr,
            "job_user_id": $("input#job_user_id").val(),
            "job_type": $("input#job_type").val()
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#all_jobs").html(data);
            $("span#result_found").text($("div#searched_job_div").length);
        }
    });     
});

$("input#chk_valid_for").live('click', function(){
    if($(this).attr('data-val') == 'newly_posted'){
        if($(this).is(':checked')){
            $("input.chk_due_soon").attr('disabled', 'disabled');
        }else{
            $("input.chk_due_soon").removeAttr('disabled');
        }
    }else if($(this).attr('data-val') == 'due_soon'){
        if($(this).is(':checked')){
            $("input.chk_newly_posted").attr('disabled', 'disabled');
        }else{
            $("input.chk_newly_posted").removeAttr('disabled');
        }        
    }
    $.ajax({
        url: "search_job_filter_by_valid_for",
        type: "post",
        data: {
            "valid_for": $(this).attr('data-val'),
            "job_user_id": $("input#job_user_id").val(),
            "job_type": $("input#job_type").val()
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#all_jobs").html(data);
            $("span#result_found").text($("div#searched_job_div").length);
        }
    });     
});


function search_by_location(){
    var state = $("#job_state").val();
    var city = $("#job_city").val();
    if(state == ""){
        alert("Please select state.");
        return false;
    }
    if(city == ""){
        alert("Please select city.");
        return false;
    }
    $.ajax({
        url: "search_job_filter_by_location",
        type: "post",
        data: {
            "state": state,
            "city": city,
            "job_user_id": $("input#job_user_id").val()
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#all_jobs").html(data);
            $("span#result_found").text($("div#searched_job_div").length);
        }
    });  
}


$("input#user_presenter_interest_id, input#presenter_demographic_age, input#online_source, input#presenter_followers_subscribers").live('click', function(){
   var category_arr = [];
   var demographic_arr = [];
   var online_source_arr = [];
   var followers_subscribers_arr = [];
   $("input#user_presenter_interest_id").each(function(){
       if($(this).is(':checked')){
           category_arr.push($(this).attr('data-val'));
       }
   });
   $("input#presenter_demographic_age").each(function(){
       if($(this).is(':checked')){
           demographic_arr.push($(this).attr('data-val'));
       }
   });
   $("input#online_source").each(function(){
       if($(this).is(':checked')){
           online_source_arr.push($(this).attr('data-val'));
       }
   });
   $("input#presenter_followers_subscribers").each(function(){
       if($(this).is(':checked')){
           followers_subscribers_arr.push($(this).attr('data-val'));
       }
   });
   if(category_arr.length == 0){
       category_arr.push(-1);
   }
   if(demographic_arr.length == 0){
       demographic_arr.push(-1);
   }
   if(online_source_arr.length == 0){
       online_source_arr.push(-1);
   }
   if(followers_subscribers_arr.length == 0){
       followers_subscribers_arr.push(-1);
   }
    $.ajax({
        url: "search_profile_filter",
        type: "post",
        data: {
            "category_arr": category_arr,
            "demographic_arr": demographic_arr,
            "online_source_arr": online_source_arr,
            "followers_subscribers_arr": followers_subscribers_arr
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#presenter_profile").html(data);
            var num_found = $("div#presenter_profile").find("div.profile").length;
            $("#result_found").text(num_found);
        }
    });     
});


//Suggestion filter

$("input.user_suggestion_group_id").live('click', function(){
   var category_arr = [];
   var sub_category_arr = [];
   var crowd_size_arr = [];
   var money_arr = [];
   var online_media_source_arr = [];
   var follow_sub_arr = [];
   $("ul#category_filter input.user_suggestion_group_id").each(function(){
       if($(this).is(':checked')){
           category_arr.push($(this).attr('data-val'));
       }
   });
   $("ul#sub_category_filter input.user_suggestion_group_id").each(function(){
       if($(this).is(':checked')){
           sub_category_arr.push($(this).attr('data-val'));
       }
   });   
   $("ul#crowd_size_filter input.user_suggestion_group_id").each(function(){
       if($(this).is(':checked')){
           crowd_size_arr.push($(this).attr('data-val'));
       }
   });
   $("ul#money_filter input.user_suggestion_group_id").each(function(){
       if($(this).is(':checked')){
           money_arr.push($(this).attr('data-val'));
       }
   });
   $("ul#media_source_filter input.user_suggestion_group_id").each(function(){
       if($(this).is(':checked')){
           online_media_source_arr.push($(this).attr('data-val'));
       }
   });
   $("ul#follow_sub_filter input.user_suggestion_group_id").each(function(){
       if($(this).is(':checked')){
           follow_sub_arr.push($(this).attr('data-val'));
       }
   });
   if(category_arr.length == 0){
       category_arr.push(-1);
   }
   if(sub_category_arr.length == 0){
       sub_category_arr.push(-1);
   }
   if(crowd_size_arr.length == 0){
       crowd_size_arr.push(-1);
   }
   if(money_arr.length == 0){
       money_arr.push(-1);
   }
   if(online_media_source_arr.length == 0){
       online_media_source_arr.push(-1);
   }
   if(follow_sub_arr.length == 0){
       follow_sub_arr.push(-1);
   }
   
    $.ajax({
        url: "search_suggestion_filter",
        type: "post",
        data: {
            "category_arr": category_arr,
            "sub_category_arr": sub_category_arr,
            "crowd_size_arr": crowd_size_arr,
            "money_arr": money_arr,
            "online_media_source_arr": online_media_source_arr,
            "follow_sub_arr": follow_sub_arr,
            "suggestion_user_id": $("input#suggestion_user_id").val(),
            "suggestion_type": $("input#suggestion_type").val()
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#all_suggestions").html(data);
            $("span#result_found").text($("div#searched_suggestion_div").length);
        }
    });     
});


$("input.suggestion_chk_valid_for").live('click', function(){
    if($(this).attr('data-val') == 'newly_posted'){
        if($(this).is(':checked')){
            $("input.chk_due_soon").attr('disabled', 'disabled');
        }else{
            $("input.chk_due_soon").removeAttr('disabled');
        }
    }else if($(this).attr('data-val') == 'due_soon'){
        if($(this).is(':checked')){
            $("input.chk_newly_posted").attr('disabled', 'disabled');
        }else{
            $("input.chk_newly_posted").removeAttr('disabled');
        }        
    }
    $.ajax({
        url: "search_suggestion_filter_by_valid_for",
        type: "post",
        data: {
            "valid_for": $(this).attr('data-val'),
            "suggestion_user_id": $("input#suggestion_user_id").val(),
            "suggestion_type": $("input#suggestion_type").val()
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#all_suggestions").html(data);
            $("span#result_found").text($("div#searched_suggestion_div").length);
        }
    });     
});

function suggestion_search_by_location(){
    var state = $("#suggestion_state").val();
    var city = $("#suggestion_city").val();
    if(state == ""){
        alert("Please select state.");
        return false;
    }
    if(city == ""){
        alert("Please select city.");
        return false;
    }
    $.ajax({
        url: "search_suggestion_filter_by_location",
        type: "post",
        data: {
            "state": state,
            "city": city,
            "suggestion_user_id": $("input#suggestion_user_id").val(),
            "suggestion_type": $("input#suggestion_type").val()
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#all_suggestions").html(data);
            $("span#result_found").text($("div#searched_suggestion_div").length);
        }
    });  
}


$("input#user_brand_interest_id, input#brand_demographic_age, input#brand_online_source, input#followers_subscribers").live('click', function(){
   var category_arr = [];
   var demographic_arr = [];
   var online_source_arr = [];
   var followers_subscribers_arr = [];
   $("input#user_brand_interest_id").each(function(){
       if($(this).is(':checked')){
           category_arr.push($(this).attr('data-val'));
       }
   });
   $("input#brand_demographic_age").each(function(){
       if($(this).is(':checked')){
           demographic_arr.push($(this).attr('data-val'));
       }
   });   
   $("input#brand_online_source").each(function(){
       if($(this).is(':checked')){
           online_source_arr.push($(this).attr('data-val'));
       }
   });   
   $("input#followers_subscribers").each(function(){
       if($(this).is(':checked')){
           followers_subscribers_arr.push($(this).attr('data-val'));
       }
   });   
   if(category_arr.length == 0){
       category_arr.push(-1);
   }
   if(demographic_arr.length == 0){
       demographic_arr.push(-1);
   }   
   if(online_source_arr.length == 0){
       online_source_arr.push(-1);
   }   
   if(followers_subscribers_arr.length == 0){
       followers_subscribers_arr.push(-1);
   }   
    $.ajax({
        url: "search_brand_filter",
        type: "post",
        data: {
            "category_arr": category_arr,
            "demographic_arr": demographic_arr,
            "online_source_arr": online_source_arr,
            "followers_subscribers_arr": followers_subscribers_arr
        },
        beforeSend: function() {
        },
        complete: function() {
        },
        success: function(data) {
            $("div#brand_profile").html(data);
            var num_found = $("div#brand_profile").find("div.profile").length;
            $("#result_found").text(num_found);
        }
    });     
});

$(".chk_all_category").live('click', function(){
    if($(this).is(':checked')){
        $("ul#category_filter").find("input[type='checkbox']").not('.chk_all_category').each(function(){
            console.log($(this));
            $(this).attr('checked', false);
            $(this).attr('disabled', 'disabled');
        });
    }else{
        $("ul#category_filter").find("input[type='checkbox']").not('.chk_all_category').each(function(){
            $(this).removeAttr('disabled');
        });        
    }
});

$(".chk_all_crowd_size").live('click', function(){
    if($(this).is(':checked')){
        $("ul#crowd_size_filter").find("input.chk_crowd_size").each(function(){
            $(this).attr('checked', false);
            $(this).attr('disabled', 'disabled');
        });
    }else{
        $("ul#crowd_size_filter").find("input.chk_crowd_size").each(function(){
            $(this).removeAttr('disabled');
        });        
    }
});

function delete_job_proposal(proposal_id){
    if(proposal_id == ""){
        alert("Proposal not found");
    }else{
        $.ajax({
            url: "delete_job_proposal",
            type: "post",
            dataType: "json",
            data: {
                "proposal_id": proposal_id
            },
            beforeSend: function() {
            },
            complete: function() {
            },
            success: function(data) {
                $('li#li_proposal_'+proposal_id).remove();
                $("#myModalDelete").find("#btn_close").click();
            }
        });   
    }
}
function show_approve_popup(is_approved){
    if(is_approved == ""){
        alert("Proposal not found");
    }else{
        $.ajax({
            url: "show_approve_popup",
            type: "post",
            dataType: "json",
            data: {
            },
            beforeSend: function() {
            },
            complete: function() {
            },
            success: function(data) {
                $('li#li_proposal_'+proposal_id).remove();
                $("#myModalAppPopup").find("#btn_close").click();
            }
        });   
    }
}

function delete_suggestion_proposal(proposal_id){
    if(proposal_id == ""){
        alert("Proposal not found");
    }else{
        $.ajax({
            url: "delete_suggestion_proposal",
            type: "post",
            dataType: "json",
            data: {
                "proposal_id": proposal_id
            },
            beforeSend: function() {
            },
            complete: function() {
            },
            success: function(data) {
                $('li#li_proposal_'+proposal_id).remove();
                $("#myModalDelete").find("#btn_close").click();
            }
        });   
    }
}

function delete_jobs(job_id){
    if(job_id == ""){
        alert("Job not found");
    }else{
        $.ajax({
            url: "delete_job",
            type: "post",
            dataType: "json",
            data: {
                "job_id": job_id
            },
            beforeSend: function() {
            },
            complete: function() {
            },
            success: function(data) {
                $('li#li_job_'+job_id).remove();
                $("#myModalDelete").find("#btn_close").click();
                
            }
        });   
    }
}

function delete_suggestion(suggestion_id){
    if(suggestion_id == ""){
        alert("Brandslip suggestion not found");
    }else{
        $.ajax({
            url: "delete_suggestion",
            type: "post",
            dataType: "json",
            data: {
                "suggestion_id": suggestion_id
            },
            beforeSend: function() {
            },
            complete: function() {
            },
            success: function(data) {
                $('li#li_suggestion_'+suggestion_id).remove();
                $("#myModalDelete").find("#btn_close").click();
                
            }
        });   
    }
}

function add_newsfeed(){
    if($("#newsfeed_description").val() == ""){
        alert("Please enter newsfeed description.");
    }else{
            $.ajax({
                url: "add_newsfeed",
                type: "post",
                dataType: "json",
                data: {
                    "newsfeed_desc": $("#newsfeed_description").val()
                },
                beforeSend: function() {
                    $("#newsfeed_add_ajaxloading").css("display", "inline-block");
                },
                complete: function() {
                    $("#newsfeed_add_ajaxloading").css("display", "none");
                },
                success: function(data) {
                    $("#newsfeed_add_success_msg").text("Newsfeed added successfully.");
                }
            });           
    }
}

function populate_cities(ctrl, target_id){
    var state = $(ctrl).val();
    if(state != ""){
            $.ajax({
                url: "/jobs/get_cities",
                type: "post",
                dataType: "json",
                data: {
                    "state": state
                },
                beforeSend: function() {
                },
                complete: function() {
                },
                success: function(data) {
                    $("#"+target_id).find("option:gt(0)").remove();
                    for (var index = 0; index < data['matched_cities'].length; index++) {

                        $("#"+target_id).append($("<option/>", {
                                                    value: data['matched_cities'][index]['city'],
                                                    text: data['matched_cities'][index]['city']
                                                }));
                    }                    
                }
            });          
    }
}

$("#myModal #msg_user_interest").live("change", function(){
    if($(this).val() != ""){
            $.ajax({
                url: "get_users_to_msg",
                type: "post",
                dataType: "json",
                data: {
                    "interest": $(this).val()
                },
                beforeSend: function() {
                },
                complete: function() {
                },
                success: function(data) {
                    $("#myModal #to_user").find("option:gt(0)").remove();
                    for (var index = 0; index < data['matched_users'].length; index++) {

                        $("#myModal #to_user").append($("<option/>", {
                                                    value: data['matched_users'][index]['id'],
                                                    text: data['matched_users'][index]['first_name'] +' ' + data['matched_users'][index]['last_name']
                                                }));
                    }                    
                }
            });         
    }
});

function send_message(){
    var from_user_id = $("#from_user").val();
    var to_user_id = $("#to_user").val();
    var message_title = $("#myModal .message_title").val();
    var message_body = $("#myModal .message_body").val();
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
                "message_body": message_body
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

function declined_bid(bid_id){
    if(bid_id == ""){
        
    }else{
        $.ajax({
            url: "/delete_bid",
            type: "post",
            dataType: 'json',
            data: {
                "bid_id": bid_id
            },
            beforeSend: function() {
                $("body").css("cursor", "progress");
            },
            complete: function() {
                $("body").css("cursor", "auto");
            },
            success: function() {
                $("#div_bid_"+bid_id).remove();
                $("#myModalAcceptDecline").find("#btn_close").click();
            }
        });        
    }    
}

function accept_bid(bid_id){
    $("#myModalAcceptDecline").find("#btn_close").click();
    if(bid_id == ""){
        
    }else{
        $.ajax({
            url: "/accept_bid",
            type: "post",
            data: {
                "bid_id": bid_id,
                "job_id": $("#hdn_job_id").val()
            },
            beforeSend: function() {
                $("body").css("cursor", "progress");
            },
            complete: function() {
                $("body").css("cursor", "auto");
            },
            success: function(html) {
                $("div#brands_bid").html(html);
            }
        });        
    }     
}

function declined_suggestion_bid(bid_id){
    if(bid_id == ""){
        
    }else{
        $.ajax({
            url: "/delete_suggestion_bid",
            type: "post",
            dataType: 'json',
            data: {
                "bid_id": bid_id
            },
            beforeSend: function() {
                $("body").css("cursor", "progress");
            },
            complete: function() {
                $("body").css("cursor", "auto");
            },
            success: function() {
                $("#div_bid_"+bid_id).remove();
                $("#myModalAcceptDecline").find("#btn_close").click();
            }
        });        
    }    
}

function accept_suggestion_bid(bid_id){
    $("#myModalAcceptDecline").find("#btn_close").click();
    if(bid_id == ""){
        
    }else{
        $.ajax({
            url: "/accept_suggestion_bid",
            type: "post",
            data: {
                "bid_id": bid_id,
                "suggestion_id": $("#hdn_suggestion_id").val()
            },
            beforeSend: function() {
                $("body").css("cursor", "progress");
            },
            complete: function() {
                $("body").css("cursor", "auto");
            },
            success: function(html) {
                $("div#presenters_bid").html(html);
            }
        });        
    }     
}

function show_delete_jobs_popup(job_id){
    $("#myModalDelete").find(".modal-title").text("Delete Brandslip");
    $("#myModalDelete").find(".modal-body").text("Are you sure you want to delete this job?");
    var onclick_string = "delete_jobs("+job_id+")";
    $("#myModalDelete").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function show_delete_suggestion_popup(suggestion_id){
    $("#myModalDelete").find(".modal-title").text("Delete Brandslip Suggestion");
    $("#myModalDelete").find(".modal-body").text("Are you sure you want to delete this suggestion?");
    var onclick_string = "delete_suggestion("+suggestion_id+")";
    $("#myModalDelete").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function show_delete_proposal_popup(proposal_id){
    $("#myModalDelete").find(".modal-title").text("Delete Bid");
    $("#myModalDelete").find(".modal-body").text("Are you sure you want to delete this bid?");
    var onclick_string = "delete_job_proposal("+proposal_id+")";
    $("#myModalDelete").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function show_approve_popup(){
    $("#myModalAppPopup").find(".modal-title").text("Delete Bid");
    $("#myModalAppPopup").find(".modal-body").text("Please wait till admin approves.");
    var onclick_string = "show_approve_popup()";
    $("#myModalAppPopup").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function show_delete_suggestion_proposal_popup(proposal_id){
    $("#myModalDelete").find(".modal-title").text("Delete Suggestion Bid");
    $("#myModalDelete").find(".modal-body").text("Are you sure you want to delete this bid?");
    var onclick_string = "delete_suggestion_proposal("+proposal_id+")";
    $("#myModalDelete").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function show_delete_msg_popup(msg_id){
    $("#myModalDelete").find(".modal-title").text("Delete Message");
    $("#myModalDelete").find(".modal-body").text("Are you sure you want to delete this Message?");
    var onclick_string = "delete_selected_messages("+msg_id+")";
    $("#myModalDelete").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function show_delete_sent_msg_popup(msg_id){
    $("#myModalDelete").find(".modal-title").text("Delete Message");
    $("#myModalDelete").find(".modal-body").text("Are you sure you want to delete this Message?");
    var onclick_string = "delete_selected_sent_messages("+msg_id+")";
    $("#myModalDelete").find("#btn_delete_yes").attr("onclick", onclick_string);
}

$('#user_job_proposal_proposal_cost').live("keyup", function(){
    var value=$(this).val();
    value=value.replace(/([^0-9\.].*)/g, "");
    $(this).val(value);
});

$('#job_job_price_fixed_type').live("keyup", function(){
    var value=$(this).val();
    value=value.replace(/([^0-9\.].*)/g, "");
    $(this).val(value);
});

$('#brandslip_suggestion_price').live("keyup", function(){
    var value=$(this).val();
    value=value.replace(/([^0-9\.].*)/g, "");
    $(this).val(value);
});

$('#user_suggestion_proposal_proposal_cost').live("keyup", function(){
    var value=$(this).val();
    value=value.replace(/([^0-9\.].*)/g, "");
    $(this).val(value);
});

function show_accept_bid_popup(proposal_id){
    $("#myModalAcceptDecline").find(".modal-title").text("Accept Bid");
    $("#myModalAcceptDecline").find(".modal-body").text("Are you sure you want to accept this Bid?");
    var onclick_string = "accept_bid("+proposal_id+")";
    $("#myModalAcceptDecline").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function show_decline_bid_popup(proposal_id){
    $("#myModalAcceptDecline").find(".modal-title").text("Decline Bid");
    $("#myModalAcceptDecline").find(".modal-body").text("Are you sure you want to decline this Bid?");
    var onclick_string = "declined_bid("+proposal_id+")";
    $("#myModalAcceptDecline").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function show_accept_suggestion_bid_popup(proposal_id){
    $("#myModalAcceptDecline").find(".modal-title").text("Accept Bid");
    $("#myModalAcceptDecline").find(".modal-body").text("Are you sure you want to accept this Bid?");
    var onclick_string = "accept_suggestion_bid("+proposal_id+")";
    $("#myModalAcceptDecline").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function show_decline_suggestion_bid_popup(proposal_id){
    $("#myModalAcceptDecline").find(".modal-title").text("Decline Bid");
    $("#myModalAcceptDecline").find(".modal-body").text("Are you sure you want to decline this Bid?");
    var onclick_string = "declined_suggestion_bid("+proposal_id+")";
    $("#myModalAcceptDecline").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function show_delete_post_popup(post_id){
    $("#myModalDeletePost").find(".modal-title").text("Delete Post");
    $("#myModalDeletePost").find(".modal-body").text("Are you sure you want to delete this post?");
    var onclick_string = "delete_post("+post_id+")";
    $("#myModalDeletePost").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function delete_post(post_id){
    if(post_id != ""){
        $.ajax({
            url: "/delete_post",
            type: "post",
            dataType: 'json',
            data: {
                "post_id": post_id
            },
            beforeSend: function() {

            },
            complete: function() {
   
            },
            success: function() {
               $("div#your_post_"+post_id).remove();
                $("#myModalDeletePost").find("#btn_close").click();
            }
        });        
    }     
}

function j_save_as_interested(ctrl){
    var job_id = $(ctrl).attr('data-job-id');
    if(job_id != ""){
        $.ajax({
            url: "j_save_as_interested",
            type: "post",
            dataType: 'json',
            data: {
                "job_id": job_id
            },
            beforeSend: function() {

            },
            complete: function() {
   
            },
            success: function() {
              $(ctrl).attr('value', 'Remove from Interested');
              $(ctrl).attr('onclick', "j_remove_from_interested(this)");
            }
        });     
    }
}

function j_remove_from_interested(ctrl){
    var job_id = $(ctrl).attr('data-job-id');
    if(job_id != ""){
        $.ajax({
            url: "j_remove_from_interested",
            type: "post",
            dataType: 'json',
            data: {
                "job_id": job_id
            },
            beforeSend: function() {

            },
            complete: function() {
   
            },
            success: function() {
              $(ctrl).attr('value', 'Save as Interested');
              $(ctrl).attr('onclick', "j_save_as_interested(this)");
            }
        });     
    }
}

function s_save_as_interested(ctrl){
    var suggestion_id = $(ctrl).attr('data-suggestion-id');
    if(suggestion_id != ""){
        $.ajax({
            url: "s_save_as_interested",
            type: "post",
            dataType: 'json',
            data: {
                "suggestion_id": suggestion_id
            },
            beforeSend: function() {

            },
            complete: function() {
   
            },
            success: function() {
              $(ctrl).attr('value', 'Remove from Interested');
              $(ctrl).attr('onclick', "s_remove_from_interested(this)");
            }
        });     
    }
}

function s_remove_from_interested(ctrl){
    var suggestion_id = $(ctrl).attr('data-suggestion-id');
    if(suggestion_id != ""){
        $.ajax({
            url: "s_remove_from_interested",
            type: "post",
            dataType: 'json',
            data: {
                "suggestion_id": suggestion_id
            },
            beforeSend: function() {

            },
            complete: function() {
   
            },
            success: function() {
              $(ctrl).attr('value', 'Save as Interested');
              $(ctrl).attr('onclick', "s_save_as_interested(this)");
            }
        });     
    }
}



function delete_interest_brandslip(job_id){
    if(job_id == ""){
        alert("Interest not found");
    }else{
        $.ajax({
            url: "delete_interest_brandslip",
            type: "post",
            dataType: "json",
            data: {
                "job_id": job_id
            },
            beforeSend: function() {
            },
            complete: function() {
            },
            success: function(data) {
                $('li#btn_delete_yes'+job_id).remove();
                $("#myModalDelete").find("#btn_close").click();
            }
        });     
    }
}
function delete_interest_suggestion(suggestion_id){
    if(suggestion_id == ""){
        alert("Interest not found");
    }else{
        $.ajax({
            url: "delete_interest_suggestion",
            type: "post",
            dataType: "json",
            data: {
                "suggestion_id": suggestion_id
            },
            beforeSend: function() {
            },
            complete: function() {
            },
            success: function(data) {
                $('li#btn_delete_yes'+suggestion_id).remove();
                $("#myModalDelete").find("#btn_close").click();
            }
        });     
    }
}

function show_delete_interested_suggestion_popup(suggestion_id){
    var onclick_string = "delete_interest_suggestion("+suggestion_id+")";
    $("#myModalDelete").find("#btn_delete_yes").attr("onclick", onclick_string);
}

function show_delete_interested_brandslip_popup(job_id){
    var onclick_string = "delete_interest_brandslip("+job_id+")";
    $("#myModalDelete").find("#btn_delete_yes").attr("onclick", onclick_string);
}

