const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const templatePath = path.join(root, 'public', 'index.template.html');
const outPath = path.join(root, 'public', 'index.html');

const defaults = {
  SUPABASE_URL: 'https://jrkmhalznaxsskazyggt.supabase.co',
  SUPABASE_ANON_KEY: 'sb_publishable_VHNiWKy9mwV3rZAvLs85pQ_fKKFFQQh',
  BANK_NAME: 'VP BANK',
  BANK_ACCOUNT_NO: '5577626198',
  BANK_ACCOUNT_NAME: 'HKD HOANG VU LIGHTING',
  BANK_QR_IMAGE: 'qr.jpg',
};

function cleanUrl(value) {
  return String(value || defaults.SUPABASE_URL).replace(/\/rest\/v1\/?$/, '').replace(/\/$/, '');
}

function escapeForSingleQuotedJs(value) {
  return String(value ?? '')
    .replace(/\\/g, '\\\\')
    .replace(/'/g, "\\'")
    .replace(/\r/g, '\\r')
    .replace(/\n/g, '\\n');
}

let html = fs.readFileSync(templatePath, 'utf8');
const replacements = {
  SUPABASE_URL: cleanUrl(process.env.SUPABASE_URL),
  SUPABASE_ANON_KEY: process.env.SUPABASE_ANON_KEY || defaults.SUPABASE_ANON_KEY,
  BANK_NAME: process.env.BANK_NAME || defaults.BANK_NAME,
  BANK_ACCOUNT_NO: process.env.BANK_ACCOUNT_NO || defaults.BANK_ACCOUNT_NO,
  BANK_ACCOUNT_NAME: process.env.BANK_ACCOUNT_NAME || defaults.BANK_ACCOUNT_NAME,
  BANK_QR_IMAGE: process.env.BANK_QR_IMAGE || defaults.BANK_QR_IMAGE,
};

for (const [key, value] of Object.entries(replacements)) {
  html = html.replaceAll(`__${key}__`, escapeForSingleQuotedJs(value));
}

// Fallback if template has direct constants instead of placeholders
html = html.replace(/const SUPABASE_URL = '.*?';/, `const SUPABASE_URL = '${escapeForSingleQuotedJs(replacements.SUPABASE_URL)}';`);
html = html.replace(/const SUPABASE_KEY = '.*?';/, `const SUPABASE_KEY = '${escapeForSingleQuotedJs(replacements.SUPABASE_ANON_KEY)}';`);

fs.writeFileSync(outPath, html);
console.log('Built public/index.html with Supabase config:', replacements.SUPABASE_URL);
