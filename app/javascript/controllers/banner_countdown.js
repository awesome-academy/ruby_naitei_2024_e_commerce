$(document).ready(function() {
  var targetDate = new Date("Aug 30, 2024 23:59:59").getTime();

  var countdownInterval = setInterval(function() {
    var currentDate = new Date().getTime();
    var timeLeft = targetDate - currentDate;

    var days = Math.floor(timeLeft / (1000 * 60 * 60 * 24));
    var hours = Math.floor((timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    var minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
    var seconds = Math.floor((timeLeft % (1000 * 60)) / 1000);

    $("#days").text(days);
    $("#hours").text(hours);
    $("#minutes").text(minutes);
    $("#seconds").text(seconds);

    if (timeLeft <= 0) {
      clearInterval(countdownInterval);
      $("#days").text(0);
      $("#hours").text(0);
      $("#minutes").text(0);
      $("#seconds").text(0);
    }
  }, 1000);
});
