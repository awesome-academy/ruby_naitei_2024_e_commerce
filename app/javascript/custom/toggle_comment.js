document.addEventListener('turbo:load', function() {
  let comment = document.querySelector('#about-comment');
  comment.addEventListener('click', function(event) {
    event.preventDefault();
    document.querySelector('#comments').classList.toggle('active');
    document.querySelector('#description').classList.remove('active');
  });
});
