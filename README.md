# Minimum viable pipeline in Nextflow

Scaffold for demonstration in the Bioinformatics Clinic session (2023-09-25)

## Build stages

I built the pipeline incrementally and commited at different stages, which are available as [branches of this repository](https://github.com/esteinig/nf-mvp/branches). Commit messages explain the main features and commit differences detail the [exact changes](https://github.com/esteinig/nf-mvp/commit/6d3c4bb2842377f3c0914d38ea0385ea818c50e2). All commits were merged into `main` with a final stage [pull request](https://github.com/esteinig/nf-mvp/pull/1).

## Directory structure

Directory structure for a modular Nextflow pipeline:

- `env/`: dependency environments
  - `conda.yml`: base conda environment for local execution
- `test/`: test files for the workflow
- `lib/`: nextflow library folder
  - `process/`: nextflow process definitions (`.nf`)
  - `workflow/`: nextflow subworkflow definitions (`.nf`)
  - `utils.nf`: nextflow utility functions
- `main.nf`: nextflow main entry script
- `nextflow.config`: nextflow config file

## Requirements

`Conda` or `Mamba` installation.

## Local setup

Clone directory for environment setup:

```
git clone https://github.com/esteinig/nf-mvp
```

Install and activate environment:

```
mamba env create -f nf-mvp/env/conda.yml && conda activate nf-mvp
```

Run the Nextflow with the `test` profile:

```
nextflow run nf-mvp/main.nf -profile test
```

## Repository execution

With latest `Nextflow` installed:

```
nextflow run esteinig/nf-mvp -profile conda,test
```

With `Mamba` environment installer instead of `Conda`:

```
nextflow run esteinig/nf-mvp -profile conda,test --mamba
```

## Tips and tricks

There are lots of different ways to do things, so these are highly opinionated tips for getting started.

0.  Consider whether you need a (rather complex) pipeline framework in the first place

1.  Assign a file-based identifier for input/output in all processes to keep track of the identity of the reads that are being processed.

    File paths have useful methods like `getSimpleName()`: https://www.nextflow.io/docs/latest/script.html#check-file-attributes

2.  Be explicit in defining processes belonging to specific analysis modules.
    
    It is often easier to define a similar process (at the cost of verbosity) that meets
    the input/output requirements of a module than defining a generalized process that relies
    on channel operations to receive the correct input or produce the correct outputs.

3.  Channels and channel operators can be piped: https://www.nextflow.io/docs/latest/dsl2.html#pipes

4.  Modularize workflows and processes into a library that can be reused: https://www.nextflow.io/docs/latest/dsl2.html#workflow 

5.  Define named output channels for flexible and consistent output schemas: https://www.nextflow.io/docs/latest/dsl2.html#process-named-output 

    For tuple outputs with named emission use the parentheses pattern: `tuple (val(id), path("filtered.fq"), emit: reads)`

6. When testing a pipeline use a small input file that meets minimum criteria - iteration on channel operations and other more complex methods can be tested faster.

7. Tags with identifiers and parameters can be helpful in tracking progress on specific parameterized processes.

8. Develop simple workflows from the ground up e.g. in `main.nf`, modularize when tested.


## Dependencies

- [`Nextflow`](https://github.com/nextflow-io/nextflow)
- [`Rasusa`](https://github.com/mbhall88/rasusa)
- [`Nanoq`](https://github.com/esteinig/nanoq)
- [`minimap2`](https://github.com/lh3/minimap2)
