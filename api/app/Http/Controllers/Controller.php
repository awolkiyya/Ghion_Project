<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Category;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use DB; 
use Illuminate\Support\Facades\Validator;
class Controller extends BaseController
{
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
    // then the next steps are go to perform the operations have a good time
    public function getAllProduct(): JsonResponse{
      $products = DB::table('products')->get();
        $images = DB::table('images')->get()->toArray();

        foreach ($products as $product) {
            $product->images =(object)  array_filter($images, function ($image) use ($product) {
                return $image->product_id === $product->id;
            });
        }
        return response()->json([
            'status' => 200,
            'data' => $products,
        ], 200);

    }
    public function storeProduct(Request $request):JsonResponse{
        // now let start first validate
        try {
            $validateProduct = Validator::make($request->all(),
                [
                  
                    'tittle'=> 'required',
                    'price'=>'required',
                    'catagory'=>'required',
                    'description' =>'required',
                    'user_id' => 'required',
                ]);

            if($validateProduct->fails()){
                return response()->json([
                    'status' => 401,
                    'message' => 'validation error',
                    'errors' => $validateProduct->errors()
                ], 401);
            }
            // now start store the data
            // first chack if it store before
            $catagory;
            if(!(Category::query()->where('catagore_name', $request->catagory)->count() > 0)){
                 $catagory = Category::create([
                'catagore_name'=> $request->catagory,
                'catagore_code'=> "",
                'image'=> "",
            ],);
                   
        }
            else{
               $catagory = Category::query()->where('catagore_name', $request->catagory)->get()->first();
            }
            error_log($catagory);  
            // now start store products   
            $product = Product::create([
                'tittle'=> $request->tittle,
                'discription'=> $request->description,
                'price'=>(int)$request->price,
                'catagore_id'=> $catagory->id,
                'user_id'=> $request->user_id,

            ],);
            error_log($product);
            // now store the list of products images
            $imagePathArray = [];
            $c = 0;
             $files = $request->file('file');
             foreach($files as $file){
             $path = $file->storeAs('public/Product/Images', $file->getClientOriginalName());
             $profile = str_replace('public/', '', $path);
             $size = fileSize($file);
             $product->images()->create([
                "product_id"=>$product->id,
                "image_path"=>$profile,
                "image_size" =>$size,
             ]);
             }
            //  error_log($imagePathArray);
             
            return response()->json([
                            'status' => 200,
                            'data'=>"",
                            'message' => 'The Full Product Information Are Store',
                            'api_token' =>1,
                        ], 200);

        } catch (\Throwable $th) {
            return response()->json([
                'status' => 500,
                'message' => $th->getMessage()
            ], 500);
        }
    }
     // this is the function used to get the user specific product from the server
     public function getProduct($id){

        $products = Product::query()->where('user_id', $id)->get();
        $images = DB::table('images')->get()->toArray();

        foreach ($products as $product) {
            $product->images =(object)  array_filter($images, function ($image) use ($product) {
                return $image->product_id === $product->id;
            });
        }
        error_log($products);
        return response()->json([
            'status' => 200,
            'data' => $products,
        ], 200);
            error_log($id);
     }

}
