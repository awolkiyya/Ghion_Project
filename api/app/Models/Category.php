<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    use HasFactory;
    protected $fillable = [
        'catagore_name',
        'catagore_code',
        'image',
    ];
    // this is the method that used to get all list of post related to this post catagore
    public function product(){
        return $this->hasMany(Product::class);
    }
}
