import { test, expect } from '@playwright/test';

// All site pages (homepage is covered by its own dedicated test below)
const pages = [
  '/about/',
  '/projects/',
  '/shelf/',
  '/theater/',
  '/work/battle-net/',
  '/writing/',
  '/writing/culture-is-what-you-tolerate/',
  '/writing/marks-on-blank-pages/',
  '/writing/test-buttondown-automation/',
  '/books/atomic-habits/',
  '/books/design-for-the-real-world/',
  '/books/design-of-everyday-things/',
  '/books/designing-for-people/',
  '/books/designing-programmes/',
  '/books/in-praise-of-shadows/',
  '/books/interaction-of-color/',
  '/books/making-of-a-manager/',
  '/books/nasa-graphics-standards/',
  '/books/paul-rand/',
  '/books/product-design-for-the-web/',
  '/books/secret-lives-of-color/',
  '/books/steve-jobs/',
  '/books/the-information/',
  '/books/thinking-in-systems/',
];

// Wait for full render: images (including lazy), fonts, and layout shifts
async function waitForPageLoad(page) {
  await page.waitForLoadState('networkidle');

  // Force lazy-loaded images to load eagerly for accurate screenshots
  await page.evaluate(() => {
    document.querySelectorAll('img[loading="lazy"]').forEach(img => {
      img.loading = 'eager';
    });
  });

  // Wait for all images to finish loading
  await page.evaluate(() =>
    Promise.all(
      Array.from(document.images)
        .filter(img => !img.complete)
        .map(img => new Promise(resolve => {
          img.addEventListener('load', resolve);
          img.addEventListener('error', resolve);
        }))
    )
  );

  // Wait for web fonts
  await page.evaluate(() => document.fonts.ready);

  // Allow for any remaining layout shifts
  await page.waitForTimeout(500);
}

test('homepage renders correctly', async ({ page }) => {
  await page.goto('/');
  await waitForPageLoad(page);

  await expect(page).toHaveScreenshot('chrisguimarin-homepage.png', {
    fullPage: true,
    animations: 'disabled',
    timeout: 10000,
  });
});

test('site pages render correctly', async ({ page }) => {
  test.setTimeout(60000);

  for (const url of pages) {
    await page.goto(url);
    await waitForPageLoad(page);

    const name = url.replace(/^\//, '').replace(/\/$/, '').replace(/\//g, '-') || 'index';

    await expect(page).toHaveScreenshot(`chrisguimarin-${name}.png`, {
      fullPage: true,
      animations: 'disabled',
      timeout: 10000,
    });
  }
});
