import globals from "globals";


export default [
  {files: ["**/*.js"], languageOptions: {sourceType: "module"}},
  {languageOptions: { globals: globals.browser }},
  {
    "rules": {
      "semi": [1, "always"],
      "prefer-const": "error"
    }
  }
];
