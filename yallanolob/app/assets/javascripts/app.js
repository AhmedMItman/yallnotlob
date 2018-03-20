function error(msg){
	$('.success').hide();
	$('.error').show();
	$('.error').text(msg);
}

function success(msg){
	$('.error').hide();
	$('.success').show();
	$('.success').text(msg);
}

function updateNotificationsCounter(){
    msgsNum = $('.msgs-container').children().length
    if (msgsNum > 0) {
        $('.noitfications-counter').text(msgsNum).show()
    }
}

$(document).ready(function(){
    updateNotificationsCounter();
});

$('.btn-edit').on('click',function(){
	$('.grp-input').hide();
	$('.grp-controls').show();
	$(this).parent().hide();

	$(this).parent().next().show()
	input = $(this).parent().next().children().first().children().first()
	// input.focusout(function(){
	// 	$('.grp-input').hide();
	// 	$('.grp-controls').show();
	// })
	inputText = input.val(); // set cursor to the end
	input.val('');  // set cursor to the end
	input.focus().val(inputText);  // set cursor to the end

});

$('.btn-close').click(function(){
	$('.grp-input').hide();
	$('.grp-controls').show();
})

$('.save-btn').click(function(){
	// token = $('meta[name="csrf-token"]').attr('content');
	// console.log($(this))
	// console.log($('meta[name="csrf-token"]'))
	id = $(this).attr('grpid');
	form = $(this).parent().prev();
	data = form.serialize();
	text = form.children().first().val();
	$(this).parent().parent().prev().children().last().text(text)

	$.post("/groups/"+id, data , function(data, status){
	    $('.grp-input').hide();
	    $('.grp-controls').show();
	    success('the group has updated successfully!')
	});

})

$('.btn-remove').click(function(){
	id = $(this).attr('grpid');
	token = $('meta[name="csrf-token"]').attr('content');
	// if ($("#grps-list").children().length == 0) {
	// 	$("#grps-list").html('dfdf')
	// }
	$.post("/groups/"+id, {authenticity_token:token, _method:'delete'});
	$(this).parent().parent().remove();
	success('The group has deleted successfully!')
})

$('.rmv-frnd').click(function(){
	user_id = $(this).attr('usrid');
	group_id = $('#grpname').attr('grpid');
	token = $('meta[name="csrf-token"]').attr('content');
	self = $(this)

	// if ($("#grps-list").children().length == 0) {
	// 	$("#grps-list").html('dfdf')
	// }
	$.post("/remove_friend_from_group", {authenticity_token:token, user_id:user_id, group_id:group_id}, function(data, status){
		self.parent().parent().remove()
		success("The user has removed successfully from the group!")
	});
	// $(this).parent().parent().remove();
	// success('The group has deleted successfully!')
})

$('#add-frnd').click(function(){
	token = $('meta[name="csrf-token"]').attr('content');
	group_id = $('#grpname').attr('grpid');
	current_user_id = $('#usr-id').text();
	email = $('#frnd-email').val();

	if ($('#frnd-email').val().trim().length == 0) {
		error('The e-mail field can not be empty!')
		return false;
	}

	$.post("/add_friend_to_group", {authenticity_token:token, group_id:group_id, email:email, user_id:current_user_id}, function(data, status){
		console.log(data)
		if (data.error == null) {
			$('.btn-add[grpid="' + group_id + '"]').trigger('click')
			success('Your friend has added successfully to your group !')
		}else{
			error(data.error)
		}
		// if (typeof(data.error) !== 'undefined') {

		// console.log(data.error)
		// }else{
		// 	console.log('no error')
		// }
		// self.parent().parent().remove()
		// success("The user has removed successfully from the group!")

	});
});


