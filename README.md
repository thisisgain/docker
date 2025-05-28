# Docker Images Repository

This repository contains multiple Docker images that are automatically built and published to Docker Hub when changes are made.

## Repository Structure

Each Docker image has its own directory at the root level of this repository:

```
/
├── .github/workflows/  # GitHub Actions workflows
├── image1/            # First Docker image
│   ├── Dockerfile     # Docker build instructions
│   ├── version.txt    # Current version of the image
│   └── ...            # Other files needed for the image
├── image2/            # Second Docker image
│   ├── Dockerfile
│   ├── version.txt
│   └── ...
└── ...
```

## How Versioning Works

Each image directory contains a `version.txt` file that defines the current version of that image. The CI/CD pipeline uses this version to tag the Docker image when it's built and published.

### Image Tags

When an image is built, it receives two tags:
- `latest` - Always points to the most recent build
- The version number from `version.txt` (e.g., `1.2.3`)

For example, if `toolbox/version.txt` contains `1.2.3`, the published image will be tagged as:
- `thisisgain/toolbox:latest`
- `thisisgain/toolbox:1.2.3`

## How to Update an Existing Image

To update an existing Docker image:

1. Make your changes to the image files (Dockerfile, scripts, etc.)
2. Update the version in `version.txt` following semantic versioning:
   - Increment MAJOR version for incompatible API changes
   - Increment MINOR version for new functionality in a backward compatible manner
   - Increment PATCH version for backward compatible bug fixes
3. Commit your changes and push to the `main` branch
4. The GitHub Actions workflow will automatically build and publish the updated image

Example:
```bash
# Edit the Dockerfile
vim toolbox/Dockerfile

# Update the version
echo "1.2.4" > toolbox/version.txt

# Commit and push
git add toolbox/
git commit -m "Update toolbox image to version 1.2.4"
git push origin main
```

## How to Add a New Image

To add a new Docker image to the repository:

1. Create a new directory at the root level with a descriptive name for your image
2. Add a `Dockerfile` that defines how to build your image
3. Create a `version.txt` file with the initial version (e.g., `1.0.0`)
4. Add any other files needed for your image
5. Commit your changes and push to the `main` branch
6. The GitHub Actions workflow will automatically build and publish the new image

Example:
```bash
# Create directory structure
mkdir -p newimage

# Create Dockerfile
cat > newimage/Dockerfile << 'EOF'
FROM alpine:latest
RUN apk add --no-cache curl jq
ENTRYPOINT ["sh"]
EOF

# Set initial version
echo "1.0.0" > newimage/version.txt

# Commit and push
git add newimage/
git commit -m "Add newimage Docker image"
git push origin main
```

## Best Practices

1. **Keep images focused**: Each image should serve a specific purpose
2. **Document your images**: Include a README.md in each image directory explaining its purpose and usage
3. **Minimize image size**: Use multi-stage builds and remove unnecessary files
4. **Version carefully**: Follow semantic versioning principles
5. **Test locally**: Build and test your images locally before pushing changes

## Troubleshooting

If your image isn't building or publishing correctly:

1. Check the GitHub Actions workflow logs for errors
2. Verify that you've updated the `version.txt` file
3. Ensure your Dockerfile is valid by building it locally
4. Check that all required files are included in the image directory