## Overview
[![Build Status](https://travis-ci.org/patricklucas/puppet-uzblmonitor.png)](https://travis-ci.org/patricklucas/puppet-uzblmonitor)

`uzblmonitor` is an automatic monitor manager.

## About

`uzblmonitor` reads state information from a JSON file on disk and generates a respective i3 workspace.

## UI

To use with `uzblmonitor-ui`, a few additional components are neeeded:

* (puppet-consul_template)[https://github.com/Intelliplan/puppet-consul_template]

```
consul-template -consul localhost:8500 -template "/home/monitor/uzblmonitor-state.json.ctmpl:/home/monitor/uzblmonitor-state.json:service uzblmonitor restart"
```
#### State

An extremely basic state file looks like:

```
{
    "mode": "window",
    "split": "splith",
    "percent": 1,
    "children": [{
        "mode": "terminal",
        "percent": 0.5,
        "command": "echo hello"
    }, {
        "mode": "terminal",
        "percent": 0.5,
        "command": "echo world"
    }]
}
```

This would create a side-by-side layout with two terminal emulators.

A `window` is the main layout element and can contain multiple children (either other `window`'s or Adapter definitions). The `percent` option controls how much of the parent is occupied. The `split` option must be either `splith` or `splitv` and defines how the children will be tiled.

#### Adapters

Adapters allows new plugins to be developed while still using `uzblmonitor`'s layout generation tools. Currently 
available adapters include:

- URL (`shows a webpage`)
  * Expects `jumanji` executable to be found in $PATH

- Terminal (`run an arbitrary command in a terminal emulator`)
  * Expects `jumanji` executable to be found in $PATH
