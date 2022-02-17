'use strict';
exports.handler = (event, context, callback) => {
  //Get contents of response
  const response = event.Records[0].cf.response;
  const headers = response.headers;

  console.log('Request:', event.Records[0].cf.request);
  //Set new headers

  //headers['content-security-policy'] = [{key: 'Content-Security-Policy', value: "default-src 'self' data: 'unsafe-inline' https://website.example.com https://stats.g.doubleclick.net https://www.google-analytics.com https://cdn.segment.com https://fonts.googleapis.com https://static.hotjar.com https://vars.hotjar.com https://script.hotjar.com https://fonts.gstatic.com https://www.google.com https://secure.gravatar.com https://www.gstatic.com;"}];
  headers['permissions-policy'] = [
    {
      key: 'Permissions-Policy',
      value:
        'geolocation=(), microphone=(), camera=(), magnetometer=(), gyroscope=()',
    },
  ];
  headers['strict-transport-security'] = [
    {
      key: 'Strict-Transport-Security',
      value: 'max-age=31536000; includeSubdomains; preload',
    },
  ];
  headers['report-to'] = [
    {
      key: 'Report-To',
      value:
        '{"group":"default","max_age":31536000,"endpoints":[{"url":"https://example.report-uri.com/a/d/g"}],"include_subdomains":true}',
    },
  ];
  //headers['nel'] = [{key: 'NEL', value: '{"report_to":"default","max_age":31536000,"include_subdomains":true}'}];
  headers['x-content-type-options'] = [
    { key: 'X-Content-Type-Options', value: 'nosniff' },
  ];
  //headers['x-frame-options'] = [{key: 'X-Frame-Options', value: 'SAMEORIGIN'}];
  headers['x-xss-protection'] = [
    { key: 'X-XSS-Protection', value: '1; mode=block' },
  ];
  headers['referrer-policy'] = [
    { key: 'Referrer-Policy', value: 'same-origin' },
  ];
  headers['access-control-allow-origin'] = [
    { key: 'Access-Control-Allow-Origin', value: '*' },
  ];

  callback(null, response);
};
