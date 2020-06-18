RFLprod README
================

RFLprod R package
------------------

A package of functions to help ensure RFL R scripts run well in production.

Installation
------------

You will have to install it directly from Github using devtools.

If you do not have the devtools package installed, you will have to run the first line in the code below.

To install from a private github repository, generate a personal access token (PAT) in https://github.com/settings/tokens and supply to this argument. This is safer than using a password because you can easily delete a PAT without affecting any others. Defaults to the GITHUB_PAT environment variable.

``` r
# install.packages('devtools')
devtools::install_github('royal-free-london/RFLprod', auth_token=XXX)
```
