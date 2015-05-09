---
layout: post
title: Storing IP addresses the smarter way
---

If you need to store an IP address in a database, it's possibly because you're logging web requests or similar. This means the table can get very large, very quickly. If you're storing the addresses in a VARCHAR, you will use up a lot of space in your table and make indexing a nightmare. A lot of people don't know that you can represent these as an INT which is much more db-friendly.

IPv4 addresses are just 32-bit integers. In most languages (including in MySQL itself, useful for Sphinx indexes) you can use the equivalent of [inet_ntoa(3)] to convert to string and [inet_aton(3)] to convert to an int. In Ruby &nbsp;however this is hidden inside the [IPAddr] class. This instantiation can be quite expensive for what is really a simple conversion, so you can use the following:

```ruby
def inet_aton ip
  ip.split(/\./).map{|c| c.to_i}.pack("C*").unpack("N").first
end

def inet_ntoa n
  [n].pack("N").unpack("C*").join "."
end
```
Storing these correctly can save huge performance headaches later.

[inet_ntoa(3)]: http://linuxmanpages.com/man3/inet_ntoa.3.php
[inet_aton(3)]: http://linuxmanpages.com/man3/inet_aton.3.php
[IPAddr]: http://www.ruby-doc.org/stdlib-1.9.3/libdoc/ipaddr/rdoc/IPAddr.html