<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use DB; 
use Carbon\Carbon; 
use Mail; 
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Password;

class AuthController extends Controller
{

    public function uploads($file, $path)
    {
        if($file) {
            $fileName   = time() . $file->getClientOriginalName();
            Storage::disk('public/user_profile')->put($path . $fileName, File::get($file));
            $file_name  = $file->getClientOriginalName();
            $file_type  = $file->getClientOriginalExtension();
            $filePath   = $path . $fileName;

            return $file = [
                'fileName' => $file_name,
                'fileType' => $file_type,
                'filePath' => $filePath,
                'fileSize' => $this->fileSize($file)
            ];
        }
    }

    public function fileSize($file, $precision = 2)
    {   
        $size = $file->getSize();

        if ( $size > 0 ) {
            $size = (int) $size;
            $base = log($size) / log(1024);
            $suffixes = array(' bytes', ' KB', ' MB', ' GB', ' TB');
            return round(pow(1024, $base - floor($base)), $precision) . $suffixes[floor($base)];
        }

        return $size;
    }

    /**
     * Create User
     * @param Request $request
     * @return JsonResponse
     */
    public function register(Request $request): JsonResponse
    {
        try {
            //Validated
            $validateUser = Validator::make($request->all(),
            [
                    'firstName'=> 'required',
                    'lastName'=>'required',
                    'phoneNumber'=>'required',
                    'address' => 'required',
                    'email' => 'required|email|unique:users,email',
                    'password' => 'required',
                    'image'=>'mimes:png,jpg,jpeg|required',

                ]);

            if($validateUser->fails()){
                return response()->json([
                    'status' => 401,
                    'message' => 'validation error',
                    'errors' => $validateUser->errors()
                ], 401);
            }
            // $profile ="";
            if ($request->hasFile('image') && $request->file('image')->isValid()) {
                $path = $request->file('image')->store('public/profile');
                $profile = str_replace('public/', '', $path);
            }
            $user = User::create([
                'first_name'=> $request->firstName,
                'last_name'=> $request->lastName,
                'profile'=> $profile,
                'email'=> $request->email,
                'address'=> $request->address,
                'phone_number'=>$request->phoneNumber,
                'email'=> $request->email,
                'password'=> Hash::make($request->password),
            ]);
            
            
            error_log($user);
             
            return response()->json([
                'status' => 200,
                'data'=>$user->id,
                'message' => 'User Created Successfully',
                'api_token' =>$user->createToken('client')->plainTextToken,
            ], 200);

        } catch (\Throwable $th) {
            return response()->json([
                'status' => 500,
                'message' => $th->getMessage()
            ], 500);
        }
        // try{
        //     $rules = [
        //         'firstName'=> 'required',
        //         'lastName'=>'required',
        //         'phoneNumber'=>'required',
        //         'address' => 'required',
        //         'email' => 'required|email|unique:users,email',
        //         'password' => 'required',
        //         'image'=>'mimes:png,jpg,jpeg|required',
        //     ];
        //     // $messages = [
        //     //     'profile.max' => 'The image size must not exceed 2MB.',
        //     //     'profile.file' => 'The uploaded file must be a valid file.',
        //     //     'profile.mimes' => 'The profile must be a file of type: jpeg, png, jpg',
        //     // ];
        //     $data = $request->validate($rules);
        //     if($data->fails()){
        //                 return response()->json([
        //                     'status' => 401,
        //                     'message' => 'validation error',
        //                     'errors' => $validateUser->errors()
        //                 ], 401);
        //             }
           
        //     if (User::query()->where('phone_number', $data['phoneNumber'])->count() > 0) {
        //         return response()->json([
        //             'status' => 400,
        //             'data' => null,
        //             'message' => 'validation error',
        //             'errors' => ['phone_number' => 'Phone Number already registered.'],
        //         ], 400);
        //     }
        //     $data['password'] = Hash::make($data['password']);
 
 
        //     if ($request->hasFile('image') && $request->file('image')->isValid()) {
        //         $path = $request->file('image')->store('public/profile');
        //         $data['image'] = str_replace('public/', '', $path);
        //     }
 
        //     $user = User::query()->create($data);
 
        //     return response()->json([
        //         'status' => 200,
        //         'data' => $user,
        //         'message' => 'success',
        //         'errors' => null,
        //     ], 200);
        // }
        // catch (ValidationException $e) {
        //     return response()->json([
        //         'status' => 422,
        //         'message' => 'Validation Error',
        //         'errors' => $e->errors()
        //     ], 422);
        // }
    }

