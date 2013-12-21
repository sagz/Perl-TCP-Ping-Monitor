#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket;
use threads;
use Thread::Queue;

# Defaulting to 42424
my $port = $ARGV[0] || 42424;

# Storing list of connected clients sensors to monitor
my %clients;
my $queue = Thread::Queue -> new;
my $monitor = threads->create ("monitor", $queue);

# This probably might not be of use
$SIG{CHLD} = 'IGNORE';

my $listen_socket = IO::Socket::INET->new(LocalPort => $port,
                                          Listen => 10,
                                          Proto => 'tcp',
                                          Reuse => 1);
# Confirm we are listening
die "Can't listen on socket: $@" unless $listen_socket;

warn "Server ready. Listening to port $port\n";

# Process TCP data after accepting connection
while (my $connection = $listen_socket->accept) {
    # spawning a thread per client sensor
    # Could potentially do this with IO Multiplexing too
    threads->create ("read_data", $queue, $connection)->detach;
}

sub read_data {
    # accept data from the socket and put it on the queue
    my ($queue, $socket) = @_;
    while (<$socket>) {
        print "Received: $_";
        $queue -> enqueue(time." $_");
    }
    close $socket
}

sub monitor {
    my $queue = shift;

    # As of now, the monitor is invoked only every 30 seconds
    while (1) {
        while ($queue -> pending) {
            my $data = $queue -> dequeue;
            print "monitor got: $data\n";
            $data =~ /(\d+) (\S+): Next ping in (\d+) seconds/;
            my $time       = $1;
            my $client     = $2;
            my $frequency  = $3;

            if ((defined $clients{$client}) and $clients{$client} -> [0] eq 'NAK') {
                print "$client sent a ping again\n";
            }
            $clients{$client} = [ 'OK', $time + $frequency];
        }
        for my $client (keys %clients) {
            next if $clients{$client}->[0] eq 'NAK';
            next if $clients{$client}->[1] > time;
            print "$client missed a signal ping, expected at $clients{$client}->[1], now it is ".time."\n";
            $clients{$client}->[0] = 'NAK';
        }
        sleep 10;
    }
}
