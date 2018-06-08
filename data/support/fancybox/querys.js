// JavaScript Document
$(function() {
    $(".bititles").on('click', function() {
        $(this).parent().next(".quireset").slideToggle();
    });
})

$(document).ready(function(){
    $(".btn1").click(function(){
        $(".quireset").hide(400);
    });
    $(".btn2").click(function(){
        $(".quireset").show(400);
    });
});