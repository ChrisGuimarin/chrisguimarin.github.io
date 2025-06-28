const postcss = require('postcss');
const postcssImport = require('postcss-import');

module.exports = function (eleventyConfig) {
    // Pass through copy for assets
    eleventyConfig.addPassthroughCopy("src/assets");

    // Handle CSS files
    eleventyConfig.addTemplateFormats("css");

    eleventyConfig.addExtension("css", {
        outputFileExtension: "css",
        compile: async function (inputContent, inputPath) {
            if (inputPath.includes('main.css')) {
                let result = await postcss([
                    postcssImport({
                        root: 'src/assets/css',
                        path: ['src/assets/css']
                    })
                ]).process(inputContent, {
                    from: inputPath
                });
                return async () => result.css;
            }
            // Return non-main CSS files as-is
            return async () => inputContent;
        }
    });

    // Add date filters
    eleventyConfig.addFilter("dateIso", date => {
        return date.toISOString();
    });

    eleventyConfig.addFilter("dateReadable", date => {
        return date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    });

    // Add collections
    eleventyConfig.addCollection("work", function (collectionApi) {
        return collectionApi.getFilteredByGlob("src/work/*.md");
    });

    eleventyConfig.addCollection("writing", function (collectionApi) {
        return collectionApi.getFilteredByGlob("src/writing/*.md");
    });

    eleventyConfig.addCollection("books", function (collectionApi) {
        return collectionApi.getFilteredByGlob("src/books/*.md");
    });

    // Add filter for grouping books by category
    eleventyConfig.addFilter("byCategory", function (books, category) {
        return books.filter(book => book.data.category === category);
    });

    return {
        dir: {
            input: "src",
            output: "docs"
        }
    };
};