    /**
     * Login The User
     * @param Request $request
     * @return JsonResponse
     */
    public function loginUser(Request $request): JsonResponse
    {
        try {
            $validateUser = Validator::make($request->all(),
                [
                    'email' => 'required|email',
                    'password' => 'required'
                ]);

            if($validateUser->fails()){
                return response()->json([
                    'status' => 401,
                    'message' => 'validation error',
                    'errors' => $validateUser->errors()
                ], 401);
            }

            if(!Auth::attempt($request->only(['email', 'password']))){
                return response()->json([
                    'status' => 401,
                    'message' => 'Email & Password does not match with our record.',
                ], 401);
            }

            $user = User::where('email', $request->email)->first();
            error_log($user);
            if($user){
            return response()->json([
                            'status' => 200,
                            'data'=>$user->id,
                            'message' => 'User Logged In Successfully',
                            'api_token' =>1,
                        ], 200);}

        } catch (\Throwable $th) {
            return response()->json([
                'status' => 500,
                'message' => $th->getMessage()
            ], 500);
        }
    }
    public function submitForgetPasswordForm(Request $request)
    {
        $request->validate(['email' => 'required|email']);
 
        $status = Password::sendResetLink(
            $request->only('email')
        );
     
        return $status === Password::RESET_LINK_SENT
                    ? back()->with(['status' => __($status)])
                    : back()->withErrors(['email' => __($status)]);
        // $request->validate([
        //     'email' => 'required|email|exists:users',
        // ]);

        // $token = Str::random(64);

        // DB::table('password_reset_tokens')->insert([
        //     'email' => $request->email, 
        //     'token' => $token, 
        //     'created_at' => Carbon::now()
        //   ]);

        // Mail::send('welcome', ['token' => $token], function($message) use($request){
        //     $message->to($request->email);
        //     $message->subject('Reset Password');
        // });


        // return response()->json([
        //     'token' => $token,
        //     'message' => 'We have e-mailed your password reset link!',
        // ], 200);
    }
    /**
     * Write code on Method
     *
     * @return response()
     */
    public function showResetPasswordForm($token) { 
    //    return view('auth.forgetPasswordLink', ['token' => $token]);
    }

    /**
     * Write code on Method
     *
     * @return response()
     */
    public function submitResetPasswordForm(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users',
            'password' => 'required|string|min:6|confirmed',
            'password_confirmation' => 'required'
        ]);

        $updatePassword = DB::table('password_resets')
                            ->where([
                              'email' => $request->email, 
                              'token' => $request->token
                            ])
                            ->first();

        if(!$updatePassword){
            return back()->withInput()->with('error', 'Invalid token!');
        }

        $user = User::where('email', $request->email)
                    ->update(['password' => Hash::make($request->password)]);

        DB::table('password_resets')->where(['email'=> $request->email])->delete();

        return redirect('/login')->with('message', 'Your password has been changed!');
    }
    public function userProfile(Request $request){
        //  $rules = [
        //         'tittle' => ['required'],
        //         'summary' => ['required'],
        //         'body' => ['required'],
        //         'catagore_id' => ['required'],
        //         'profile' => 'mimes:png,jpg,jpeg|max:2048',
        //     ];
        //     $messages = [
        //         'profile.max' => 'The image size must not exceed 2MB.',
        //         'profile.file' => 'The uploaded file must be a valid file.',
        //         'profile.mimes' => 'The profile must be a file of type: jpeg, png, jpg',
        //     ];
        // $image= null;
        // if($request->hasFile('file') && $request->file('file')->isValid()) {
        //     $file =$request->file('profile');
        //     $fileData = $this->uploads($file,'');
        // //    $image = Image::create([
        // //         'image_url' => $fileData['filePath'],
        // //         'image_size' => $fileData['fileSize']
        // //     ]);
        // }
         $request->file->storeAs('public/user_profile',$request->file->getClientOriginalName());
         if($request->file->isValid()){
            $resultData['result'] = "success";
         }
         else{
            $resultData['result'] = 'fail';
         }
         return $resultData;
    }
}
