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
})

$('.new-grp-btn').click(function(){

	token = $('meta[name="csrf-token"]').attr('content');
	name = $('.add-grp-txt').val();
	id = 1
	var item = $('.list-grp').first().clone(true, true);
	$('#grps-list').append(item)
	$('.grp-name').last().text(name)
	$('.grp-val').last().val(name)
	$('.add-grp-txt').val('').focus();

	console.log($('.grp-name'))

	// $.post("/groups/", {authenticity_token:token, name:name, user_id:id } , function(data, status){
	// 	console.log(data)
	// });


})

$('#addItemForm').on('submit',function (e) {
    e.preventDefault()
    $.ajax({
        url: '/items/new',
        type:'get',
        data : { item_user_id:$("#item_user_id").val(),order_user_id:$("#order_user_id").val(),item_name:$("#item_name").val()
        ,item_quantity:$("#item_quantity").val(),item_price:$("#item_price").val(),item_comment:$("#item_comment").val()},
        success :function (r) {
            $("#ItemsTable tbody").append("<tr><td>"+$("#item_name").val()+"</td><td>"+$("#item_quantity").val()+"</td><td>"+$("#item_price").val()+"</td><td>"+$("#item_comment").val()+"</td></tr>")
        }
    })
})

$(".deleteItem").on('click',function (e) {
    //console.log($('meta[name="csrf-token"]').attr("content"))
    $(this).parent().remove();
    itemId =($(this).parent().attr('itemid'))
    token = $('meta[name="csrf-token"]').attr('content');
    $.ajax({
        url: '/items/'+itemId,
        type:'delete',
        data : {authenticity_token:token},
        success :function (r) {
        }
    })
});
$("#AddNewOrder").on('click',function (e) {
    e.preventDefault();
    //console.log($("#friendName").val())
    var friendsOrder = $('input:checkbox:checked')
    var allFriendsOrder = []
    for (var i = 0 ;  i < friendsOrder.length ; i++)
    {
        allFriendsOrder[i]=friendsOrder[i].value
        console.log(allFriendsOrder[i])
    }

    token = $('meta[name="csrf-token"]').attr('content');

    $.ajax({

        url:'/orders',
        type:'post',
        data:{authenticity_token:token,order_allFriends:allFriendsOrder,order_resturant:$("#order_resturant").val(),order_menu:$("#order_menu").val(),order_typ:$("#order_typ").val(),order_statu:$("#order_statu").val(),order_user_id:$("#order_user_id").val(),order_friendName:$("#order_friendName").val()},
        success : function (res) {
         console.log("yeahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh")
        }

    });

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
    id=$("#whichOrder")[0].value
    $(this).parent().parent().remove()
    $.ajax({
        url: '/orders/'+id,
        type:'delete',
        data : {authenticity_token:token},
        success :function (r) {
        console.log('yeeeeeeah')

        }

    })
});
