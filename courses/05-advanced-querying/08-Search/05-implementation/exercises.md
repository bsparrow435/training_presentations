# Search - Implementation

## Analyzing

### Question

What terms would be generated from the following string using a simple whitespace analyzer?

    The quick brown fox jumps over the lazy dog
    
### Answer

* The
* quick
* brown
* fox
* jumps
* over
* the
* lazy
* dog

## Partitioning

### Question

What index, field, term entries would be generated if the following document was indexed to the "quotes" index using a simple whitespace analyzer?

    quote: This book fills a much-needed gap
    author: Moses Hadas

### Answer

* quotes, quote, This
* quotes, quote, book
* quotes, quote, fills
* quotes, quote, a
* quotes, quote, much-needed
* quotes, quote, gap
* quotes, author, Moses
* quotes, author, Hadas

## Postings

### Question

What index, field, term, posting entry would be generated for the 4th term  of the "text" field if the following document was indexed to the "phrases" index using a simple whitespace analyzer?

    id: 1
    text: The quick brown fox jumps over the lazy dog
    
### Answer

* index: phrases
* field: text
* term: fox
* posting:
    * id: 1
    * position: 3

## Term Query

### Question

What is the index, field, term entry for the following query run against the "phrases" index?

    text:dog
    
### Answer
    
* phrases, text, dog

## Boolean Query

### Question

What is the max number of partitions that need to be queried to satisfy the following query?

    text:quick AND text:brown AND text:fox
    
### Answer

* 3

## Inline Fields

### Question

What index, field, term, posting entry would be generated for the 4th term  of the "text" field if the following document was indexed to the "phrases" index using a simple whitespace analyzer and the "pangram" field is an inline field?

    id: 1
    pangram: true
    text: The quick brown fox jumps over the lazy dog
    
### Answer

* index: phrases
* field: text
* term: fox
* posting:
    * id: 1
    * position: 3
    * inline:
        * field: pangram
        * term: true