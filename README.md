# Mayo-Variant-Calling

Basic scripts for the Mayo-Illinois course.  Hard-coded for biocluster.  Steps:

1. Copy to a test directory, or run a `git clone`:

Copying (note the hard path):

```
$ cd $HOME
$ mkdir test
$ cd test
$ cp /home/mirrors/gatkbundle/mayo_workshop/2019/Mayo-Variant-Calling/*.sh . 
```

Using the latest:

```
$ cd $HOME
$ mkdir test
$ cd test
$ git clone https://github.com/HPCBio/Mayo-Variant-Calling.git
$ cd Mayo-Variant-Calling
```

2. Run each script sequentially. 

```
$ sbatch call_variants_ug.sh
$ sbatch hard_filtering.sh
$ sbatch annotate_snpeff.sh
$ sbatch post_annotate.sh
```

3. Enjoy!
