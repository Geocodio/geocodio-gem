## [2.0.0] - 2026-07-15
- **SECURITY**: Require `faraday >= 2.14.3` to address [CVE-2026-54297](https://github.com/advisories/GHSA-98m9-hrrm-r99r) — uncontrolled recursion in `Faraday::NestedParamsEncoder` allowing a stack-exhaustion denial of service via deeply nested query parameters.
- **BREAKING**: Raised `required_ruby_version` to `>= 3.0.0`. The patched Faraday 2.14.3 requires Ruby 3.0+, so Ruby 2.6/2.7 (both end-of-life) are no longer supported.
- Declared `faraday` and `faraday-follow_redirects` as explicit runtime dependencies in the gemspec (they were previously only present in the development `Gemfile`).

## [1.0.0] - 2026-06-05
- **BREAKING**: Migrated to Geocodio API v2 (base URL changed from `v1.11` to `v2`)
- **BREAKING**: Removed the top-level `input` object from `/geocode` and `/reverse` responses. The parsed address now lives in `results[].address_components`.
- **BREAKING**: Renamed keys inside `address_components` and `address_components_secondary`:
  - `zip` → `postal_code`
  - `state` → `state_province`
  - `secondaryunit` → `unit_type`
  - `secondarynumber` → `unit_number`

## [0.7.0] - 2026-03-12
- Updated default API version to v1.11

## [0.6.0] - 2026-02-24
- Updated API endpoint from v1.9 to v1.10

## [0.5.0] - 2026-01-06
- Added Distance API support:
  - `distance()` - Calculate distances from single origin to multiple destinations
  - `distanceMatrix()` - Calculate full distance matrix (multiple origins x destinations)
  - `createDistanceMatrixJob()` - Create async distance matrix jobs
  - `distanceMatrixJobStatus()` - Check job status
  - `distanceMatrixJobs()` - List all distance jobs
  - `getDistanceMatrixJobResults()` - Get completed job results
  - `downloadDistanceMatrixJob()` - Download results to file
  - `deleteDistanceMatrixJob()` - Delete a job
- Enhanced `geocode()` and `reverse()` with optional distance parameters
- Support for multiple coordinate formats (string, array, hash) with optional IDs
- Support for driving mode with duration estimates
- Support for distance filtering options (max_results, max_distance, etc.)
- Updated API endpoint from v1.8 to v1.9

## [0.3.0] - 2025-5-20
- Updated API endpoint from v1.7 to v1.8

## [0.1.1] - 2023-1-17
- Fixed CHANGELOG link typo

## [0.1.0] - 2023-1-11
- Initial release
