## [0.4.0] - 2025-12-17
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
