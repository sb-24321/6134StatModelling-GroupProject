# MTH6134 STATISTICAL MODELLING II GROUP PROJECT

## This is the documentation for this codebase, in particular GeneralModel.R describing 
## the methods and usage for it.

## Summary
This codebase is designed as a intuitive toolbox, allowing users to perform the various
operations that was shown in lectures and content simply which allows us focus
more on the analysis than the programming part.

## Design Philosophy
While we strive to create a comprehensive system for statistical modelling in line with
the teaching content and this project, it would be infeasible and time-consuming to create 
an all inclusive system that did everything that the user could ever want like table 
manipulation (packages like `dplyr` can be used instead).

The core idea is to take the ideas seen in related notes and lectures, the several lines
of R code it would take to replicate those concepts and reduce it to a single, easily 
accessable function that keeps other scripts easily readable and to the point.

## Capabilities
This package is currently able to do the following:
> Create Normal regression models.  (useful for discrete data)

> Create Poission regression models. (useful for continous data)

> Create Bionmial regression models. (useful for bionmial data)


## Structure
This codebase is structured as follows:

### GeneralModel/
The code directory is where all the implementation and programming goes. The major package
here is the `GeneralModel.R` file. Calling this will give user access to the rest of the
functionality of this package.

### outputs/
This directory holds all the graphs and plots that could be generated. When `GeneralModel` 
creates any file ouput (for example creating a .png or creating a .pdf) it will search for
this directory in order to save the file into it. Also note that it is possible to create
subdirectories within `outputs/`, however, this cannot be created by the model.

### data/
While not essential to GeneralModel (since it does not access it directly), we note that
all the data for this project is stored within this folder.

## Usage
This is the most important section when it comes to general usage of the package. This 
section will highlight all the capabilities and usage, and keep it simple in order to 
develop rather than understand the intricate details (that section will be later). Examples 
provided where convinent.

### Getting Started.
As this is not an official package, it will have to be imported and treated differently 
than a normal package. Starting from the parent directory, ideally you would also structure 
your environment the same where you have the `GeneralModel/` and `outputs/` 
directories. So for example:

.
| GeneralModel/
| data/
| outputs/ 
| analysis1.R
| code/

You will know you are in the parent directory if `source('./GeneralModel/GeneralModel.R')` 
in any file does not give you an error. You can see which directory you are in by checking 
the output of `getwd()` in R. 

Once you are able to run code from the parent directory, then you are able to write code
anywhere. Ideally, treat `GeneralModel` as a read-only directoy (so don't write anything 
in it).

### Function Documentation.
Now that it is possible to import `GeneralModel.R` into any file, we will now look at the
real functions of this package. Exploring all the capabilites of GeneralModel. This will
serve as the code documentation, highlighting each functions parameters, operations and 
outputs.

#### CreateModel
##### Summary
Function will create a regression model based on the given model type. The idea is to take
the dataset we are referring to, give the function the column name of the response variable
(y) and the column name(s) of the explanatory variables (x)
##### Paramters
`data`: 
(dataframe) The full dataset we are referring to.
`response_var`: 
(string or list) The column name of the variable we say to be our response variable, y.
`explanatory_vars`
(string or list): Name of the column(s) of the variables we will take to be our explanatory variables.
`model_type`:
(string) This will specify what type of model we would like to fit. There are currently
three options: 'normal' (which is the default value), 'bionmial' and 'poisson'.
##### Outputs
This is return a linear model (if model type is normal) or a generalised linear model (if
other types are used). 




## Mathematical Methods
This section will explain the mathematical methods used to produce the outputs for various
functions. THe method will be described and the corresponding R snippet that performs the
method.
