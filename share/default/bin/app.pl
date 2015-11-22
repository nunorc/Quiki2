#!/usr/bin/env perl

use Dancer2;

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Quiki2::App;
dance;
