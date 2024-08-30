#!/usr/bin/env bash
set -xe
set -o pipefail

helm dependency update . --skip-refresh
helm lint . --debug --namespace testns --strict --with-subcharts --values values.yaml

# Test ConfigMap
helm template --debug --namespace testns app1 . --show-only templates/ConfigMap.yaml --values values-example.yaml | tee kub-app-test-out/generate-configmap1.yaml
diff kub-app-test-out/configmap1.yaml kub-app-test-out/generate-configmap1.yaml

# Test Secret
helm template --debug --namespace testns app1 . --show-only templates/Secret.yaml --values values-example.yaml | tee kub-app-test-out/generate-secret1.yaml
diff kub-app-test-out/secret1.yaml kub-app-test-out/generate-secret1.yaml

# Test ServiceAccount

# Test cluster
helm template --debug --namespace testns app1 .  --values kub-app-test-git/values.yaml --values kub-app-test-git/example-env/values.yaml \
 --values kub-app-test-git/example-env/example-ns/values.yaml --values kub-app-test-git/example-env/example-ns/example-service/values.yaml |  tee kub-app-test-out/generate-cluster1.yaml
diff kub-app-test-out/cluster1.yaml kub-app-test-out/generate-cluster1.yaml
