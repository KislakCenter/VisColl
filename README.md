VisColl
=======

This project is for XSL transforms for visualization of quire structure  from
a parsed collation formula. 

# Collation Model

To create a collation model, use the Collation Modeler form (currently at https://protected-island-3361.herokuapp.com/ and described at https://github.com/demery/collation-modeling)

To use the VisColl files, you will need to export the Leaves XML from the Collation Modeler.

# Generate Collation Formula

To generate a collation formula, process the xslts/generate_formula.xslt file against the Leaves XML file. On a Mac, using the Terminal, your command will look something like this:

saxon Cotton_MS_Claudius_B_IV.xml xslts/generate-formula.xsl

The output will be an HTML file, with the same name as your input file, containing two different collation formulas.

If you have a preferred formula and you would like to see it added to the output for generate-formula.xsl, please feel free to edit that file, or contact me and I will add it.

# Generate Collation Visualization

To generate a collation visualization, process the collation_viz.sh file against the Leaves XML file. On a Mac, using the Terminal, your command will look something like this:

sh collation_viz.sh Cotton_MS_Claudius_B_IV.xml

The output will be a set of HTML files, one for each quire, inside a folder named for the input file.

## Things to note

In addition to the Leaves XML file, you will also need to have a file listing URLs to images, matched with the folio or page number for those images. 

The simplest way to create this file is using Excel. First, create a spreadsheet with folio or page numbers in the first column, and the corresponding image URL in the second column (*do not* includ column headings). For example:

1r          http://project.org/image1r.jpg
1v          http://project.org/image1v.jpg
2r          http://project.org/image2r.jpg
2v          http://project.org/image2v.jpg

Then save this file as an XML file in Excel (Save As -> Excel 2004 XML Spreadsheet). As of right now, the image list file must be named according to the shelfmark in the Collation Modeler, but with all spaces removed. So for a Collation Modeler form with the shelfmark Cotton MS Claudius B IV, the image list file would be called:

CottonMSClaudiusBIV-imageList.xml

If the image list is named incorrectly, the process won't work correctly.


