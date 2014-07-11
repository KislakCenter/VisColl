VisColl
=======

This project is for XSL transforms for visualization of quire structure  from
a parsed collation formula. 

In the first iteration, this project will handle the style of collation
formula used in Walters Art Museum TEI manuscript descriptions found at:

* <http://www.thedigitalwalters.org/01_ACCESS_WALTERS_MANUSCRIPTS.html> 

# XML quire structure

This XSLT rewrites a WAM-style formula in an XML quire structure. The XML
has the following format:

    <quires>
        <quire n="1" positions="8"/>
        <quire n="2" positions="8">
            <less>1</less>
            <less>2</less>
        </quire>
        <!--...-->
    </quires>

Each `quire` element has a quire number, `@n`, a number of reguar quire
`@positions` and zero or more subtractive `less` elements that give the
positions of missing leaf positions in the quire. This method of describing a
quire follows the model of the Walters-style collation formula  discussed in
the next section.

# Walters collation formulas

Walters-style collation formulas have a form like this:

    i, 1(8,-1,2), 2(6), 3(10,-1,9), 4(10,-4,8), 5(6,-1,5), 6(6), 7-11(8), 
       12(8,-8), 13(8), 14(6), 15(8,-8), 16(12,-5,9,12), 17(10,-6,8,10), 
       18(10,-6,8,10) 19(8,-7), 20-21(8), i

Here the leading and trailing `i` indicate a count of flyleaves. Before each
parenthetical unit - e.g., `1(8,-1,2)` - is a single quire number (e.g., 1, 2,
3) or a range of quire numbers (e.g., 7-11, 20-21). Within each parenthetical
set - e.g., `(8,-1,2)` - the first number indicates the number of leaf
positions in a theoretical regular quire structure that would apply if this
quire were regular: 8 leaves for a regular quire of four bifolia or 6 leaves
for a quire of three  bifolia, and so on. The position number is then followed
by a series of subtracted positions that explain how the regular quire
structure should be altered to derive the structure of the quire in its
current form.

The general form of the formula is:

    QUIRE_NO[-QUIRE_NO](LEAF_COUNT[,-POSITION[,POSITION,..]])

For example, `1(8,-1,2)` describes a quire of 6 extant leaves. The quire has
two bifolia followed by two singletons. The two bifolia are positions 3+6,
4+5, followed by singletons at positions 7, 8. The positions needed to
complete the  structure are the missing positions 1* and 2* (here marked with
a * to indicate their absence).

       _ _ _ _ _ _ _ _ 1* 
      |  _ _ _ _ _ _ _ 2*
      | |  ___________ 3
      | | |  _________ 4
      | | | |
      | | | |
      | | | |_________ 5
      | | |___________ 6
      | |_____________ 7
      |_______________ 8

NB The numbers here indicate *theoretical* leaf positions, not folio numbers.

NB Also, these formulas do not describe how the quire came to be, but rather
simply describe the quire structure using a subtractive formula. Nothing
should be inferred about the history of the quire from this formula. In the
example above, the quire may have been a quire of 4 bifolia to which the last
two singletons were later added; the formula is not concerned with this.

# Process XSLTs

Use the processn.xslt files to run the full process. Start with process1.xslt, the output for process1.xslt is the input for process2.xslt. The output from process7.xslt builds the complete collation visualization website.


