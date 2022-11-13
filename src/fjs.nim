import prologue
import std/httpclient
import std/net
import std/strutils
import std/re as re

proc getWebsiteContent(url: string): string =
    let client = newHttpClient(sslContext = newContext(
            verifyMode = CVerifyPeer))
    return client.getContent(url)

func getBaseUrl(url: string): string =
    return url.split("/")[0..2].join("/")

func replaceContent(content: string, baseUrl: string): string =
    let newContent1 = content.replace("href=\"/", "href=\"" & baseUrl & "/")
                           .replace("href=\"", "href=\"" & "?url=")
    let newContent2 = re.replace(newContent1, re.re"<script[\s\S]*?>[\s\S]*?<\/script>", "")
    let newContent3 = re.replace(newContent2, re.re"<script[\s\S]*?>", "")
    let newContent4 = re.replace(newContent3, re.re"<noscript[\s\S]*?>[\s\S]*?<\/noscript>", "")
    return newContent4

proc index*(ctx: Context) {.async.} =
    let urlOption = ctx.getQueryParamsOption("url")
    if urlOption.isSome:
        let url = urlOption.get()
        let baseUrl = url.getBaseUrl()
        let content = getWebsiteContent(url)
        let newContent = replaceContent(content, baseUrl)
        resp newContent
    else:
        resp "no url provided, usage: /?url=https://www.google.com"

let app = newApp()
app.get("/", index)
app.run()
