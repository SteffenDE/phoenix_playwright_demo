const { test, expect } = require("../test");

test("creates todo", async ({ loggedInPage: { page } }) => {
    await page.goto("/todos");
    await page.locator("a", { hasText: "New Todo" }).click();
    await expect(page).toHaveURL("/todos/new");
    await page.locator("#todo-form input").fill("My todo");
    await page.locator("button", { hasText: "Save" }).click();
    await expect(page).toHaveURL("/todos");
    await expect(page.locator("main")).toContainText("My todo");
});
