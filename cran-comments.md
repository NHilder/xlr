── R CMD check results ─────────────────────────────────────────────────── xlr 1.1.1 ────
Duration: 1m 19.6s

❯ checking CRAN incoming feasibility ... [4s/29s] NOTE
  Maintainer: ‘Nicholas Hilderson <nhilderson.code@gmail.com>’
  
  Days since last update: 3

0 errors ✔ | 0 warnings ✔ | 1 note ✖

Sorry about the short time between submissions, it is so that `dplyr` will pass
reverse dependency checks before their 1.2.0 (February) release. 

Unfortunately, I received a pull request from <Davis Vaughan, davis@posit.co> on
the day after my submission. `dplyr` is changing the behaviour of one of its 
functions, and my code was causing them to fail a reverse dependency check. 
This patch will result in their check passing. See the pull request 
https://github.com/NHilder/xlr/pull/12


