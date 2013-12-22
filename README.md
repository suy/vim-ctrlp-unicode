Unicode character selection for CtrlP.vim
============================================

This extension provides a convenient interface for finding and inserting
characters from the Unicode standard. The list of characters is read from the
file `/usr/share/unicode/UnicodeData.txt` (in Linux distributions is likely to
be in a package named `unicode-data`) or similar.

If that file is not available, the file `/usr/share/i18n/charmaps/UTF-8.gz` from
the `locales` package (from the GNU libc) is used instead (but this file is
compressed, so reading it is slower).

If you need to customize the path to those files (for example, because you need
to manually download it if you are on Windows), use the following variables
(you can set them in your vimrc):

```
let g:ctrlp_unicode_unicodedata_file = '/some/directory'
let g:ctrlp_unicode_charmap_file     = '/some/directory'
```

Only one of them is needed, and the one for UnicodeData is preferred. You can
get it from Unicode consortium:
[http://www.unicode.org/Public/UNIDATA/UnicodeData.txt](http://www.unicode.org/Public/UNIDATA/UnicodeData.txt)

Installation
============

Just put the file in the proper `autoload` directory, like CtrlP does. But the
recommended way is to use a plugin manager like
[Pathogen](https://github.com/tpope/vim-pathogen).

To load this extension into ctrlp, add this to your vimrc:

```VimL
let g:ctrlp_extensions = ['unicode']
```

If you have other extensions is likely that you already will have that variable
set, so add an element 'unicode':

```VimL
let g:ctrlp_extensions = ['mixed', 'quickfix', 'line', 'commandline', 'unicode']
```

Usage
=====

You can invoke this extension directly with `:CtrlPUnicode`, or when you have
opened CtrlP, cycle till you find the right panel.
