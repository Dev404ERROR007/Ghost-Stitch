<?php
declare(strict_types=1);

require_once __DIR__ . '/includes/layout.php';

$message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!verify_csrf(post('csrf_token'))) {
        $message = 'Security token mismatch.';
    } elseif (!db_available()) {
        $message = 'Demo mode active. Import the database and then enable persistent registration.';
    } else {
        $name = trim((string) post('name'));
        $email = trim((string) post('email'));
        $password = (string) post('password');

        if ($name === '' || $email === '' || $password === '') {
            $message = 'All fields are required.';
        } else {
            $exists = db()->prepare('SELECT id FROM users WHERE email = :email LIMIT 1');
            $exists->execute(['email' => $email]);

            if ($exists->fetch()) {
                $message = 'That email is already registered.';
            } else {
                $stmt = db()->prepare('INSERT INTO users (name, email, password_hash, role, created_at) VALUES (:name, :email, :password_hash, :role, NOW())');
                $stmt->execute([
                    'name' => $name,
                    'email' => $email,
                    'password_hash' => password_hash($password, PASSWORD_DEFAULT),
                    'role' => 'customer',
                ]);
                $message = 'Account created successfully. You can now sign in.';
            }
        }
    }
}

render_header('Register', 'auth-page');
?>
<main class="auth-wrap">
    <section class="auth-card glass reveal">
        <div>
            <span class="eyebrow">Customer accounts</span>
            <h1>Create an account to save custom designs and review order history.</h1>
        </div>
        <form method="post" class="auth-form">
            <input type="hidden" name="csrf_token" value="<?= e(csrf_token()) ?>">
            <label><span>Name</span><input type="text" name="name" required></label>
            <label><span>Email</span><input type="email" name="email" required></label>
            <label><span>Password</span><input type="password" name="password" required></label>
            <?php if ($message !== ''): ?><div class="notice"><?= e($message) ?></div><?php endif; ?>
            <button class="button" type="submit">Register</button>
        </form>
    </section>
</main>
<?php render_footer(); ?>
