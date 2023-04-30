<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Http\JsonResponse;

class Controller extends BaseController
{
    use AuthorizesRequests, ValidatesRequests;
    public function getUser(Request $request, string $id): JsonResponse
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json([
                'status' => 404,
                'data' => null,
                'message' => 'validation error',
                'errors' => ['user' => 'Unable to find user in our records.'],
            ], 404);
        }

        return response()->json([
            'status' => 200,
            'data' => $user,
            'message' => 'success',
            'errors' => null,
        ], 200);

    }
    public function getImage(){
        return response()->file(public_path("storage/profile/6svicYITzxrjdSRh12cojF4iP47HC9xb4tmbOPHD.jpg"),);
    }
}
