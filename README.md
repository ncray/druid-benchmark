Druid Benchmarking (September 2016)
===============

Based on
[https://github.com/druid-io/druid-benchmark](https://github.com/druid-io/druid-benchmark) and
[http://druid.io/blog/2014/03/17/benchmarking-druid.html](http://druid.io/blog/2014/03/17/benchmarking-druid.html).

# Setup

```bash
wget https://static.imply.io/support/imply-1.4.0-PREVIEW-605a99e-pivot-38e236d-tranquility-84ebf66-druid-f768a55.tar.gz
tar xvf imply-1.4.0-PREVIEW-605a99e-pivot-38e236d-tranquility-84ebf66-druid-f768a55.tar.gz
sudo apt-get update
sudo apt-get install default-jre emacs24 r-base-core libcurl4-gnutls-dev nodejs-legacy
sudo apt-get -y build-dep libcurl4-gnutls-dev
sudo apt-get -y install libcurl4-gnutls-dev
sudo R -e 'install.packages(c("microbenchmark", "devtools"), repos="http://cran.us.r-project.org")'
sudo R -e 'devtools::install_github("druid-io/RDruid")'
git clone https://github.com/ncray/druid-benchmark.git
```

# Data




