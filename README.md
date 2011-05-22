# Secret Santa

This project solves [Ruby Quiz #2](http://rubyquiz.com/quiz2.html).

Participants can be entered interactively via STDIN, or can be listed, one per line, in input files.

## Usage

### Interactive

    secret_santa

### With input files

    secret_santa input_file_1 input_file_2

## Install

    bundle install --path vendor

## Testing

    bundle exec cucumber
    bundle exec rspec spec