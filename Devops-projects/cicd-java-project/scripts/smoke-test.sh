#!/usr/bin/env bash
# =======================================================
# smoke-test.sh — Post-deploy smoke tests
# Usage: bash scripts/smoke-test.sh <BASE_URL>
# =======================================================
set -euo pipefail

BASE_URL="${1:-http://localhost:8080}"
PASS=0
FAIL=0
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

pass() { echo -e "${GREEN}✅ PASS${RESET}: $1"; ((PASS++)); }
fail() { echo -e "${RED}❌ FAIL${RESET}: $1 — $2"; ((FAIL++)); }

echo "========================================="
echo "  Smoke Tests against: $BASE_URL"
echo "========================================="

# 1. Actuator health
echo "→ [1] Actuator health endpoint"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/actuator/health")
[[ "$STATUS" == "200" ]] && pass "/actuator/health returns 200" \
  || fail "/actuator/health" "expected 200, got $STATUS"

# 2. Health check returns UP
echo "→ [2] Health status is UP"
BODY=$(curl -s "$BASE_URL/actuator/health")
echo "$BODY" | grep -q '"status":"UP"' \
  && pass "Health status is UP" \
  || fail "Health status" "body: $BODY"

# 3. App-level health endpoint
echo "→ [3] App /api/products/health"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/products/health")
[[ "$STATUS" == "200" ]] && pass "/api/products/health returns 200" \
  || fail "/api/products/health" "expected 200, got $STATUS"

# 4. List products returns 200
echo "→ [4] GET /api/products returns 200"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/products")
[[ "$STATUS" == "200" ]] && pass "GET /api/products returns 200" \
  || fail "GET /api/products" "expected 200, got $STATUS"

# 5. Create a product
echo "→ [5] POST /api/products creates a product"
RESPONSE=$(curl -s -X POST "$BASE_URL/api/products" \
  -H "Content-Type: application/json" \
  -d '{"name":"Smoke Widget","price":9.99,"description":"smoke test"}')
echo "$RESPONSE" | grep -q '"name":"Smoke Widget"' \
  && pass "POST /api/products creates product" \
  || fail "POST /api/products" "response: $RESPONSE"

# 6. 404 for unknown product
echo "→ [6] GET /api/products/999999 returns 404"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/products/999999")
[[ "$STATUS" == "404" ]] && pass "GET /api/products/999999 returns 404" \
  || fail "GET /api/products/999999" "expected 404, got $STATUS"

# Summary
echo ""
echo "========================================="
echo "  Results: ${PASS} passed, ${FAIL} failed"
echo "========================================="

[[ "$FAIL" -gt 0 ]] && exit 1 || exit 0
