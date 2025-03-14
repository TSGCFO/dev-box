# Node.js Configuration

## Recommended npm Configuration (.npmrc)

```
save=true
save-exact=false
registry=https://registry.npmjs.org/
fund=false
audit=false
```

## Recommended package.json for Node.js API

```json
{
  "name": "api-service",
  "version": "1.0.0",
  "description": "API Service",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "build": "tsc",
    "prepare": "husky install"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^6.0.1",
    "morgan": "^1.10.0",
    "dotenv": "^16.0.3",
    "joi": "^17.9.1",
    "winston": "^3.8.2",
    "pg": "^8.10.0",
    "knex": "^2.4.2"
  },
  "devDependencies": {
    "nodemon": "^2.0.22",
    "jest": "^29.5.0",
    "supertest": "^6.3.3",
    "eslint": "^8.38.0",
    "eslint-config-prettier": "^8.8.0",
    "eslint-plugin-prettier": "^4.2.1",
    "prettier": "^2.8.7",
    "husky": "^8.0.3",
    "lint-staged": "^13.2.1"
  },
  "lint-staged": {
    "*.js": "eslint --cache --fix",
    "*.{js,css,md}": "prettier --write"
  }
}
```

## Recommended .eslintrc.js

```js
module.exports = {
  env: {
    node: true,
    jest: true,
  },
  extends: ['eslint:recommended', 'plugin:prettier/recommended'],
  parserOptions: {
    ecmaVersion: 2020,
  },
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'warn',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'warn',
  },
};
```

## Recommended .prettierrc

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "printWidth": 80,
  "trailingComma": "es5"
}
```

## NVM Configuration

To set a default Node.js version with NVM, run:

```bash
nvm alias default 18.16.0
```

To create a .nvmrc file in your project:

```bash
echo "18.16.0" > .nvmrc
```

Then in any project, you can run:

```bash
nvm use
```