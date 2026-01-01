import { test, expect } from '@playwright/test';

const viewports = [
  { name: 'desktop', width: 1400, height: 900 },
  { name: 'tablet', width: 800, height: 1024 },
  { name: 'mobile', width: 375, height: 667 },
];

const pages = [
  { name: 'homepage', path: '/' },
  { name: 'shelf', path: '/shelf/' },
  { name: 'writing', path: '/writing/' },
  { name: 'about', path: '/about/' },
  { name: 'theater', path: '/theater/' },
  { name: 'projects', path: '/projects/' },
];

for (const viewport of viewports) {
  for (const page of pages) {
    test(`${page.name} - ${viewport.name}`, async ({ page: playwrightPage }) => {
      // Set viewport size
      await playwrightPage.setViewportSize({ 
        width: viewport.width, 
        height: viewport.height 
      });

      // Navigate to page
      await playwrightPage.goto(page.path);

      // Wait for page to be fully loaded
      await playwrightPage.waitForLoadState('networkidle');
      
      // Wait for all images to load
      await playwrightPage.evaluate(() => {
        return Promise.all(
          Array.from(document.images)
            .filter(img => !img.complete)
            .map(img => new Promise(resolve => {
              img.addEventListener('load', resolve);
              img.addEventListener('error', resolve);
            }))
        );
      });

      // Take full page screenshot and compare
      await expect(playwrightPage).toHaveScreenshot(
        `${page.name}-${viewport.name}.png`,
        {
          fullPage: true,
          animations: 'disabled',
        }
      );
    });
  }
}
