# Day 2

Source: https://adventofcode.com/2021/day/2

Now we need to enrich our submarine features:
- Submarine can react to movement commands ("forward", "down", "up")
- Navigator can calculate final position after taking a sequence of movement commands

Let's think about new entities introduced today.
First it would be "MovementCommand". List of movement commands we can name "MovementRoute".
For "Submarine" we have "depth" from the 1st day, and we need to add "horizontal position".
As submarine starts from the ship, this "horizontal position" is in fact horizontal distance to a ship.


## Use Cases

### 1. Submarine reacts to Movement Command

#### Entities
1. "Submarine" - domain entity
2. "MovementCommand" - domain entity ("forward", "down", "up")

#### Main flow (forward)
1. Submarine receives forward command with amount
2. Submarine increases horizontal distance by amount

#### Main flow (down)
1. Submarine receives down command with amount
2. Submarine increases depth by amount

#### Main flow (up)
1. Submarine receives up command with amount
2. Submarine decreases depth by amount

#### Failure flow (down)
1. If submarine would not able to perform full movement amount, return "Not enough depth to move" error

#### Failure flow (up)
1. If submarine would not able to perform full movement amount, submarine moves to the see level.


### 2. Navigator calculates final position from MovementRoute

#### Entities
1. "Navigator" - domain entity
2. "MovementRoute" - sequence of "MovementCommand"(s)

#### Input
1. Initial position
2. MovementRoute

#### Main flow
1. Navigator calculates final position after processing MovementRoute

#### Failure flow (unexpected final position)
1. If final position has negative depth, return "Wrong Movement Route" error

#### Output
1. Final position

