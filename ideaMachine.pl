#!/usr/bin/env perl
use Mojolicious::Lite;
 
get '/' => {text => 'Hello Mojo!'};
 
app->start;
