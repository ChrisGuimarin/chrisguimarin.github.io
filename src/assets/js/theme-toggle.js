// Theme toggle functionality
(function() {
  const themeToggle = document.getElementById('theme-toggle');
  const themeReset = document.getElementById('theme-reset');
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');

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

  // Initialize theme (do not persist)
  setTheme(getTheme());

  // Toggle theme (persist user choice)
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

  // Listen for system theme changes (only if no user override)
  prefersDark.addEventListener('change', (e) => {
    if (!localStorage.getItem('theme')) {
      setTheme(e.matches ? 'dark' : 'light');
    }
  });
})();
