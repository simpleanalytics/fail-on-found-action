# Fail on found action

This action adds a warning annotation for every line in your files that contains a certain query. It does not fail your workflow.

## Inputs

## `query` search

**Required** The query to search for. E.g.: `"cancelled,other term"`

## `exclude` folders

The folder to exclude. Default `"node_modules,.git,build,.tmp,tmp"` (add more in a PR if we miss obvious ones).

## Example usage

```yml
uses: simpleanalytics/fail-on-found-action@main
with:
  query: "cancelled,trailing,other term"
  exclude: "node_modules,.git"
```

## Develop

```bash
docker build -t fail . && docker run --name fail -it fail
```

And after that

```bash
docker rm fail && docker build -t fail . && docker run --name fail -it fail
```
