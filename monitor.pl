#!/usr/bin/env perl

use warnings;
#HOSTNAME                ARCH         NCPU NSOC NCOR NTHR  LOAD  MEMTOT  MEMUSE  SWAPTO  SWAPUS
#----------------------------------------------------------------------------------------------
#global                  -               -    -    -    -     -       -       -       -       -
#cn01                    lx-amd64       56    2   28   56     -  125.6G       - 1024.0M       -
#cn02                    lx-amd64       56    2   28   56 89.50  125.6G   53.8G 1024.0M  245.3M
#cn03                    lx-amd64       56    2   28   56 56.08  125.6G   86.0G 1024.0M  124.5M
#cn04                    lx-amd64       56    2   28   56 47.15  125.6G   79.9G 1024.0M 1024.0M
#fat01                   lx-amd64      160    4   80  160 211.0    1.5T  214.0G 1024.0M  355.2M
#login01                 lx-amd64       32    2   16   32  0.03   31.1G   20.6G   32.0G    2.2G

my @host_stat = `/opt/gridengine/bin/lx-amd64/qhost`;

my %memory_limit = ("cn" => 110,
	"fat" => 1400,);

for my  $line (@host_stat)
{
	my @e=split/\s+/, $line;
	for my $k(keys %memory_limit)
	{
		if($e[0] =~/^$k/)
		{
			if( $e[8] =~/T$/)
			{
				$e[8]=~s/T//;
				$e[8] *= 1000;
			}
			elsif($e[8] =~/G$/)
			{
				$e[8]=~s/G//;
			}
			print ("checking $e[0]'s memory usage:$e[8]G limit:$memory_limit{$k}G\n");
			if($e[8] eq "-" )
			{
#				`echo "Warning!! Host $e[0] is down!!" | write liuhui`;
				print "Warning!! Host $e[0] is down!!\n";
				next;
			}
			if($e[8] ne "-" and $e[8] > $memory_limit{$k})
			{
				`wall "Warning!! Memory usage of $e[0] is $e[8] G, exceeding limit!!! Kill large memory jobs asap!!!" `;
				print "Warning!! Memory usage of $e[0] is $e[8] G, exceeding limit!!! Kill large memory jobs asap!!!\n" 
			}
		}
	}
}
