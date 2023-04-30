<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class File extends Model
{
    use HasFactory;
    protected $fillable = [
        'name', 'size', 'path',
    ];

    public function uploaded_by(): BelongsTo
    {
        return $this->belongsTo('App\Models\User');
    }
}
