# Fail on found action

This action prints "Hello World" or "Hello" + the name of a person to greet to the log.

## Inputs

## `query` search

**Required** The query to search for. E.g.: `"cancelled,other term"`

## `exclude` folders

The folder to exclude. Default `"node_modules,.git,build,.tmp,tmp"` (add more in a PR if we miss obvious ones).

## Example usage

```yml
uses: actions/fail-on-found-action@master
with:
  query: "cancelled,other term"
```
