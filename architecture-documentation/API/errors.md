# Error structure

{
    "code": Int,
    "type": String,
    "message": String
}  

## Codes

400 errors:

When error starts with 429, rate limiting is applied.  

500 errors:  
When error starts with 5, retry later
