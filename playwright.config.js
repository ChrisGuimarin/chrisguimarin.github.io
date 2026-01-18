import { defineConfig, devices } from '@playwright/test';

// Viewport configurations for AI review
const viewports = {
  mobile: { width: 375, height: 667 },
  tablet: { width: 768, height: 1024 },
  desktop: { width: 1400, height: 900 },
};

export default defineConfig({
  testDir: './tests/visual',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  
  use: {
    baseURL: 'http://localhost:8080',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },

  projects: [
    {
      name: 'chromium-mobile',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: viewports.mobile,
      },
    },
    {
      name: 'chromium-tablet',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: viewports.tablet,
      },
    },
    {
      name: 'chromium-desktop',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: viewports.desktop,
      },
    },
    {
      name: 'webkit-desktop',
      use: { 
        ...devices['Desktop Safari'],
        viewport: viewports.desktop,
      },
    },
    {
      name: 'firefox-desktop',
      use: { 
        ...devices['Desktop Firefox'],
        viewport: viewports.desktop,
      },
    },
  ],

  webServer: {
    command: 'npx http-server docs -p 8080 -s',
    url: 'http://localhost:8080',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
});
