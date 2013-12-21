Simple Uptime Monitor
================

A multithreaded server monitors pings sent from multiple clients and alerts if such a sensor went down (stopped sending pings)

Consider a simplistic [Pingdom](http://pingdom.com), if you will.

How to set it up
================

1. Check your Perl version in a shell with  
`perl -v`  
Note: This project has been tested on a Unix box with Perl v5.16.2; YMMV.  
2. Clone this repo or download the zipped archive  
`https://github.com/sagz/Perl-TCP-Ping-Monitor/archive/master.zip`
3. Profit.

Usage
==
There are two parts, server and client(s)  
1. Run the server first. By default, it listens on port [42424](https://en.wikipedia.org/wiki/Answer_to_the_Ultimate_Question_of_Life,_the_Universe,_and_Everything#Answer_to_the_Ultimate_Question_of_Life.2C_the_Universe.2C_and_Everything_.2842.29).  
`$ ./server.pl`  
Command line arguments:  `$ ./server.pl [port]`  
The server accepts an optional commandline argument for the port to listen on. An integer between `[1-65535]`  
2. Now run a client. By default, it tries to connect on `127.0.0.1:42424` with 'ping' frequency of 1 second and client name as the machine's hostname.  
`$ ./client.pl`  
Command line arguments:
`$ ./client.pl [server_IP] [server_port] [frequency] [self_name]`

Example Run
==
`$ ./server.pl`  

And two+ separate shells with:  
`$ ./client.pl 'localhost' 42424 2 'Hans'`  
`$ ./client.pl 'localhost' 42424 10 'Chewbacca'`  


Features
==
+ Multi Threaded
+ Lightweight (Server memory footprint <1MB, with 50 clients running)
 
To - Do
==
+ Sanitize command line arguments
+ ANSI Colour output!
+ Rigorous testing suite
