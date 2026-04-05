Atelier Noir Premium Custom Clothing Platform

Stack:
- Plain HTML, CSS, JavaScript, PHP, AJAX, MySQL
- Professional folder separation for admin, employee, customer, AJAX/API, uploads, products, customizer, orders, and voting modules

Core routes:
- index.html
- customizer.html
- voting_board.html
- login.php
- register.php
- customer/account.php
- admin/secure-control/dashboard.php
- admin/secure-control/website_customizer.php

Setup:
1. Import database.sql into MySQL.
2. Update includes/config.php DB credentials if needed.
3. Point your PHP server root to this folder.
4. Ensure uploads/products, uploads/designs, and uploads/banners are writable.

Notes:
- Public storefront templates now use `.html`; PHP versions redirect to the HTML routes for compatibility.
- Demo fallback data appears automatically when MySQL is unavailable.
- Admin route is intentionally hidden behind /admin/secure-control/.
- Voting, design save, theme save, and admin actions use AJAX endpoints in /api.
