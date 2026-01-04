// Newsletter form functionality with rate limiting
(function() {
  const form = document.querySelector('.embeddable-buttondown-form');
  if (!form) return;

  const RATE_LIMIT_KEY = 'newsletter_last_submit';
  const RATE_LIMIT_MS = 60000; // 1 minute

  form.addEventListener('submit', function(e) {
    // Check rate limit
    const lastSubmit = localStorage.getItem(RATE_LIMIT_KEY);
    const now = Date.now();

    if (lastSubmit) {
      const timeSinceLastSubmit = now - parseInt(lastSubmit);
      if (timeSinceLastSubmit < RATE_LIMIT_MS) {
        e.preventDefault();
        const remainingSeconds = Math.ceil((RATE_LIMIT_MS - timeSinceLastSubmit) / 1000);
        alert(`Please wait ${remainingSeconds} seconds before submitting again.`);
        return false;
      }
    }

    // Store submit time
    localStorage.setItem(RATE_LIMIT_KEY, now.toString());

    // Open popup window
    window.open('https://buttondown.com/chrisguimarin', 'popupwindow');
    return true;
  });
})();
