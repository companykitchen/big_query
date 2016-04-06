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