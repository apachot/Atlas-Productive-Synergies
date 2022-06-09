const purgecss = require("@fullhuman/postcss-purgecss")({
    content: [
        "./public/index.html",
        "./src/App.js",
        "./src/**/*.js",
        "./src/**/*.tsx",
        "./src/**/*.ts",
        "./src/*.ts",
        "./src/*.tsx",
    ],
    defaultExtractor: (content) => content.match(/[\w-/:]+(?<!:)/g) || [],
    whitelistPatterns: [/^w-sidebar/],
});

module.exports = {
    plugins: [
        require("postcss-nested"),
        require("tailwindcss"),
        require("autoprefixer"),
        ...(process.env.NODE_ENV === "production" ? [purgecss] : []),
    ],
};
