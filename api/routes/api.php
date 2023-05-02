<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Controller;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/
Route::post('/login', [AuthController::class, 'loginUser'])->name("login");
Route::post('/register', [AuthController::class, 'register']);
Route::get('/getUser/{id}', [Controller::class, 'getUser']);
Route::get('/getImage', [Controller::class, 'getImage']);
Route::get('/getProduct', [Controller::class, 'getAllProduct']);
Route::post('/storeProduct', [Controller::class, 'storeProduct']);
Route::get('/getProduct/{id}', [Controller::class, 'getProduct']);




Route::post('forget-password', [AuthController::class, 'submitForgetPasswordForm']); 
Route::get('/reset-password/{token}', function (string $token) {
    return ['token' => $token];
})->middleware('guest')->name('password.reset');
Route::post('/reset-password', function (Request $request) {
    $request->validate([
        'token' => 'required',
        'email' => 'required|email',
        'password' => 'required|min:8|confirmed',
    ]);
 
    $status = Password::reset(
        $request->only('email', 'password', 'password_confirmation', 'token'),
        function (User $user, string $password) {
            $user->forceFill([
                'password' => Hash::make($password)
            ])->setRememberToken(Str::random(60));
 
            $user->save();
 
            event(new PasswordReset($user));
        }
    );
 
    return $status === Password::PASSWORD_RESET
                ? redirect()->route('login')->with('status', __($status))
                : back()->withErrors(['email' => [__($status)]]);
})->middleware('guest')->name('password.update');
Route::get('/logout', [AuthController::class, 'logout'])->middleware(['auth:sanctum']);