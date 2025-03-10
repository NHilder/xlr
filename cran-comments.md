## Resubmission v3
This the third resubmission. In this version I have:

* Fixed title to follows CRAN's standards (moved from back-ticks to single
    quotes), e.g. `Excel` to 'Excel'! Sorry for the multiple submissions! 

## Resubmission
This the second resubmission. In this version I have:

* Changed the title so that `excel` is now lower case.

## Resubmission
This is a resubmission. In this version I have:

* Changed the title and description so that `Excel` is in single quotes. Note, this
  change now produces a NOTE during the automatic checks. This is because 
  the automatic checks say `Excel` should not be capitalised, however as a 
  proper noun it should be.

* Fixed the spacing in the DESCRIPTION.

* Fixed the examples so they no longer use `\dontrun`. We now use `\dontshow` to
  change the working directory so that we don't write to the working directory.
  This follows how `readr` implemented their examples.

* Removed documentation for functions that were internal only.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
* There are no references describing the methods used in this package.
