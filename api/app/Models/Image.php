<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Image extends Model
{
    use HasFactory;
    use HasFactory;
    protected $fillable = [
      'image_path',
      'image_size',
      'product_id',
  ];
      // this method used to get the user who are post the blogs
      
      public function product(){
        return $this->belongsTo(Product::class);
    }
}
