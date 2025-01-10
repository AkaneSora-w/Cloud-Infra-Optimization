function handler(event) { 
    var request = event.request; 
    var uri = request.uri; 
 
    var tmpUri = uri.substring(uri.indexOf('/', 1), uri.length); 
 
    request.uri = tmpUri; 
    return request; 
}