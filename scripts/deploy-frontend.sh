name: Frontend CI/CD

on:
  push:
    branches: [main]
    paths: ['Client/**']

env:
  AWS_REGION: us-east-1
  NODE_VERSION: '18'

jobs:
  deploy:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: Client

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: Client/package-lock.json

      # Step 1 — Install
      - name: Install
        run: npm ci

      # Step 2 — Security scan
      - name: Security audit
        run: npm audit --audit-level=high
        continue-on-error: true

      # Step 3 — Build
      - name: Build
        run: npm run build
        env:
          VITE_API_URL: ${{ secrets.VITE_API_URL }}

      # Step 4 — Configure AWS
      - name: Configure AWS
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}

      # Step 5 — Upload to S3
      - name: Upload to S3
        run: aws s3 sync dist/ s3://${{ secrets.S3_BUCKET_NAME }} --delete

      # Step 6 — Clear CloudFront cache
      - name: Invalidate CloudFront
        run: |
          aws cloudfront create-invalidation \
            --distribution-id ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }} \
            --paths "/*"