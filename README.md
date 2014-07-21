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
    [main(<0.31.0>)] constructing 3 nodes ring...
    [main(<0.31.0>)] injecting the token "1".
    [0(<0.33.0>)] starting...
    [1(<0.34.0>)] starting...
    [2(<0.35.0>)] starting...
    [0(<0.33.0>)] token "token" is injected from main. the token starts rounding in the ring.
    [1(<0.34.0>)] token "{0, token}" received. forwading to <0.35.0>
    [2(<0.35.0>)] token "{0, token}" received. forwading to <0.33.0>
    [0(<0.33.0>)] token "token" reaches root 1 times.
    [0(<0.33.0>)] report the finish of benchmark to main(<0.31.0>)
    [main(<0.31.0>)] ring benchmark for 3 processes and 1 tokens = 0 (4) milliseconds
    [1(<0.34.0>)] exitting...
    [2(<0.35.0>)] exitting...
    [0(<0.33.0>)] exitting...

Ring Benchmarks in Other Languages
----
* [everpeace/ring-benchmark-in-akka](https://github.com/everpeace/ring-benchmark-in-akka): ring benchmark in [Akka](http://akka.io/) (Scala).
* [everpeace/ring_benchmark_in_elixir](https://github.com/everpeace/ring_benchmark_in_elixir): ring benchmark in [Elixir](http://elixir-lang.org/).

Licence
----------------
The benchmark codes are licensed under MIT License. See LICENSE.txt for further details.

Copyright
---------
Copyright (c) 2012 [everpeace](http://twitter.com/everpeace).

