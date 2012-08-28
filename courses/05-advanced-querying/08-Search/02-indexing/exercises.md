# Search - Indexing

## Demo data

Create a directory of text files

        mkdir demo
        cd demo
        echo "demo data goes here" > foo.txt
        echo "demo demo demo demo" > bar.txt
        echo "nothing to see here" > baz.txt
        echo "demo demo" > qux.txt

## search-cmd index

Index demo data into the `cmd-index` index using `search-cmd index INDEX PATH`

Use `search-cmd search` to search the documents using the query `demo`

## search:index_dir/1,2

Index demo data into the `search-index` index using `search:index_dir(Index, Path)` while attached to the Riak node

Use `search-cmd search` to search the documents using the query `demo`

## Solr

Index demo data into the `solr-index` through the Solr API

Use `search-cmd search` to search the documents using the query `demo`

## Bonus

### What index is used when none is specified? (e.g. `search-cmd index path`)

### How did you figure this out?

### What other strategies can you think of to figure this out?

## Standard Analyzer - Stop Words

Create the XML file `phrases.xml` with the following contents:

    <add>
        <doc>
            <field name="id">1</field>
            <field name="phrase_txt">The quick brown fox jumps over the lazy dog</field>
            <field name="phrase">The quick brown fox jumps over the lazy dog</field>
        </doc>
    </add>

Index the phrases:

    search-cmd solr phrases phrases.xml
    
Search the `phrase` field for the word `the`:

    search-cmd search phrases "phrase:the"
    
Search the `phrase_txt` field for the word `the`:

    search-cmd search phrases "phrase_txt:the"
    
### Why are the results different?

## Custom Schema

Create the schema file `custom.def` with the following contents:

    {
    schema,
    [
        {version, "1.1"},
        {default_field, "phrase"},
        {default_op, "or"},
        {n_val, 3}
    ],
    [
        {field, [
            {name, "id"},
            {analyzer_factory,
                {erlang, text_analyzers, noop_analyzer_factory}}
        ]},
        {field, [
            {name, "phrase"},
            {analyzer_factory,
                {erlang, text_analyzers, standard_analyzer_factory}}
        ]},
        {field, [
            {name, "pangram"},
            {inline, only},
            {analyzer_factory,
                {erlang, text_analyzers, noop_analyzer_factory}}
        ]}
     ]
     }.
        
Set the schema for the `phrases_custom` index using the `custom.def` schema:

    search-cmd set-schema phrases_custom custom.def

Create the XML file `phrases_custom.xml` with the following contents:

    <add>
        <doc>
            <field name="id">1</field>
            <field name="pangram">true</field>
            <field name="phrase">The quick brown fox jumps over the lazy dog</field>
        </doc>
    </add>

Index the phrases:

    search-cmd solr phrases_custom phrases_custom.xml
    
Search for the word `fox` without specifying the field:

    search-cmd search phrases_custom fox

### Why did the search work without specifying a field?

Search for the word `fox` and filter using `pangram:false`:

    search-cmd search phrases_custom "fox" "pangram:false"
    
Search for the word `fox` and filter using `pangram:true`:

    search-cmd search phrases_custom "fox" "pangram:true"
