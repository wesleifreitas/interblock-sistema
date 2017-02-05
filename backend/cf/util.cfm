<cfprocessingDirective pageencoding="utf-8">
<cfset setEncoding("form","utf-8")> 

<!--- http://www.bennadel.com/blog/124-ask-ben-converting-a-query-to-an-array.htm --->
<cffunction 
    name       ="queryToArray" 
    access     ="public" 
    returntype ="array" 
    output     ="false"
    hint       ="Transforma uma query em uma array de structs.">
 
    <!--- Define arguments. --->
    <cfargument 
        name     ="Data" 
        type     ="query" 
        required ="yes"/>
 
    <cfscript>
 
        // Define the local scope.
        var LOCAL = StructNew();
 
        // Get the column names as an array.
        LOCAL.Columns = ListToArray( ARGUMENTS.Data.ColumnList );
 
        // Create an array that will hold the query equivalent.
        LOCAL.QueryArray = ArrayNew( 1 );
 
        // Loop over the query.
        for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
 
            // Create a row structure.
            LOCAL.Row = StructNew();
 
            // Loop over the columns in this row.
            for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
 
                // Get a reference to the query column.                
                LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];
                //LOCAL.ColumnName = lCase(LOCAL.Columns[ LOCAL.ColumnIndex ]); 
 
                // Store the query cell value into the struct by key.
                LOCAL.Row[ LOCAL.ColumnName ] = ARGUMENTS.Data[ LOCAL.ColumnName ][ LOCAL.RowIndex ];
 
            }
 
            // Add the structure to the query array.
            ArrayAppend( LOCAL.QueryArray, LOCAL.Row );
 
        }
 
        // Return the array equivalent.
        return( LOCAL.QueryArray );
 
    </cfscript>
    
</cffunction>

<!--- https://www.bennadel.com/blog/811-converting-iso-date-time-to-coldfusion-date-time.htm --->
<cffunction
    name="ISOToDateTime"
    access="public"
    returntype="string"
    output="false"
    hint="Converts an ISO 8601 date/time stamp with optional dashes to a ColdFusion date/time stamp.">

    <!--- Define arguments. --->
    <cfargument
        name="Date"
        type="string"
        required="true"
        hint="ISO 8601 date/time stamp."
        />

    <!---
        When returning the converted date/time stamp,
        allow for optional dashes.
    --->
    <cfreturn ARGUMENTS.Date.ReplaceFirst(
        "^.*?(\d{4})-?(\d{2})-?(\d{2})T([\d:]+).*$",
        "$1-$2-$3 $4"
        ) />
</cffunction>