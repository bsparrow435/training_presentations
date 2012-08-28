# Links and Link Walking

## Groups

Create 10 person objects using the keys below

* dan
* joe
* ian
* justin
* tryn
* sowjanya
* brian
* tanya
* casey
* vin

Create 3 group objects linking to persons

* trainer: dan, joe, ian
* da: dan, ian, tryn, sowjanya, brian, tanya, justin
* ps: casey, joe, vin

For each group link walk to the person objects (3 requests)

Update the person objects to link back to their groups

Find dan's groups

Find the persons belonging to the same groups as dan

Find the persons belonging to the same groups as dan and also return the groups

## Directory 1

Create several directory objects that link to persons by the first letter of 
their first name. For example:

* `directory/d` would link to `person/dan`
* `directory/j` would link to `person/joe`, and `person/justin`
* `directory/i` would like to `person/ian`

Link walk to all persons whose name begins with the letter `t`.

Link walk to all persons whose name begins with the letters `d`, `j`, `i`.

* hint: this will require multiple requests

Repeat the previous query using a MapReduce link phase

## Directory 2

Create a single directory object that links to all persons. Use the first letter 
of the person's first name as the tag. Use `directory/persons` as the object key.

For example:

       curl -XPUT http://localhost:8098/riak/directory/persons \
          -H 'content-type: text/plain' -d 'persons' \
          -H 'link: </riak/person/joe>; riaktag="j"' \
          -H 'link: </riak/person/ian>; riaktag="i"' \
          -H 'link: </riak/person/dan>; riaktag="d"' \
          ...

Link walk to all persons whose name begins with the letter `t`.

Link walk to all persons whose name begins with the letters `d`, `j`, `i`.

* hint: this will require multiple requests

Repeat the previous query using MapReduce

* hint: you need to write a custom MapReduce function
* hint: don't use a link phase
