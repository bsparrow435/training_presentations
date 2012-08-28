# Basic Querying - Simple Queries

1) Perform the following requests:

  - Store:

        curl -v http://127.0.0.1:8098/buckets/capitals/keys/usa -X PUT -H "content-type: text/plain" -d "Washington D.C."

  - Fetch:

        curl -v http://127.0.0.1:8098/buckets/capitals/keys/usa

  - Delete:

        curl -v http://127.0.0.1:8098/buckets/capitals/keys/usa -X DELETE

2) Store, fetch, and update an object making sure to submit the vclock when updating
