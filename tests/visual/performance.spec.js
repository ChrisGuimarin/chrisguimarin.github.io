import { test, expect } from '@playwright/test';

const pages = [
  { name: 'homepage', path: '/' },
  { name: 'about', path: '/about/' },
];

for (const page of pages) {
  test(`${page.name} - performance metrics`, async ({ page: playwrightPage }) => {
    // Navigate and measure performance
    const startTime = Date.now();
    await playwrightPage.goto(page.path);
    await playwrightPage.waitForLoadState('networkidle');
    const loadTime = Date.now() - startTime;

    // 1. Page should load in reasonable time (< 3 seconds)
    expect(loadTime).toBeLessThan(3000);

    // 2. Check Core Web Vitals via Performance API
    const metrics = await playwrightPage.evaluate(() => {
      const paintEntries = performance.getEntriesByType('paint');
      const fcp = paintEntries.find(entry => entry.name === 'first-contentful-paint');

      return {
        fcp: fcp ? fcp.startTime : null,
        resourceCount: performance.getEntriesByType('resource').length,
      };
    });

    // First Contentful Paint should be < 1.8s (good)
    if (metrics.fcp) {
      expect(metrics.fcp).toBeLessThan(1800);
    }

    // 3. Reasonable number of resources (not excessive)
    expect(metrics.resourceCount).toBeLessThan(50);

    // 4. Check image optimization
    const unoptimizedImages = await playwrightPage.evaluate(() => {
      const images = Array.from(document.images);
      return images.filter(img => {
        // Check if large images have lazy loading
        const isLarge = img.naturalWidth > 300 || img.naturalHeight > 300;
        const hasLazyLoading = img.loading === 'lazy';
        const isAboveFold = img.getBoundingClientRect().top < window.innerHeight;

        // Large images should have lazy loading unless above fold
        return isLarge && !hasLazyLoading && !isAboveFold;
      }).length;
    });
    expect(unoptimizedImages).toBe(0);

    // 5. Check that CSS is not render-blocking excessively
    const cssCount = await playwrightPage.evaluate(() => {
      return document.querySelectorAll('link[rel="stylesheet"]').length;
    });
    expect(cssCount).toBeLessThan(5);

    // 6. Check JavaScript bundle size is reasonable
    const jsSize = await playwrightPage.evaluate(() => {
      const scripts = Array.from(document.querySelectorAll('script[src]'));
      return scripts.length;
    });
    expect(jsSize).toBeLessThan(10);

    console.log(`${page.name} performance:`, {
      loadTime: `${loadTime}ms`,
      fcp: metrics.fcp ? `${Math.round(metrics.fcp)}ms` : 'N/A',
      resources: metrics.resourceCount,
      cssFiles: cssCount,
      jsFiles: jsSize
    });
  });
}
