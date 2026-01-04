import { test, expect } from '@playwright/test';

const pages = [
  { name: 'homepage', path: '/' },
  { name: 'shelf', path: '/shelf/' },
  { name: 'writing', path: '/writing/' },
  { name: 'writing-post', path: '/writing/marks-on-blank-pages/' },
  { name: 'about', path: '/about/' },
  { name: 'theater', path: '/theater/' },
  { name: 'projects', path: '/projects/' },
];

for (const page of pages) {
  test(`${page.name} - accessibility checks`, async ({ page: playwrightPage }) => {
    // Navigate to page
    await playwrightPage.goto(page.path);
    await playwrightPage.waitForLoadState('networkidle');

    // 1. Page should have a title
    const title = await playwrightPage.title();
    expect(title).toBeTruthy();
    expect(title).not.toBe('');

    // 2. Page should have a main landmark
    const main = await playwrightPage.locator('main').count();
    expect(main).toBeGreaterThan(0);

    // 3. Skip link should exist
    const skipLink = await playwrightPage.locator('.skip-link').count();
    expect(skipLink).toBeGreaterThan(0);

    // 4. All images should have alt attributes
    const imagesWithoutAlt = await playwrightPage.evaluate(() => {
      const images = Array.from(document.querySelectorAll('img'));
      return images.filter(img => !img.hasAttribute('alt')).length;
    });
    expect(imagesWithoutAlt).toBe(0);

    // 5. Form inputs should have associated labels or aria-label
    const inputsWithoutLabels = await playwrightPage.evaluate(() => {
      const inputs = Array.from(document.querySelectorAll('input:not([type="hidden"])'));
      return inputs.filter(input => {
        const hasLabel = input.id && document.querySelector(`label[for="${input.id}"]`);
        const hasAriaLabel = input.hasAttribute('aria-label');
        const hasAriaLabelledBy = input.hasAttribute('aria-labelledby');
        return !hasLabel && !hasAriaLabel && !hasAriaLabelledBy;
      }).length;
    });
    expect(inputsWithoutLabels).toBe(0);

    // 6. Headings should be properly nested (no skipping levels)
    const headingLevelIssues = await playwrightPage.evaluate(() => {
      const headings = Array.from(document.querySelectorAll('h1, h2, h3, h4, h5, h6'));
      let previousLevel = 0;
      let issues = 0;

      for (const heading of headings) {
        const level = parseInt(heading.tagName.substring(1));
        if (previousLevel > 0 && level > previousLevel + 1) {
          issues++;
        }
        previousLevel = level;
      }

      return issues;
    });
    expect(headingLevelIssues).toBe(0);

    // 7. Links should have discernible text
    const linksWithoutText = await playwrightPage.evaluate(() => {
      const links = Array.from(document.querySelectorAll('a'));
      return links.filter(link => {
        const text = link.textContent.trim();
        const ariaLabel = link.getAttribute('aria-label');
        return !text && !ariaLabel;
      }).length;
    });
    expect(linksWithoutText).toBe(0);

    // 8. Buttons should have discernible text or aria-label
    const buttonsWithoutText = await playwrightPage.evaluate(() => {
      const buttons = Array.from(document.querySelectorAll('button'));
      return buttons.filter(button => {
        const text = button.textContent.trim();
        const ariaLabel = button.getAttribute('aria-label');
        return !text && !ariaLabel;
      }).length;
    });
    expect(buttonsWithoutText).toBe(0);
  });
}
