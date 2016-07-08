package Test2::Formatter::Pretty;
use 5.008001;
use strict;
use warnings;
use parent qw(Test2::Formatter);

our $VERSION = "0.01";

use Data::Dumper;
use Term::ANSIColor;
use Term::Encoding;
use Test2::Util::HashBase qw(no_numbers);

my %CONVERTERS = (
    'Test2::Event::Ok' => 'event_ok',

    #'Test2::Event::Skip'      => 'event_skip',
    'Test2::Event::Note' => 'event_note',
    'Test2::Event::Diag' => 'event_diag',

    #'Test2::Event::Bail'      => 'event_bail',
    #'Test2::Event::Exception' => 'event_exception',
    #'Test2::Event::Subtest'   => 'event_subtest',
    'Test2::Event::Plan' => 'event_plan',
);

sub hide_buffered { 1 }

sub init {
    my $self     = shift;
    my $encoding = Term::Encoding::get_encoding();
    my $is_utf8  = $self->{_encoding_is_utf8} = $encoding =~ /^utf\-?8$/i;

    $self->{_success_sign} = colored(($is_utf8 ? "\x{2713}" : 'o'), "green");
    $self->{_failure_sign} = colored(($is_utf8 ? "\x{2716}" : 'x'), "red");

    if ($is_utf8) {
        binmode *STDOUT, ':utf8';
        binmode *STDERR, ':utf8';
    }
}

sub write {
    my ($self, $e, $num) = @_;
    my $type = ref($e);
    my $converter = $CONVERTERS{$type} || 'event_other';
    $self->$converter($e, $num);
}

sub padding {
    my $nested = shift;
    '  ' x ($nested || 0);
}

sub event_ok {
    my ($self, $e, $num) = @_;
    print padding($e->{nested}) . '  ';
    print $e->causes_fail ? $self->{_failure_sign} : $self->{_success_sign};
    print '  ';
    print colored($e->{name} ? $e->summary : $e->{trace}->debug, 'bright_black');
    print "\n";
}

sub event_skip {
}

sub event_note {
    my ($self, $e, $num) = @_;
    print padding($e->{nested});
    print '  ';
    print colored($e->summary, 'bright_black');
    print "\n";
}

sub event_diag {
    my ($self, $e, $num) = @_;
    print padding($e->{nested});
    print '  # ';
    print $e->summary;
}

sub event_bail { }

sub event_exception { }

sub event_subtest { }

sub event_plan { }

sub event_other {
    my ($self, $e, $num) = @_;
    #warn Dumper [ $e, $num ];
}

1;
__END__

=encoding utf-8

=head1 NAME

Test2::Formatter::Pretty - It's new $module

=head1 SYNOPSIS

    use Test2::Formatter::Pretty;

=head1 DESCRIPTION

Test2::Formatter::Pretty is ...

=head1 LICENSE

Copyright (C) yowcow.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

yowcow E<lt>yowcow@cpan.orgE<gt>

=cut

