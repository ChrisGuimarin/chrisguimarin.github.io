// Theme toggle functionality with radial wipe transition
(function() {
  const themeToggle = document.getElementById('theme-toggle');
  const themeReset = document.getElementById('theme-reset');
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

  // Get theme from localStorage or system preference
  const getTheme = () => {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) return savedTheme;
    return prefersDark.matches ? 'dark' : 'light';
  };

  // Apply theme (optionally persist)
  const setTheme = (theme, persist = false) => {
    document.documentElement.setAttribute('data-theme', theme);
    themeToggle.setAttribute('aria-pressed', theme === 'dark');
    if (persist) {
      localStorage.setItem('theme', theme);
    }
  };

  // Create and animate the transition overlay
  const animateThemeTransition = (newTheme, originElement, callback) => {
    // Skip animation if user prefers reduced motion
    if (prefersReducedMotion.matches) {
      callback();
      return;
    }

    // Get the new theme's background color
    const bgColor = newTheme === 'dark' ? '#1a1a1a' : '#fff';

    // Get origin position (center of the toggle button)
    const rect = originElement.getBoundingClientRect();
    const originX = rect.left + rect.width / 2;
    const originY = rect.top + rect.height / 2;

    // Calculate the radius needed to cover the entire viewport
    const maxX = Math.max(originX, window.innerWidth - originX);
    const maxY = Math.max(originY, window.innerHeight - originY);
    const radius = Math.sqrt(maxX * maxX + maxY * maxY);

    // Create overlay element
    const overlay = document.createElement('div');
    overlay.className = 'theme-transition-overlay';
    overlay.style.backgroundColor = bgColor;
    overlay.style.left = `${originX - radius}px`;
    overlay.style.top = `${originY - radius}px`;
    overlay.style.width = `${radius * 2}px`;
    overlay.style.height = `${radius * 2}px`;

    document.body.appendChild(overlay);

    // Start expand animation
    requestAnimationFrame(() => {
      overlay.classList.add('expanding');
    });

    // When expand completes, flip theme and fade out
    overlay.addEventListener('animationend', function handleExpand(e) {
      if (e.animationName === 'theme-expand') {
        overlay.removeEventListener('animationend', handleExpand);

        // Flip the theme while overlay covers the screen
        callback();

        // Start fade out
        overlay.classList.remove('expanding');
        overlay.classList.add('fading');

        // Remove overlay after fade completes
        overlay.addEventListener('animationend', function handleFade() {
          overlay.remove();
        }, { once: true });
      }
    });
  };

  // Initialize theme (do not persist)
  setTheme(getTheme());

  // Toggle theme with animation (persist user choice)
  themeToggle.addEventListener('click', () => {
    const currentTheme = getTheme();
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';

    animateThemeTransition(newTheme, themeToggle, () => {
      setTheme(newTheme, true);
    });
  });

  // Reset theme to system default (instant, no animation)
  themeReset.addEventListener('click', () => {
    localStorage.removeItem('theme');
    setTheme(getTheme());
  });

  // Listen for system theme changes (only if no user override)
  prefersDark.addEventListener('change', (e) => {
    if (!localStorage.getItem('theme')) {
      setTheme(e.matches ? 'dark' : 'light');
    }
  });
})();
