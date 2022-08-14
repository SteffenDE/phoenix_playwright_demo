// playwright.config.js
// @ts-check
const { devices } = require("@playwright/test");

/** @type {import("@playwright/test").PlaywrightTestConfig} */
const config = {
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  use: {
    trace: "retain-on-failure",
    baseURL: process.env.PLAYWRIGHT_BASE_URL || "http://localhost:4000/",
    ignoreHTTPSErrors: true,
  },
  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
    {
      name: "firefox",
      use: { ...devices["Desktop Firefox"] },
    },
    {
      name: "webkit",
      use: { ...devices["Desktop Safari"] },
    }
  ],
};

module.exports = config;
