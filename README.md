Ring Benchmark in Erlang
=========

This is my solution for the exercise in ["Programming in Erlang"](http://pragprog.com/book/jaerlang/programming-erlang):

> Write a ring benchmark. Create N processes in a ring. Send a message round the ring M times so that a total of N * M messages get sent.
> Time how long this takes for different values of N and M.

Hot to Run
--------------
Make Sources

    $ make clean all

Run the benchmark. (for fixed parameters, N = 10,  M = 50)

    $ make run

(The case you want to set your parameters, you can invoke benchmark function directly in Erlang shell.)

    $ erl
    1> ringbench:start(20, 200)  % N = 20, M = 200

Sample Output
----------------
    $ erl
    1> ringbench:start(3, 1).
    constructing 3 nodes ring...
    [main(<0.31.0>)] start injecting 1 tokens.
    [0(<0.49.0>)] starting...
    [2(<0.50.0>)] starting...
    [1(<0.51.0>)] starting...
    [0(<0.49.0>)] token "1" is injected. forward to <0.51.0>.
    [0(<0.49.0>)] token "kill" is injected. forward to <0.51.0>.
    [1(<0.51.0>)] token "1" received. forwading to <0.50.0>
    [1(<0.51.0>)] exitting...
    [2(<0.50.0>)] token "1" received. forwading to <0.49.0>
    [2(<0.50.0>)] exitting...
    [0(<0.49.0>)] token "1" reaches root.
    [0(<0.49.0>)] exitting...
    [0(<0.49.0>)] report the finish of benchmark to main(<0.31.0>)
    [main(<0.31.0>)] ring benchmark for 3 processes and 1 tokens = 0 (1) milliseconds

Licence
----------------
The benchmark codes are licensed under MIT License. See LICENSE.txt for further details.

Copyright
---------
Copyright (c) 2012 [everpeace](http://twitter.com/everpeace).

