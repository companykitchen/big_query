# 0.0.1

* Initial version. Supports BigQuery job retrieval, and creation of some types of jobs.

# 0.0.2

* Added functionality to retrieve table info.

# 0.0.3

* HTTP errors return full response map for more insight into the error.
* Added ability to insert tables.

# 0.0.4

* Added streaming functionality.

# 0.0.5

* Removed "list all"-style behavior from Job and Table. Users should examine the returns structs to see if further requests are required (using the provided `pageToken`).

# 0.0.6

* Update dependencies.

# 0.0.7

* Added delete table functionality.

# 0.0.8

* Updated typespecs.
* Fixed compiler warnings. [PR #5](https://github.com/companykitchen/big_query/pull/5)
* Update dependencies. [PR #7](https://github.com/companykitchen/big_query/pull/7)

# 0.0.9

* Typespec update. [PR #8](https://github.com/companykitchen/big_query/pull/8)

# 0.0.10

* Added `maximumBillingTier` parameter for queries. [PR #10](https://github.com/companykitchen/big_query/pull/10/files)
* Added support for configuring additional scopes for your BigQuery access token. [PR #10](https://github.com/companykitchen/big_query/pull/10/files)

# 0.0.11

* Added `useLegacySql` query parameter. [PR #14](https://github.com/companykitchen/big_query/pull/14)
* Added `parameterMode` query parameter for "Standard SQL" queries. [PR #14](https://github.com/companykitchen/big_query/pull/14)
* Added `queryParameters` query parameter. [PR #14](https://github.com/companykitchen/big_query/pull/14)
* Added configurable timeout. [PR #12](https://github.com/companykitchen/big_query/pull/12)