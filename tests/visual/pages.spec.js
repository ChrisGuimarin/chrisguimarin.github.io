import { test, expect } from '@playwright/test';

// Simplified smoke test - just homepage at desktop viewport
test('homepage renders correctly', async ({ page }) => {
  // Set desktop viewport
  await page.setViewportSize({ 
    width: 1400, 
    height: 900 
  });

  // Navigate to homepage
  await page.goto('/');

  // Wait for page to be fully loaded
  await page.waitForLoadState('networkidle');
  
  // Wait for all images to load
  await page.evaluate(() => {
    return Promise.all(
      Array.from(document.images)
        .filter(img => !img.complete)
        .map(img => new Promise(resolve => {
          img.addEventListener('load', resolve);
          img.addEventListener('error', resolve);
        }))
    );
  });
  
  // Wait for fonts to load
  await page.evaluate(() => document.fonts.ready);
  
  // Additional wait for any layout shifts
  await page.waitForTimeout(500);
  
  // Take full page screenshot and compare
  await expect(page).toHaveScreenshot(
    'homepage-desktop.png',
    {
      fullPage: true,
      animations: 'disabled',
      timeout: 10000,
    }
  );
});
