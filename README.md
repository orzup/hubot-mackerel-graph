# hubot-mackerel-graph

Giving hubot the graph URL of your mackerel organization

See [`src/mackerel.coffee`](src/mackerel.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-mackerel-graph --save`

Then add **hubot-mackerel-graph** to your `external-scripts.json`:

```json
[
  "hubot-mackerel-graph"
]
```

## Configuration
**Environmental variables**
```
HUBOT_MACKEREL_API_KEY - mackerel api key
HUBOT_MACKEREL_ORG     - mackerel organization name
```

## Commands

```
hubot:
- (mkr|mackerel) - returns a list of services in your org
- (mkr|mackerel) <service name> - returns a list of roles in your orgs services
- (mkr|mackerel) <service name> <role name> - return a URL of loadavg5 in your orgs services role
- (mkr|mackerel) <service name> <role name> <graph name> - return a URL of graph in your orgs services role

```
