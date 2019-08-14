'use strict';

// dump url to mthml
//
const puppeteer = require('puppeteer');
const fs = require('fs');

(async function main() {
  try {
    const browser = await puppeteer.launch();
    const [page] = await browser.pages();

    await page.goto(process.argv[2]);

    const cdp = await page.target().createCDPSession();
    const { data } = await cdp.send('Page.captureSnapshot', { format: 'mhtml' });
    fs.writeFileSync(process.argv[3], data);

    const pageTitle = await page.title();
    await browser.close();
    console.log(pageTitle);
  } catch (err) {
    console.error(err);
  }
})();
