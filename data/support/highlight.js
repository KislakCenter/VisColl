    // Find all html object element for the SVG files
    const svgObjects = document.querySelectorAll("object");
    // Iterate code for each SVG object
    for (let i = 0; i < svgObjects.length; i++) {
        // wait for each SVG object to load
        svgObjects[i].addEventListener("load", function () {
            // get data-attribute value of the SVG object in question
            var currentID = this.getAttribute("data-current-id");
            // If data-attribute of SVG object is equal to the leaf path class value, then assign "current" class
            const doc = this.contentDocument.querySelectorAll("g." + currentID);
            // capture both arcs and lines of the current leaf
            for (let i = 0; i < doc.length; i++) {
                // change the class to current for highlight
                doc[i].classList = "leaf current";
            };
        });
    };//