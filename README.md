### Database System Architecture Project 👨🏻‍💻

</br>

<div>
  <a href="https://open.vscode.dev/mohammadzainabbas/database-system-architecture-project" target="_blank" style="cursor: pointer;"> 
    <img src="https://open.vscode.dev/badges/open-in-vscode.svg" style="cursor: pointer;"/>
  </a>
</div>

### Table of contents

- [Introduction](#introduction)
- [Project Overview](#project-overview)
  * [Statistics](#statistics)
  * [Selectivity Estimations](#selectivity-estimations)
  * [Join Estimations](#join-estimations)
- [Debugging Guide](#debugging-guide)
- [Benchmark Guide](#benchmark-guide)

---

<a id="introduction" />

#### 1. Introduction

Range types are data types representing a range of values of some element type (called the `range's subtype`). For example, _ranges of timestamp_ might be used to represent the ranges of _time_ that a meeting room is reserved. In this case the data type is `tsrange` (short for “_timestamp range_”), and timestamp is the subtype. The subtype must have a total order so that it is well-defined whether element values are within, before, or after a range of values.

---

<a id="project-overview" />

#### 2. Project Overview

The aim of this project is to improve the overall scheme of statistics collection and cardinality estimation for range types in PostgreSQL.

So, project can be divided up into three parts:

- [x] Statistics
- [x] Selectivity Estimations
- [x] Join Estimations

> Note: We will be working with PostgreSQL 13 stable version for the development purpose.

---

<a id="statistics" />

##### 2.1. Statistics

In the current implementation, you have `range_typeanalyze` function which is called whenever you do `vacuum analyze` on some relation/table having a range type. You can find the function definition for `range_typeanalyze` [here.](https://github.com/postgres/postgres/blob/f76fd05bae047103cb36ef5fb82137c8995142c1/src/backend/utils/adt/rangetypes_typanalyze.c?_pjax=%23js-repo-pjax-container%2C%20div%5Bitemtype%3D%22http%3A%2F%2Fschema.org%2FSoftwareSourceCode%22%5D%20main%2C%20%5Bdata-pjax-container%5D#L43)


This function sets few configurations/settings and sets a handle for computing range type stats

```cpp
stats->compute_stats = compute_range_stats;
```

Here, we are setting `compute_range_stats` function as a handle to be called later for computing stats.

When you will look into `compute_range_stats` function (see [here](https://github.com/postgres/postgres/blob/f76fd05bae047103cb36ef5fb82137c8995142c1/src/backend/utils/adt/rangetypes_typanalyze.c?_pjax=%23js-repo-pjax-container%2C%20div%5Bitemtype%3D%22http%3A%2F%2Fschema.org%2FSoftwareSourceCode%22%5D%20main%2C%20%5Bdata-pjax-container%5D#L97)), you will notice that three different kinds of histograms are being calculated.

- _Lower Bound Histogram_
- _Upper Bound Histogram_
- _Length based Histogram_

And we store all these into the `pg_statistics` for later usage.

> Note: These stats are usually calculated once per million or so inserts. Or when you do `vacuum analyze` statement.

The first goal of our project is to determine which statistics should we calculate during the analysis phase. Do we need something extra for doing proper/better estimations for selectivity and joins for range type. 

---

<a id="selectivity-estimations" />

##### 2.2. Selectivity Estimations

The second goal of our project is to implement selectivity estimation functions for the _overlaps_ `&&` and the _strictly left_ of `<<` predicates/operators.

---

<a id="join-estimations" />

##### 2.3. Join Estimations

The final and main goal of our project is to implement join cardinality estimation for the overlaps `&&` predicate/operator for the range type.

---

<a id="debugging-guide" />

#### 3. Debugging Guide

Please refer to [debugging guide](https://github.com/mohammadzainabbas/database-system-architecture-project/blob/main/docs/DEBUG.md) for more details.

---

<a id="benchmark-guide" />

#### 4. Benchmark Guide

To run the benchmarks on different `range_type`, follow the below mentioned steps:

1. Clone this repo

```bash
git clone https://github.com/mohammadzainabbas/database-system-architecture-project.git
cd database-system-architecture-project
```

2. Run the benchmark script
```bash
sh scripts/run_benchmark.sh -d test
```

> Note: Replace `test` with the name of your database

> Note: If you see an error `Binary 'psql' not found'`, run the following command and re-try:

```bash
echo 'export PATH="/usr/local/pgsql/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```
