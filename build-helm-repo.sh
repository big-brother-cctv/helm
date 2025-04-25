#!/bin/bash

set -e

# Config
CHARTS_DIR="charts"
OUTPUT_DIR="docs"
REPO_URL="https://big-brother-cctv.github.io/helm"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "📦 Packaging charts at '$CHARTS_DIR'..."
for chart in "$CHARTS_DIR"/*/; do
  helm package "$chart" -d "$OUTPUT_DIR"
done

echo "🗂 Generating index.yaml with URL '$REPO_URL'..."
helm repo index "$OUTPUT_DIR" --url "$REPO_URL"

echo "✅ Charts packaged and Helm repository updated at '$OUTPUT_DIR'"
