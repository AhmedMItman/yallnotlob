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