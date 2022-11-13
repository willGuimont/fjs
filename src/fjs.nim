import prologue
import std/strutils
import std/httpclient
import std/net

proc getWebsiteContent(url: string): string =
    let client = newHttpClient(sslContext = newContext(
            verifyMode = CVerifyPeer))
    return client.getContent(url)

func getBaseUrl(url: string): string =
    return url.split("/")[0..2].join("/")

func replaceUrls(content: string, baseUrl: string): string =
    return content
        .replace("href=\"/", "href=\"" & baseUrl & "/")
        .replace("href=\"", "href=\"" & "?url=")

proc index*(ctx: Context) {.async.} =
    let urlOption = ctx.getQueryParamsOption("url")
    if urlOption.isSome:
        let url = urlOption.get()
        let baseUrl = url.getBaseUrl()
        let content = getWebsiteContent(url)
        let newContent = replaceUrls(content, baseUrl)
        resp newContent
    else:
        resp "no url provided, usage: /?url=https://www.google.com"

let app = newApp()
app.get("/", index)
app.run()
