# fjs

Proxy to browse paywalled content

## Run

```shell
nimble run
```

## Docker

```shell
docker build -t fjs .
docker run -it --rm -p 8080:8080 fjs
```

## Bookmark for quick access

Create a new bookmark with location:

```js
javascript:void((function(){location.href='http://0.0.0.0:8080?url='%20+%20encodeURIComponent(location.href);})());
```

## TODO

- [x] Dockerfile
- [x] Bookmark
- [x] Remove `<script>` elements
- [ ] Host
