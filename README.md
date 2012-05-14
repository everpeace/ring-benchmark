Ring Benchmark in Erlang
=========

This is my solution for the exercise in ["Programming in Erlang"](http://pragprog.com/book/jaerlang/programming-erlang):

> Write a ring benchmark. Create N processes in a ring. Send a message round the ring M times so that a total of N * M messages get sent.
> Time how long this takes for different values of N and M.

Hot to Run
--------------
1. Make Sources
    $ make clean all
2. Run the benchmark. (for fixed parameters, N = 10,  M = 50)
    $ make run
3. (The case you want to set your parameters, you can invoke benchmark function directly.)
    $ erl
    > ringbench:start(20, 200)  % N = 20, M = 200

Licence
----------------
The benchmark codes are licensed under MIT License. See LICENSE.txt for further details.

Copyright
---------
Copyright (c) 2012 [everpeace](http://twitter.com/everpeace).

