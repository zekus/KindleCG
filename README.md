# KindleCG
## Directory Tree to Kindle Collections generator

A command line ruby script that will generate collections in your kindle based on the directory structure of your ebooks.

## Installation

    $ gem install KindleCG

## Usage

After installing the gem you will have access to the command line tool **kindlecg**.

The kindlecg has just two commands available:
  kindlecg check           # check if a kindle is attached to the computer
  kindlecg generate        # generate and save the collections

Just run the kindlecg without any option to show the help.

By default, the commands assume that you are on a mac and the kindle mountpoint is /Volumes/Kindle but you can change that passing 
the option *-m* followed by the mountpoint of the kindle on your computer.

__WARNING : The script is under development. It overrides your current collections!__

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
