# Fail on found action

This action makes your workflow fail when it finds a certain query in your files. It annotates every line that contains the query.

## Inputs

## `query` search

**Required** The query to search for. E.g.: `"cancelled,other term"`

## `exclude` folders

The folder to exclude. Default `"node_modules,.git,build,.tmp,tmp"` (add more in a PR if we miss obvious ones).

## `warn`

Set to `"true"` to annotate the lines with warnings instead of failing your workflow. Default `"false"`.

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
