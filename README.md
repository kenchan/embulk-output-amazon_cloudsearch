# Amazon Cloudsearch output plugin for Embulk

Embulk output plugin to insert data into Amazon CloudSearch

## Overview

* **Plugin type**: output
* **Load all or nothing**: no
* **Resume supported**: no
* **Cleanup supported**: no

## Configuration

- **endpoint**: Amazon CloudSearch Document Endpoint URL (string, required)
- **id_column**: document id column (string, required)
- **upload_columns**: index columns (string, required)
- **batch_size**: number of records in one bulk request (int, default: 1000)
- **stub_response**: CloudSearch API Client stubbing (boolean, default: `false`)

## Example

```yaml
out:
  type: amazon_cloudsearch
  endpoint: https://cloudsearch.example.com/endpoint
  id_column: id
  upload_columns:
    - title
    - timestamp
```

## Build

```
$ rake
```
