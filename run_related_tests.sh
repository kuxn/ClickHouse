#!/bin/bash
# Start the server, run new and existing tests, stop the server.

mkdir -p tmp/ch_server
pushd tmp/ch_server
../../build/programs/clickhouse server > server.log 2>&1 &
popd
trap "kill $!" EXIT

failed=0

echo "New tests:"
tests/clickhouse-test 05448_similar_to_escape_negated_bracket || failed=1

echo "Existing tests:"
tests/clickhouse-test \
    04051_similar_to \
    04402_similar_to_analyzer_cnf \
    04040_like_escape \
    04277_text_index_function_like_escape \
    04292_primary_key_like_escape_bug105885 \
    04351_bloom_filter_text_index_like_escape \
    05147_ngrambf_like_escaped_backslash_run || failed=1

exit $failed
