// Newsletter form functionality
(function() {
  const form = document.querySelector('.embeddable-buttondown-form');
  if (form) {
    form.addEventListener('submit', function() {
      window.open('https://buttondown.com/chrisguimarin', 'popupwindow');
      return true;
    });
  }
})();