$('.btn-add').click(function(){
	id = $(this).attr('grpid');
	token = $('meta[name="csrf-token"]').attr('content');
	$('#grpname').text($(this).next().text())
	$('#grpname').show()
	$('#grp-pnl').show()
	$('#grpname').attr('grpid', id)
	$.get("/groupfriends", {id:id}, function(data, status){
		// console.log(data);
		$('.frnds-row').html('');
		for (var user in data)
		{
			var item = $('.user-thumb').first().clone(true, true);
			$('.frnds-row').append(item)
			$('.rmv-frnd').last().attr('usrid', data[user][0])
			$('.usr-name').last().text(data[user][1])
			$('.frnd-img').last().attr('src', data[user][2]);
			$('.user-thumb').last().show()



			// console.log(data[user][1])
			// console.log()
		    // Do something
		}
	});

	// if ($("#grps-list").children().length == 0) {
	// 	$("#grps-list").html('dfdf')
	// }
	// $.post("/groups/"+id, {authenticity_token:token, _method:'delete'});
	// $(this).parent().parent().remove();
	// success('The group has deleted successfully!')
})

$('.new-grp-btn').click(function(){
	if($('.add-grp-txt').val().trim().length == 0) { // zero-length string AFTER a trim
		error("You can't add an empty group");
		$('.add-grp-txt').focus();
	}else{
		token = $('meta[name="csrf-token"]').attr('content');
		name = $('.add-grp-txt').val();
		id = $('#usr-id').text();

		var item = $('.list-grp').first().clone(true, true);

		console.log($('.grp-name'))

		$.post("/groups/", {authenticity_token:token, name:name, user_id:id } , function(data, status){
			grpid = data.id
			$('#grps-list').append(item)
			$('.grp-name').last().text(name)
			$('.grp-val').last().val(name)
			$('.rmv-id').last().attr("grpid",grpid);
			$('.add-id').last().attr("grpid",grpid);
			$('.save-id').last().attr("grpid",grpid);
			$('.list-grp').last().removeClass('hidden')
			$('.add-grp-txt').val('').focus();
			success("The group " + name + " has created successfully!")
			console.log(data)
		});
	}
});

$('#addItemForm').on('submit',function (e) {
    e.preventDefault()
    $.ajax({
        url: '/items/new',
        type:'get',
        data : { item_user_id:$("#item_user_id").val(),
				order_user_id:$("#order_user_id").val(),
				item_name:$("#item_name").val()
        ,item_quantity:$("#item_quantity").val(),
				item_price:$("#item_price").val(),item_comment:$("#item_comment").val()},
        success :function (r) {
            $("#ItemsTable tbody").append("<tr><td>"+$("#order_user_name").val()+"</td><td>"+$("#item_name").val()+"</td><td>"+$("#item_quantity").val()+"</td><td>"+$("#item_price").val()+"</td><td>"+$("#item_comment").val()+"</td><td><a>Delete</a></td></tr>")
            // var el = document.createElement('td')
            // var ela = document.createElement('a')
            // el.setAttribute('onclick',"deleteItem")
            // ela.textContent='Delete'
            // el.append(ela)
            // $("#ItemsTable tbody").append(el)
            // success("Your Item Has been Added")
        }
    })
})

$("#ItemsTable").on('click',"a",function (e) {
    e.preventDefault()
    //     //console.log($('meta[name="csrf-token"]').attr("content"))
    $(this).parent().parent().remove();
    //alert(($(this).parent().parent().attr('itemid')))
    itemId =($(this).parent().parent().attr('itemid'))
    token = $('meta[name="csrf-token"]').attr('content');
    $.ajax({
        url: '/items/'+itemId,
        type:'delete',
        data : {authenticity_token:token},
        success :function (r) {
            error("Your Item has been deleted Now :(")
        },
        error : function (r) {
            error("There is a problem")

        }
    })
})

