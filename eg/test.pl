BEGIN {
    $ENV{T2_FORMATTER} = 'Pretty';
}

use strict;
use warnings;
use utf8;
use Test::More;

pass "hoge";
is 1, 1;
is 1, 2;

subtest 'Hoge' => sub {
    pass 'hoge';

    subtest 'Fuga' => sub {
        fail 'あああ';
    };
};

done_testing;
