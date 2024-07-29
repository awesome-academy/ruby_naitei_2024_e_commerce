document.addEventListener('turbo:load', function() {
  let description = document.querySelector('#about-description');
  description.addEventListener('click', function(event) {
    event.preventDefault();
    document.querySelector('#comments').classList.remove('active');
    document.querySelector('#description').classList.toggle('active');
  });
});
