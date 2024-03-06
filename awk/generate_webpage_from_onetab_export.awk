BEGIN {
    # Set the input field separator to a pipe
    FS = " \\| ";	
    # Print the HTML header with styles as specified
    print "<!DOCTYPE html>";
    print "<html>";
    print "<head>";
    print "\t<title>OneTab Exported Links</title>";
    print "\t<style>";
    print "\t\tbody {";
    print "\t\t\tfont-family: sans-serif;";
    print "\t\t\tline-height: 2;";
    print "\t\t\tmargin-left: 25px;";
	print "\t\t\tmargin-bottom: 50px;";
	print "\t\t\twidth: 50%;"
    print "\t\t}";
	
    print "\t\ta:nth-child(odd) {";
    print "\t\t\tbackground-color: #D3D3D3;";
	print "\t\t\tdisplay: table-row;";
    print "\t\t}";	
	
	print "\t\ta:nth-child(even) {";
    print "\t\t\tbackground-color: #C0C0C0;";
	print "\t\t\tdisplay: table-row;";
    print "\t\t}";	

    print "\t\ta:link {";
    print "\t\t\tcolor: blue;";
    print "\t\t}";
	
    print "\t\ta:visited {";
    print "\t\t\tcolor: purple;";
    print "\t\t}";

    print "\t\ta:hover {";
    print "\t\t\tcolor: black;";
	print "\t\t\tfont-weight: bold;";
	print "\t\t\tbackground-color: white;";
    print "\t\t}";

    print "\t\ta:link {";
    print "\t\t\tcolor: blue;";
    print "\t\t}";	

    print "\t\ta:active {";
    print "\t\t\tcolor: red;";
    print "\t\t}";	
	
    
	print "\t\th2 {";
    print "\t\t\tcolor: #404040;";
	print "\t\t\tbox-sizing: border-box;";
	print "\t\t\tmargin-top: 20px;";
	print "\t\t\tfont-weight: 700;";
	print "\t\t\tfont-family: Calibri, Roboto Slab,ff-tisa-web-pro,Georgia,Arial,sans-serif;";
	print "\t\t\tfont-size: 175%;";
	print "\t\t\tmargin-bottom: 20px;";
	print "\t\t\ttext-align: center;";
    print "\t\t}";	

    print "\t</style>";
	
	print "\t<script>"
    print "\t\t// JavaScript to count <a> tags and display the count"
    print "\t\tdocument.addEventListener(\"DOMContentLoaded\", function() {"
    print "\t\t\tvar links = document.querySelectorAll('a'); // Select all <a> tags"
    print "\t\t\tvar count = links.length; // Count <a> tags"
    print "\t\t\tdocument.getElementById('count').innerHTML = 'Total number of links: ' + count; // Display the count"
    print "\t\t});"
    print "\t</script>"
	
	
	print "\t<meta charset=\"UTF-8\">"
    print "</head>";
    print "<body>";
	print "\t<h2>OneTab Exported Links</h2>";
	print "\t<div id=\"count\"></div>";
}
# Ignore blank rows and process rows starting with "http"
NF > 1 && $1 ~ /^http/ {
    # Extract the URL (first position) as $LINK
    link = $1;
	# Only output unique URLs
	if (!seen[link]++) {
		# Extract the text for the hyperlink (second position) as $TEXTVAL
		textVal = $2;
		# Trim leading and trailing whitespace from $TEXTVAL
		gsub(/^[ \t]+|[ \t]+$/, "", textVal);
		# Trim default OFS (trailing CRLF)
		gsub(/\r|\n/, "", textVal);
		# Construct and print the HTML hyperlink
		print "\t\t<a href=\"" link "\" title=\"" link "\">" textVal "</a>"	
	}

}

END {
    print "</body>";
    print "</html>";
}
