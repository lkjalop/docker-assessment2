// Please see documentation at https://docs.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Write your JavaScript code.
$(document).ready(function () {
    // Add any custom JavaScript here
    console.log('Docker Assessment MVC App loaded successfully!');
    
    // Add hover effects to cards
    $('.card').hover(
        function () {
            $(this).addClass('shadow-sm');
        },
        function () {
            $(this).removeClass('shadow-sm');
        }
    );
});
