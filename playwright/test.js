const base = require('@playwright/test');

exports.test = base.test.extend({
    // a page that uses its own ecto sandbox session
    isolatedPage: async ({ baseURL, browser, request }, use) => {
        const response = await request.post("/sandbox");
        const metadata = await response.text();
        const context = await browser.newContext({ baseURL, userAgent: metadata });
        const page = await context.newPage();
        page.__metadata = metadata;
        await use({
            page,
            request: await base.request.newContext({
                baseURL,
                userAgent: metadata
            }),
        });
        // close the page before removing the sandbox session to prevent
        // checkin errors ("... is still using a connection from owner at location ...")
        await context.close();
        await request.delete("/sandbox", { headers: { "user-agent": metadata } });
    },
    loggedOutPageMeta: async ({ }, use) => {
        await use(async ({ page, request }) => {
            const { email, password } = await (await request.post("/testapi/register")).json();
            page.__currentUser = { email, password };
            return { page, request };
        });
    },
    // a page that has page.__currentUser, but not logged into the UI
    loggedOutPage: async ({ isolatedPage: { page, request }, loggedOutPageMeta }, use) => {
        await use(await loggedOutPageMeta({ page, request }));
    },
    loggedInPageMeta: async ({ }, use) => {
        await use(async ({ page, request }) => {
            const { email, password } = await (await request.post("/testapi/register")).json();
            page.__currentUser = { email, password };
            await page.goto("/users/log_in");
            await page.locator("#user_email").fill(email);
            await page.locator("#user_password").fill(password);
            await page.locator("button >> text=Log in").click();
            return { page, request };
        });
    },
    // a page that has page.__currentUser and is already logged in
    loggedInPage: async ({ isolatedPage: { page, request }, loggedInPageMeta }, use) => {
        await use(await loggedInPageMeta({ page, request }));
    },
    // for tests that cannot run in the sandbox
    nonSandboxedPage: async ({ browser }, use) => {
        let cleanup;
        await use(async ({ metadata, baseURL }) => {
            const context = await browser.newContext({ baseURL });
            cleanup = async () => context.close();
            return {
                page: await context.newPage(),
                request: await base.request.newContext({ baseURL }),
            };
        });
        await cleanup();
    }
});

exports.expect = base.expect;
