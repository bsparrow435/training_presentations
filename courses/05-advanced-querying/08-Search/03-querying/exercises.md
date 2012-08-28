# Search - Querying

## Demo data

Create the XML file `phrases.xml` with the following contents:

    <add>
        <doc>
            <field name="id">1</field>
            <field name="pangram">true</field>
            <field name="phrase">The quick brown fox jumps over the lazy dog</field>
        </doc>
    </add>

Index the phrases:

    search-cmd solr phrases phrases.xml
    
## Term Query

Perform the following term queries:

    search-cmd search phrases "phrase:quick"
    search-cmd search phrases "phrase:dog"

## Phrase Query

Perform the following phrase query:

    search-cmd search phrases "phrase:\"quick dog\""
    
### Why does this query not match any documents?

## Wildcard Query

Perform the following wilcard query:

    search-cmd search phrases "phrase:bro*"

### What term is the query matching?

## Range Query

Perform the following range query:

    search-cmd search phrases "phrase:[dig TO dug]"

### What term is the query matching?

## Proximity Query

Perform the following proximity query:

    search-cmd search phrases "phrase:\"quick dog\"~8"

### Why does this query match the document?

## Boolean Query

Perform the following boolean queries:

    search-cmd search phrases "phrase:dog OR phrase:cat"
    search-cmd search phrases "phrase:dog AND phrase:cat"
    search-cmd search phrases "phrase:dog AND NOT phrase:cat"
    search-cmd search phrases "phrase:dog AND phrase:fox"

### Why does the first query match the document?
### Why does the second query not match the document?
### Why does the third query match the document?
### Why does the fourth query match the document?