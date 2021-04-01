import os
from datetime import datetime
from typing import List, Optional

import json
from json import JSONEncoder
from pydantic import BaseModel, ValidationError, validator

class Post(BaseModel):

    id: str
    
    link_text: str
    link: str
    submitter: str

    type: Optional[str] = None
    source: Optional[str] = None
    dead: bool = False

    points: Optional[int] = None
    comments: Optional[int] = None
    
    date: int
    time: Optional[int] = None

    # homepage: bool = False

    @validator('comments', 'points', pre=True)
    def none_value(cls, v):
        if v == '':
            return None
        return v

class PostEncoder(JSONEncoder):
    def default(self, o):
        return o.__dict__

input_dir = 'js'
output_dir = 'data'
os.makedirs(output_dir, exist_ok=True)

for entry in os.scandir(input_dir):
    if entry.path.endswith('.js') and entry.is_file():
        
        print(entry.name)

        with open(entry.path) as f:
            
            posts = [Post(**p) for p in json.load(f)]
            
            with open(f"{output_dir}/{entry.name}", 'w') as f:
                f.write(json.dumps(posts, indent=2, cls=PostEncoder))
