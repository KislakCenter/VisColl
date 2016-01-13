VisColl
=======

This project is for XSL transforms for visualization of quire structure  from
a parsed collation formula. 

VisColl involves three steps: 

1. Create a Collation Model
2. Create an Image List
3. Generate a Collation Visualization (see http://dorpdev.library.upenn.edu/collation/ for some examples of what the Collation Visualization looks like)

## Create a Collation Model

To create a collation model, use the Collation Modeler form (currently at http://tinyurl.com/CollModel/ and described at https://github.com/demery/collation-modeling)

Export the Leaves XML from the Collation Modeler.

Video tutorial online (building collation model): https://www.facebook.com/dot.porter.583/videos/vb.100005128847862/437456166435341/

Video tutorial online (comparing Collation Modeler outputs - advanced): https://www.facebook.com/dot.porter.583/videos/vb.100005128847862/437464446434513/

## Create an Image List

In addition to the Leaves XML file, you will also need to have a file listing URLs to images, matched with the folio or page number for those images. 

The simplest way to create this file is using Excel. First, create a spreadsheet with folio or page numbers in the first column, and the corresponding image URL in the second column (*do not* include column headings). For example:

1r http://project.org/image1r.jpg

1v http://project.org/image1v.jpg

2r http://project.org/image2r.jpg

2v http://project.org/image2v.jpg

Then save this file as an XML file in Excel (Save As -> Excel 2004 XML Spreadsheet). As of right now, the image list file must be named according to the shelfmark in the Collation Modeler, but with all spaces removed. So for a Collation Modeler form with the shelfmark Cotton MS Claudius B IV, the image list file would be called:

CottonMSClaudiusBIV-imageList.xml

If the image list is named incorrectly, the process won't work correctly.

Video tutorial online (create an image list using Excel): https://www.facebook.com/dot.porter.583/videos/vb.100005128847862/437458699768421/

## Generate Collation Visualization

To generate a Collation Visualization, go here: http://tinyurl.com/VisColl/ (CURRENTLY OFFLINE - 1/13/2016)

Load the Collation Model and the Image List where indicated.

Click "Submit". In a few moments, you will be asked to download a .zip file containing the full Collation Visualization (in HTML). There will be one HTML file for each quire, plus a folder of supporting materials. You will need to keep everything together in order for it to work.

NOTE: Some computers are downloading the .zip file in which the file name is surrounded by single quotes (i.e., literally, 'VisColl.zip'). Your computer will not recognize the .zip' file extension and will be unable to open this file. You will need to edit the file name and remove the single quotes. Once you do this, your computer will recognize the file type and will be able to open it. So, if your computer can't open the file after downloading, check to see if it has single quotes around it.

The Collation Visualization online tool uses XProc-Z, developed by Conal Tuohy and available at his github: https://github.com/Conal-Tuohy/XProc-Z

Many thanks to Conal for incorporating the XSLT files found in this repository into the XProc pipeline that runs as Collation Visualization.

Video tutorial online: https://www.facebook.com/dot.porter.583/videos/vb.100005128847862/437461726434785/

## Generate Collation Formula

To generate a collation formula, process the xslts/generate_formula.xslt file against the Leaves XML file. On a Mac, using the Terminal, your command will look something like this:

saxon Cotton_MS_Claudius_B_IV.xml xslts/generate-formula.xsl

The output will be an HTML file, with the same name as your input file, containing two different collation formulas.

If you have a preferred formula and you would like to see it added to the output for generate-formula.xsl, please feel free to edit that file, or contact me and I will add it.


