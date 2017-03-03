#  PandoraSamples
## `helpers/`

This directory contains a number of helper functions that you can use to produce samples for Pandora.

-------------------------------------------------------------------------------

### `new_project.sh`

#### Usage

```bash
source helpers/new_project.sh <new project name>
```

1. new project name - a unique name for your new project

#### Overview

Creates a new directories for your project under:
- `projects/`
- `/pnfs/uboone/scratch/users/<user name>/`
- `/pnfs/uboone/scratch/users/work/<user name>/`


-------------------------------------------------------------------------------

### `add_production.sh`

#### Usage

```bash
source helpers/add_production <existing project name> <nuance code> <cosmic / bnb >
```

1. existing project name - the name of your project (produced using `new_project.sh`
2. nuance code           - choose to filter on nuance codes `1001` `1003` `1004` or use keyword `all` to not filter at all
3. cosmic / bnb          - choose `cosmic` for a BNB + cosmic production, or `bnb` for pure BNB

#### Overview

Creates a new directory for the production under `projects/<project name>/<production details>/`. 
It also adds a "production chain" xml file which is will be passed to `project.py`.
This file breaks up the production into a number of stages:
- GENIE
- Nuance / fiducial neutrino filter (only used if `all` isn't specified)
- G4
- DETSIM
- PNDR (runs the core signal processing then writes `pndr` files before and after the `PandoraCosmic` pass)


