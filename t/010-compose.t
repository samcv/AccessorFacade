#!perl6

use v6;
use lib 'lib';
use Test;

use AccessorFacade;

class Bar {
    has $.boot is rw = "foo";
    sub get_bar(Bar:D $self) {
        $self.boot;
    }
    sub set_bar(Bar:D $self, $val) {
        $self.boot = $val;
    }

    sub my_fudge(Str $t) {
        "*" ~ $t ~ "*";
    }

    method boom() is rw is accessor_facade(&get_bar, &set_bar) {};
    method zapp() is rw is accessor_facade(&get_bar, &set_bar, &my_fudge) {};
}
 
my $a;

lives-ok { $a = Bar.new }, "construct object with trait";
 
is($a.boom, $a.boot, "get works fine");
lives-ok { $a.boom = "yada" }, "exercise setter";
is($a.boom, "yada", "get returns what we set");
is($a.boot, "yada", "and the internal thing got set");
is($a.zapp, "yada", "method with fudge");
lives-ok { $a.zapp = 'banana' }, "setter with fudge";
is($a.zapp, '*banana*', "and got fudged value");
is($a.boot, '*banana*', "and the storage get changed");

done;
# vim: expandtab shiftwidth=4 ft=perl6