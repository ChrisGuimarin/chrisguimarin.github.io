/**
 * Theme toggle functionality
 *
 * Provides dark/light mode switching with:
 * - Manual toggle between dark and light themes
 * - System preference detection and following
 * - localStorage persistence of user choice
 * - Reset to system default option
 *
 * @module theme-toggle
 */
(function() {
  const themeToggle = document.getElementById('theme-toggle');
  const themeReset = document.getElementById('theme-reset');
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');

  /**
   * Gets the current theme from localStorage or system preference
   *
   * @returns {'dark'|'light'} The current theme
   */
  const getTheme = () => {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) return savedTheme;
    return prefersDark.matches ? 'dark' : 'light';
  };

  /**
   * Applies the specified theme to the document
   *
   * @param {'dark'|'light'} theme - The theme to apply
   * @param {boolean} [persist=false] - Whether to save the theme to localStorage
   */
  const setTheme = (theme, persist = false) => {
    document.documentElement.setAttribute('data-theme', theme);
    themeToggle.setAttribute('aria-pressed', theme === 'dark');
    if (persist) {
      localStorage.setItem('theme', theme);
    }
  };

  // Initialize theme on page load (do not persist)
  setTheme(getTheme());

  // Toggle theme on button click (persist user choice)
  themeToggle.addEventListener('click', () => {
    const currentTheme = getTheme();
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    setTheme(newTheme, true);
  });

  // Reset theme to system default
  themeReset.addEventListener('click', () => {
    localStorage.removeItem('theme');
    setTheme(getTheme());
  });

  // Listen for system theme changes (only applies if user hasn't set a preference)
  prefersDark.addEventListener('change', (e) => {
    if (!localStorage.getItem('theme')) {
      setTheme(e.matches ? 'dark' : 'light');
    }
  });
})();
