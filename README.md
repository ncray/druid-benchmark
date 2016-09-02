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

# Download Data
Only downloading / indexing the first 20 segments.

```bash
mkdir -p ~/druid-benchmark/data
cd ~/druid-benchmark/data

for i in $(seq 1 20) ; do curl -O http://static.druid.io/data/benchmarks/tpch/100/lineitem.tbl.$i.gz ; done
```

# Start IAP + Druid Services

```bash
cd ~/imply-1.4.0-PREVIEW-605a99e-pivot-38e236d-tranquility-84ebf66-druid-f768a55
bin/supervise -c conf/supervise/quickstart.conf
```

# Index TPC-H Data

```bash
~/imply-1.4.0-PREVIEW-605a99e-pivot-38e236d-tranquility-84ebf66-druid-f768a55/bin/post-index-task --file ~/druid-benchmark/lineitem.task.json
```

# Load TPC-H Data Into Big Query
```bash
cd ~/druid-benchmark/data

bq mk tpc_h
for f in lineitem.tbl.*.gz
do
 echo "Processing $f"
 bq load -F "|" tpc_h.tbl $f l_orderkey:STRING,l_partkey:STRING,l_suppkey:STRING,l_linenumber:STRING,l_quantity:INTEGER,l_extendedprice:FLOAT,l_discount:FLOAT,l_tax:FLOAT,l_returnflag:STRING,l_linestatus:STRING,l_shipdate:DATE,l_commitdate:STRING,l_receiptdate:STRING,l_shipinstruct:STRING,l_shipmode:STRING,l_comment:STRING,dummy:STRING
done
```

# Run Druid and Big Query Benchmarks
```bash
cd ~/druid-benchmark/

/usr/bin/Rscript ./benchmark-druid.R localhost tpch_lineitem results/tpch_lineitem_druid 50
./benchmark-bigquery.sh 3 > results/big_query.tsv
```
