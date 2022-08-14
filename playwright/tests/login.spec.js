const { test, expect } = require("../test");

test("complains about invalid email or password", async ({ isolatedPage: { page } }) => {
    await page.goto("/users/log_in");
    await expect(page).toHaveURL("/users/log_in");
    await page.locator("#user_email").fill("fake@cool.com");
    await page.locator("#user_password").fill("fakepassword");
    await page.locator("button >> text=Log in").click();
    await expect(page.locator("div.alert-danger")).toHaveText("Invalid email or password");
});

test("logs in", async ({ loggedOutPage: { page } }) => {
    await page.goto("/users/log_in");
    await expect(page).toHaveURL("/users/log_in");
    await page.locator("#user_email").fill(page.__currentUser.email);
    await page.locator("#user_password").fill(page.__currentUser.password);
    await page.locator("button >> text=Log in").click();
    await expect(page).toHaveURL("/");
});
