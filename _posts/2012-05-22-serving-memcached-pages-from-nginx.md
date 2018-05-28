---
layout: post
title: Serving Memcached Pages from Nginx
---

Up until recently, the internal Rails services that make up our Mobile platform utilised [action caching](http://guides.rubyonrails.org/caching_with_rails.html#action-caching) for a lot of requests. When data is rendered it gets compressed and cached in memcached, ready to be served by the Rails app next time that action is called.

Now we're going one better and caching the raw page in [memcached](http://memcached.org/) and allowing this to be served direct from [nginx](http://nginx.org). This is providing a speed improvment from ~10ms down to ~1.5ms per request as we bypass the Rails stack completely and cut down on connections to our upstream application servers. 

To do this, we need to make some modifications to Rails' [page caching](http://guides.rubyonrails.org/caching_with_rails.html#page-caching) facility as it only caches onto disk. Enter [memcaches_page](http://globaldev.co.uk/memcaches_page/), a gem we've written to share this logic across all our services. Drop this into your `Gemfile` and use `caches_page` as normal. It'll use your existing `cache_store` settings and store the page using the `fullpath` as the key. Now all we need to do is update our nginx configuration to serve this:

```nginx
  server {
    listen 80;
    server_name our-awesome-service;
    
    location / {
      # Only use this method for GET requests.
      if ($request_method != GET ) {
        proxy_pass http://our-awesome-service-upstream;
        break;
      }
    
      # Attempt to fetch from memcache. Instead of 404ing, use
      # the @fallback internal location
      set $memcached_key $request_uri;
      # Use an upstream { } block for memcached resiliency
      memcached_pass memcached-upstream; 
      default_type application/json; # Our services only speak JSON
      error_page 404 = @fallback;
    }

    location @fallback {
      proxy_pass http://our-awesome-service-upstream;
    }
  }
```

The benefit of this caching is clear. Running requests unnecessarily through the Rails stack blocks more important requests from being fulfilled. So not only does this change speed up the individual fetching of the endpoints we are caching, it frees up the app servers to process the uncacheable actions such as logging in, searching and sending messages.

The next steps on our continual quest to keep our mobile platform nice and speedy include:

* Switching to [JRuby](http://jruby.org/) in order to use native threads, allowing us to serve more concurrent requests with a far lower memory overhead.
* Enabling [HTTP Streaming](http://weblog.rubyonrails.org/2011/4/18/why-http-streaming/). This  allows mobile devices to get a head start on downloading CSS and JS assets whilst we finish preparing the request. 
* Parallelising requests from the mobile application rather than fetching member information and message text one-by-one.

This post originally appeared on the [globaldev blog](http://globaldev.co.uk/2012/06/serving_memcached_pages_from_nginx/)
