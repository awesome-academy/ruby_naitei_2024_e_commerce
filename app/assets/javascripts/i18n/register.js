document.addEventListener("DOMContentLoaded", function() {
  document.querySelector('.js-RegisterModal').addEventListener('submit', function(event) {
    alert('<%= j t("sign_up.check_email") %>');
  });
});
