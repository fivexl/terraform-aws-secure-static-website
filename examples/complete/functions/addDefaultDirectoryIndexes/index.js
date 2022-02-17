'use strict';
const path = require('path');

/**
 * Redirects URLs to default document. Examples:
 *
 * /                -> /index.html (or another default root object)
 * /blog            -> /blog/index.html
 * /blog/july/      -> /blog/july/index.html
 * /blog/header.png -> /blog/header.png
 *
 */

exports.handler = (event, context, callback) => {
  // Extract the request from the CloudFront event that is sent to Lambda@Edge
  var request = event.Records[0].cf.request;

  // Skip if contains extension
  var extension = path.extname(request.uri);
  if (extension && extension.length > 0) {
    return callback(null, request);
  }

  //Skip default root path and use default root object settings
  if (request.uri !== '/') {
    // Extract the URI from the request
    var olduri = request.uri;

    // Match any uri that ends with some combination of
    // [0-9][a-z][A-Z]_- and append a slash
    var endslashuri = olduri.replace(/(\/[\w\-]+)$/, '$1/');

    // Get last_character after append a slash
    var last_character = endslashuri.slice(-1);

    // // If last charecter is a slach do a url rewrite
    if (last_character === '/') {
      // Match any '/' that occurs at the end of a URI. Replace it with a default index
      var newuri = endslashuri.replace(/\/$/, '/index.html');

      // Log the URI as received by CloudFront and the new URI to be used to fetch from origin
      console.log('Rewriting Old URI: ' + olduri + ' to New URI: ' + newuri);

      // Replace the received URI with the URI that includes the index page
      request.uri = newuri;
    }
  }

  // Return to CloudFront
  return callback(null, request);
};
