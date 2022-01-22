function sendHttpRequest(requestType, url, callback, params) {
    var doc = new XMLHttpRequest()
    doc.onreadystatechange = function() {
        if (doc.readyState === 4) {
            if (doc.status === 200) {
//                console.log("Get response:", doc.responseText)
                callback(doc.responseText)
            } else {
                callback("error", doc.responseText)
            }
        }
    }
    doc.open(requestType, url);
    if(requestType === "GET") {
        doc.setRequestHeader('Host', 'radia.cz')
        doc.setRequestHeader('User-Agent', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:96.0) Gecko/20100101 Firefox/96.0')
        doc.setRequestHeader('Accept-Encoding', 'gzip, deflate, br')
        doc.setRequestHeader('Sec-Fetch-Dest', 'document')
        doc.setRequestHeader('Content-type', 'application/json')
    } else {
        doc.setRequestHeader('Content-type', 'application/json')
    }
    console.log("send url", url)
    doc.send(params);
}

function replaceEntity(str) {
    if (str.length > 0) {
        return str.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&#039;/g, "'")
    }
}

function changeImageLink(link) {
    return link.replace(/www.abradio/g, "radia")
}
