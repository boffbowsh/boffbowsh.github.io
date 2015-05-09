---
layout: post
title: Running Goliath on a UNIX domain socket
---

EventMachine supports listening on UNIX domain sockets, therefore [Goliath] does too.
Simply create a config file as per the [instructions] on the wiki with the following:
```ruby
port = nil
```
This makes EventMachine take the address parameter as a unix socket, so simply run your server in the following way:
```bash
ruby hello_world.rb -sva hello_world.sock
```
You can then serve it up using nginx:
```nginx
http {
  server {
    listen 80 default;
    
    location / {
      proxy_pass http://unix:///Users/boffbowsh/code/hello_world/hello_world.sock;
    }
  }
}
```

[Goliath]: http://goliath.io/
[instructions]: https://github.com/postrank-labs/goliath/wiki/Configuration