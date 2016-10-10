## 0.1.6 (2016-09-10)

Features:
* Add new method for producing graphs from .gemspec and Gemfile.lock file contents, called produce_gems_graph_from_gemspec.

## 0.1.5 (2016-09-07)

Features:
* Clients can now set the direction of the produced tree
* Read directly requested gems and the dependencies of those by parsing the Gemfile and the Gemfile.lock

## 0.1.4 (2016-09-05)

Features:
* Add colors to nodes and edges

## 0.1.3 (2016-09-04)

Features:
* Allow clients to set the directory they want for the graphs to be generated into

## 0.1.2 (2016-09-04)

Fixes:
* Regex is now updated to support gems without version set

Features:
* Allow clients to set if they want the gem version in the graph
* Read through the whole Gemfile.lock content (not just the first)

## 0.1.1 (2016-09-02)

Fixes:
* Understand \r\n as multilined text

## 0.1.0 (2016-08-01)

Initial release