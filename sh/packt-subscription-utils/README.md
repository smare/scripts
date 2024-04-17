# Packt books management

With a [subscription](https://subscription.packtpub.com/) to Packt, you can access the eBook versions of all purchases by browsing to the "[Your owned content](https://subscription.packtpub.com/owned)" page.  This webpage calls several APIs to get the content metadata, beginning with an API authorization call using the Packt unique identifier for the subscriber.  Then it makes the following calls:

1. _Endpoint_: `https://subscription.packtpub.com/api/users/me/subscriptions`
   _Function_:  GETs the subscriber's subscription metadata.
**Excerpt:**
```
{
    "message": "Success",
    "data": {
		<list all metadata fields>
    }
}
```

2. _Endpoint_: `https://subscription.packtpub.com/api/entitlements/users/me/products?search=`
   _Function_:  GETs a JSON document with limited metadata about every owned book.
**Excerpt** (from `scripts/test-data/packt-library/packt-owned-books-short.json`):
```
{
    "message": "success",
    "data": [
        {
			<list all metadata fields>
        },
		...
    ],
    "count": 564
}
```

3. _Endpoint_: `https://subscription.packtpub.com/api/products/by-isbn`
   _Function_:  POSTs all ISBN (productId) numbers from the previous request, and returns a JSON document with all metadata for every owned book.
**Excerpt** (from `scripts/test-data/packt-library/packt-owned-books-long.json`):
```
{
    "message": "Success",
    "data": [
		{
			<list all metadata fields>
		},
		...
	]
}
```

Programmatically accessing the API is difficult as it is not meant to be customer-facing, so the easiest way to get these metadata files is to open developer tools in the browser of your choice, then load the "Your owned content" page.  Using the network request monitor, find the responses for the endpoints above and copy the JSON documents into a text file.