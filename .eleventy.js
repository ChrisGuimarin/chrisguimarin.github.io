module.exports = function(eleventyConfig) {
    // Pass through copy for CSS files
    eleventyConfig.addPassthroughCopy("src/style.css");

    return {
        dir: {
            input: "src",
            output: "docs"
        }
    };
};