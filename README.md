# Elves

["The Shoemaker and the Elves"](http://en.wikipedia.org/wiki/The_Elves_and_the_Shoemaker)
is a fairy tale written by Grimm brothers. It's a story about a poor shoemaker
who receives much-needed help from elves.

I'm not a poor shoemaker, but still I need help with my routine tasks. So here are
my personal elves :)

### What do they do?

- Download an RSS feed with links
- Check by keywords the feed items
- Download files from feed links of matched items

Also I need to unarchive RAR files from time to time, they can help to do this too.

## Prerequisites

### OS X:

```bash
$ brew install redis unrar
```

### Linux(Ubuntu):

```bash
$ sudo apt-get install redis-server libcurl4-openssl-dev
```

To install `unrar-nonfree`:

```bash
$ sudo apt-get install python-software-properties
$ sudo add-apt-repository ppa:trinitronx/unrar-nonfree
$ sudo apt-get update
$ sudo apt-get install unrar
```

## Usage

```bash
$ cp config/feeds.yml.example config/feeds.yml
$ cp config/schedule.yml.example config/schedule.yml
$ cp config/extract.yml.example config/extract.yml

$ bundle
$ bundle exec foreman start
```

### RSS feeds download

Feeds config has the following structure:

```yaml
<name of the resource>:
  url: <RSS feed link>
  prefix: <any text you want to be prefixed downloaded file with>
  ext: <extension for downloaded file>
  destination: <directory where downloaded file will be save>
  keywords:
    - <keywords list to match RSS items>
    - <keywords should be separated by space>
```

Remarks:

  - `prefix` is optional
  - `ext` is optional. If it is not set file's original name will be used
  - Keywords check is case-insensitive
  - When extension is set filename will be in small case and all spaces replaced with comas

RSS item is checked against all words in each keywords set. Example:

```yaml
keywords:
  - one two
  - three four
```

- Phrase `One` will match
- Phrase `Two Three` won't match
- Phrase `One Two Three Four` will match by first keywords set

Elves use schedule for RSS feed check. Check frequency can be modified in `config/schedule.yml`.

### Unarchiving

Elves add an unarchiving job on request. You can do this in 2 ways.

- Hit `POST http://server:8000/extract` with `path=<archive directory>`
- Run script `ruby script/extract.rb <archive directory>`

Elves search for RAR archives in the `<archive directory>` and extract them all.

Extraction directory can be modified in `config/extract.yml`.

## TODO

- Add logging
- Add simple UI for log entries