// $(".deleteItem").on('click',function (e) {
//     //console.log($('meta[name="csrf-token"]').attr("content"))
//     $(this).parent().remove();
//     itemId =($(this).parent().attr('itemid'))
//     token = $('meta[name="csrf-token"]').attr('content');
//     $.ajax({
//         url: '/items/'+itemId,
//         type:'delete',
//         data : {authenticity_token:token},
//         success :function (r) {
//             error("Your Item has been deleted Now :(")
//         },
//         error : function (r) {
//             error("There is a problem")
//
//         }
//     })
// });
$("#AddNewOrder").on('click',function (e) {
    e.preventDefault();
    if ( $("#order_resturant").val() != "" ) {
        //console.log($("#friendName").val())
        var friendsOrder = $('input:checkbox:checked')
        var allFriendsOrder = []
        for (var i = 0; i < friendsOrder.length; i++) {
            allFriendsOrder[i] = friendsOrder[i].value
            console.log(allFriendsOrder[i])
        }

        token = $('meta[name="csrf-token"]').attr('content');

        $.ajax({

            url: '/orders',
            type: 'post',
            data: {
                authenticity_token: token,
                order_allFriends: allFriendsOrder,
                order_resturant: $("#order_resturant").val(),
                order_menu: $("#order_menu").val(),
                order_typ: $("#order_typ").val(),
                order_statu: $("#order_statu").val(),
                order_user_id: $("#order_user_id").val(),
                order_friendName: $("#order_friendName").val()
            },
            success: function (res) {

                console.log("yeahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh")
                success("the order has Created successfully!")
                // console.log(res.friendsOfGroup)
                for(var i = 0 ; i < res.friendsOfGroup.length;i++)
                {

                    var eleLi = document.createElement("li")
                    eleLi.setAttribute("id",$(this).parent().attr("friendEmail"))
                    var eleImg = document.createElement("img")
                    var eleText = document.createTextNode(res.friendsOfGroup[i].name)
                    eleImg.src=res.friendsOfGroup[i].image
                    eleImg.style.width="80px"
                    eleImg.style.height="80px"
                    eleLi.appendChild(eleText)
                    eleLi.appendChild(eleImg)
                    $("#showFriends ul").append(eleLi)

                }

            },

            error: function (res) {
                error("There is a problem ! :)")
            }

        });
    }
    else
    {
        error("You should Enter Resturant Name")
    }

});

$(".myFriendSelect").on('click',function (e) {

    if (!$(this).prop('checked'))
    {
         var el = $(this).parent().attr("friendEmail")
        var ele = document.getElementById(el)
        ele.remove()
    }
    else
    {
        var eleLi = document.createElement("li")
        eleLi.setAttribute("id",$(this).parent().attr("friendEmail"))
        var eleImg = document.createElement("img")
        var eleText = document.createTextNode($(this).parent().attr("friendname"))
        eleImg.src=$(this).parent().attr("friendimg")
        eleImg.style.width="80px"
        eleImg.style.height="80px"
        eleLi.appendChild(eleText)
        eleLi.appendChild(eleImg)
        $("#showFriends ul").append(eleLi)
    }

})

$(".DeleteOrder").on('click',function (e) {
    e.preventDefault()
        //console.log($("#whichOrder")[0].value)
    token = $('meta[name="csrf-token"]').attr('content');
    id= $(this).attr("to")
    $(this).parent().remove()
    $.ajax({
        url: '/orders/'+id,
        type:'delete',
        data : {authenticity_token:token},
        success :function (r) {
            error("Your Order has been deleted Now :(")

        },
        error:function (res) {
            error("There is a problem")
        }

    })
});

