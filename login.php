<?php
declare(strict_types=1);

require_once __DIR__ . '/includes/layout.php';

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!verify_csrf(post('csrf_token'))) {
        $error = 'Security token mismatch. Please try again.';
    } else {
        [$success, $message] = attempt_login(trim((string) post('email')), (string) post('password'));
        if ($success) {
            $role = current_user()['role'] ?? 'customer';
            if ($role === 'admin' || $role === 'employee') {
                redirect('admin/' . ADMIN_ROUTE_SEGMENT . '/dashboard.php');
            }
            redirect('customer/account.php');
        }
        $error = $message;
    }
}

render_header('Login', 'auth-page');
?>
<main class="auth-wrap">
    <section class="auth-card glass reveal">
        <div>
            <span class="eyebrow">Secure access</span>
            <h1>Sign in to manage designs, orders, voting, and drops.</h1>
            <p class="muted">Demo accounts work automatically if MySQL is not connected.</p>
            <p class="muted">Admin: `admin@ateliernoir.test` / `Admin@123`</p>
            <p class="muted">Employee: `products@ateliernoir.test` / `Employee@123`</p>
            <p class="muted">Customer: `customer@ateliernoir.test` / `Customer@123`</p>
        </div>
        <form method="post" class="auth-form">
            <input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>">
            <label><span>Email</span><input type="email" name="email" required></label>
            <label><span>Password</span><input type="password" name="password" required></label>
            <?php if ($error !== ''): ?><div class="notice error"><?= e($error) ?></div><?php endif; ?>
            <button class="button" type="submit">Login</button>
            <a href="register.php" class="text-link">Create customer account</a>
        </form>
    </section>
</main>
<?php render_footer(); ?>
