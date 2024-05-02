# example-go-versioning

Example go project that compiles version information at binary build.

## Overview

The following program demonstrates *dynamic-linking* of a runtime variable `VERSION`. By default, via `go run .`,
the `main.VERSION` variable will be assigned to `"development"`.

However, when building with the following command:

```bash
go build --mod vendor --ldflags="-s -w -X 'main.VERSION=$(cat VERSION)'" -o /example-go-versioning
```

The `main.VERSION` variable is updated according to the output of the VERSION file.

For demonstration, locally clone the repository and execute `make run`. Requires Docker.
