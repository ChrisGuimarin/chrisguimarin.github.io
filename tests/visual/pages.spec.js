import { test, expect } from '@playwright/test';

// Helper function to wait for page to be fully loaded
async function waitForPageLoad(page) {
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
}

// Helper function to get viewport name from test info
function getViewportName(testInfo) {
  const projectName = testInfo.project.name;
  if (projectName.includes('mobile')) return 'mobile';
  if (projectName.includes('tablet')) return 'tablet';
  return 'desktop';
}

// Helper function to get browser name from test info
function getBrowserName(testInfo) {
  const projectName = testInfo.project.name;
  if (projectName.includes('webkit')) return 'webkit';
  if (projectName.includes('firefox')) return 'firefox';
  return 'chromium';
}

// Test 1: Static route - Homepage
test('homepage renders correctly', async ({ page }, testInfo) => {
  await page.goto('/');
  
  // Force all lazy-loaded images to load eagerly for testing
  await page.evaluate(() => {
    document.querySelectorAll('img[loading="lazy"]').forEach(img => {
      img.loading = 'eager';
    });
  });
  
  await waitForPageLoad(page);
  
  const viewport = getViewportName(testInfo);
  const browser = getBrowserName(testInfo);
  
  await expect(page).toHaveScreenshot(
    `chrisguimarin-homepage-${browser}-${viewport}.png`,
    {
      fullPage: true,
      animations: 'disabled',
      timeout: 10000,
    }
  );
});

// Test 2: Automatic page discovery
test('discovered pages render correctly', async ({ page }, testInfo) => {
  test.setTimeout(120000); // Increase timeout for page discovery
  const discoveredPages = new Set(['/']); // Start with homepage
  const processedPages = new Set();
  const viewport = getViewportName(testInfo);
  const browser = getBrowserName(testInfo);

  // Function to discover links from a page
  async function discoverLinks(url) {
    if (processedPages.has(url)) return;
    processedPages.add(url);

    await page.goto(url, { waitUntil: 'load' });
    // Use shorter wait for discovery since we're crawling many pages
    await page.waitForTimeout(1000);

    // Extract all internal links
    const links = await page.evaluate(() => {
      const anchors = Array.from(document.querySelectorAll('a[href]'));
      return anchors
        .map(a => a.href)
        .filter(href => {
          try {
            const url = new URL(href);
            // Only internal links (same origin)
            return url.origin === window.location.origin;
          } catch {
            return false;
          }
        })
        .map(href => {
          const url = new URL(href);
          return url.pathname;
        });
    });

    // Add newly discovered links
    links.forEach(link => {
      if (!discoveredPages.has(link) && !processedPages.has(link)) {
        discoveredPages.add(link);
      }
    });

    // Recursively discover from new links
    for (const link of links) {
      if (!processedPages.has(link)) {
        await discoverLinks(link);
      }
    }
  }

  // Start discovery from homepage
  await discoverLinks('/');

  // Screenshot all discovered pages
  for (const pageUrl of discoveredPages) {
    await page.goto(pageUrl, { waitUntil: 'load' });
    
    // Force all lazy-loaded images to load eagerly for testing
    await page.evaluate(() => {
      document.querySelectorAll('img[loading="lazy"]').forEach(img => {
        img.loading = 'eager';
      });
    });
    
    // Wait for images and fonts
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
    await page.evaluate(() => document.fonts.ready);
    await page.waitForTimeout(500);

    // Create a safe filename from the URL
    const safeName = pageUrl
      .replace(/^\//, '')
      .replace(/\/$/, '')
      .replace(/\//g, '-')
      || 'index';

    await expect(page).toHaveScreenshot(
      `chrisguimarin-${safeName}-${browser}-${viewport}.png`,
      {
        fullPage: true,
        animations: 'disabled',
        timeout: 10000,
      }
    );
  }
});
