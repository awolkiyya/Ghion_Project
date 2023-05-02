<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;
    protected $fillable = [
        'catagore_id',
        'user_id',
        'tittle',
        'discription',
        'price',
];
// this is the method used to get the catagore of the product which are belongs to
public function catagore(){
return $this->belongsTo(Catagory::class);
}
// this method used to get the user who are create the product
public function user(){
return $this->belongsTo(User::class);
}
// this is the method that used to get single post images
public function images(){
return $this->hasMany(Image::class);
}
}
