# Day 1

Source: https://adventofcode.com/2021/day/1

In short, we have a following "features" of the system, to be implemented:
- Submarine can perform sonar sweep
- Depth Analyzer can process sonar sweep results

These are just an overview of "what" the system can do, without details on "how" it should be implemented.

In order to start on the "how" part, we can define "use cases", thinking about possible inputs, outputs and entities.

## Use Cases

### 1. Perform Sonar Sweep

#### Entities
1. "Submarine" - domain entity
2. "Depth" - measurement type

#### Main flow
1. System performs sonar sweep
2. System delivers depths list

#### Output
1. List of "depths"

### 2. Process Depths List Results

#### Entities
1. "Depth" - measurement type

#### Main flow
1. System returns the count of times a depth measurements increases from the previous measurement

#### Failure flow (empty List of depths)
1. If depths list is empty, system returns "Empty Depths List" error (we could have just return 0 in this case, but it sounds like an unexpected input, as submarine performs sonar sweep only when submerged in water, so we'd better return explicit error in this case)

#### Output
1. Number of times the "depth" increases