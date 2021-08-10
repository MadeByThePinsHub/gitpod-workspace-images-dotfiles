/* We want to customize the defaults in @commitlint/config-conventional, so
 * our Commitlint CI doesn't complain about "merge(pr|git-pull): ..." in the future
 */
const conventionalCommit = require("@hydralite/cz-commitlint-config/customizations.json");
const typesEnum = Object.keys(conventionalCommit.types);
const scopesEnum = Object.keys(conventionalCommit.scopes);

module.exports = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "type-enum": [2, "always", typesEnum],
    "scope-enum": [2, "always", scopesEnum],
  },
};
