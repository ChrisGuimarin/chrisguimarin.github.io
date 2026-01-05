// Newsletter form functionality with AJAX submission
(function() {
  const form = document.querySelector('.embeddable-buttondown-form');
  if (!form) return;

  const RATE_LIMIT_KEY = 'newsletter_last_submit';
  const RATE_LIMIT_MS = 60000; // 1 minute

  // Create message container if it doesn't exist
  let messageContainer = form.querySelector('.newsletter-message');
  if (!messageContainer) {
    messageContainer = document.createElement('div');
    messageContainer.className = 'newsletter-message';
    messageContainer.setAttribute('role', 'status');
    messageContainer.setAttribute('aria-live', 'polite');
    form.appendChild(messageContainer);
  }

  function showMessage(text, type) {
    messageContainer.textContent = text;
    messageContainer.className = `newsletter-message newsletter-message--${type}`;
    messageContainer.style.display = 'block';
  }

  function hideMessage() {
    messageContainer.style.display = 'none';
    messageContainer.textContent = '';
    messageContainer.className = 'newsletter-message';
  }

  form.addEventListener('submit', function(e) {
    e.preventDefault();
    hideMessage();

    // Check rate limit
    const lastSubmit = localStorage.getItem(RATE_LIMIT_KEY);
    const now = Date.now();

    if (lastSubmit) {
      const timeSinceLastSubmit = now - parseInt(lastSubmit);
      if (timeSinceLastSubmit < RATE_LIMIT_MS) {
        const remainingSeconds = Math.ceil((RATE_LIMIT_MS - timeSinceLastSubmit) / 1000);
        showMessage(`Please wait ${remainingSeconds} seconds before submitting again.`, 'error');
        return false;
      }
    }

    // Get form data
    const formData = new FormData(form);
    const submitButton = form.querySelector('input[type="submit"]');
    const originalButtonText = submitButton.value;

    // Disable submit button
    submitButton.disabled = true;
    submitButton.value = 'Subscribing...';

    // Submit via AJAX
    fetch(form.action, {
      method: 'POST',
      body: formData,
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(response => {
      if (response.ok) {
        // Store submit time
        localStorage.setItem(RATE_LIMIT_KEY, now.toString());
        
        // Show success message
        showMessage('Thanks for subscribing! Check your email to confirm.', 'success');
        
        // Clear form
        form.reset();
      } else {
        throw new Error('Subscription failed');
      }
    })
    .catch(error => {
      showMessage('Something went wrong. Please try again.', 'error');
    })
    .finally(() => {
      // Re-enable submit button
      submitButton.disabled = false;
      submitButton.value = originalButtonText;
    });
  });
})();
