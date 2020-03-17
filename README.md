# Bucks CC FMCASP Docker Image

Docker image for the [Bucks CC FMCASP][1] website.

# Usage

In your `docker-compose.yml` file:

``` yaml
services
  web:
    image: unboxed/bucks_cc
    ports:
      - "3000:3000"
```

# License

MIT License - please see the project LICENSE file for details.

[1]: https://services.buckscc.gov.uk