function setNotification(type, text, order_id, date, user_image = "/images/unknown.jpg"){
	var item = $('.notification').last().clone(true, true);
	$('.msgs-container').prepend(item)
	$('.notification-img').first().attr('src', user_image)
	$('.notification-text').first().text(text)
	$('.notification-date').first().text(date)
	if (type == 'join') {
		$('.notification-link').first().text('Join')
		$('.notification-link').first().addClass('notification-join')
	}else if(type == 'invite'){
		$('.notification-link').first().text('Join')
		$('.notification-link').first().addClass('notification-invite')
		$('.notification-link').first().attr('href', '/orders/' + order_id)
	}else if(type == 'finished'){
		$('.notification-link').first().text('Order')
		$('.notification-link').first().remove()
	}else if(type == 'cancel'){
		$('.notification-link').first().text('Order')
		$('.notification-link').first().remove()
	}else if(type == 'orderOwner'){
		$('.notification-link').first().text('View')
		$('.notification-link').first().addClass('notification-invite')
		$('.notification-link').first().attr('href', '/orders/' + order_id)
	}else{
		console.error('Notification type must be either "invite" or "join".')
	}

	$('.notification-link').first().attr('orderid', order_id)
	$('.notification').first().removeClass('hidden')
    updateNotificationsCounter();
}

// type (str) => invite/join
// setNotification("invite", "Hamada joined your breakfast", 15, "23-02-2018 7:30 PM", "/images/unknown.jpg")
// setNotification("join", "Hamada joined your breakfast", 16, "23-02-2018 7:30 PM", "/images/unknown.jpg")
// setNotification("join", "Hamada joined your breakfast", 17, "23-02-2018 7:30 PM", "/images/unknown.jpg")
// setNotification("invite", "Hamada joined your breakfast", 1, "23-02-2018 7:30 PM", "/images/unknown.jpg")

function changeJoinNumber(order_id){
	$("#join"+order_id).text("")
}
$('.notification-join').click(function(e){
    e.preventDefault();
    order_id = $(this).attr('orderid');
    user_id = $('#usr-id').text();
		$.ajax({url: "/orders/" + order_id,
				success: function(result){
					// get invited users
					// insert joied notifications (add new notification -> users_notification)
					// send notifications to users using action cable
					//userjoin

						// id = $(this).attr('grpid');
	token = $('meta[name="csrf-token"]').attr('content');
	// if ($("#grps-list").children().length == 0) {
	// 	$("#grps-list").html('dfdf')
	// }
	// $.post("/groups/"+id, {authenticity_token:token, _method:'delete'});

						$.post("/userjoin/", {authenticity_token:token, order_id:order_id, user_id: user_id} , function(data, status){
							console.log(data)
					    // success('the group has updated successfully!')
						});
					//window.location.href = "/orders/" + order_id;
		    },
				error: function(jqXHR, textStatus, errorThrown) {
		  		error("Error : This order has been canceled!");
				}
		 });
    console.log('Order ID : ', order_id, 'User ID: ', user_id)
})

$(".finishOrder").on('click',function (e) {
    // alert($(this).attr("to"))

    id = $(this).attr("to") ;
    token = $('meta[name="csrf-token"]').attr('content');
    $(this).parent()[0].childNodes[5].textContent="Finished"
    $(this).next().remove()
     $(this).remove()
    //console.log($(this).next())
    $.ajax({
        url: /orders/+id,
        type:'put',
        data:{authenticity_token:token,id:id},
        success :function (r) {

            success("Your Order has been Finished Now")


        },
        error:function (res) {
            error("There is a problem")
        }

    })

})

$(".deleteFriend").on('click',function (e) {
    e.preventDefault()
    $(this).parent().remove()
    token = $('meta[name="csrf-token"]').attr('content');
    var id = $(this).attr("to")
    $.ajax({
        url:'/friendships/'+id,
        type: 'delete',
        data : {authenticity_token:token,id:id},
        success :function (res) {
            error("S/He is not Friend from Now :(")

        },
        error:function (res) {
            error('There is a problem')
        }
    })
})

function takeIDFromNotification( index,whichAction)
{
	if(whichAction == "finished" )
	$("#"+index).text("Finished")
	else if(whichAction=="cancel")
	{
			$("#"+index).parent().remove()
	}
	console.log($("#"+index))

}

takeIDFromNotification(158)
