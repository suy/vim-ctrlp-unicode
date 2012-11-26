Unicode character selection for CtrlP.vim
============================================

This extension provides a convenient interface for finding and inserting
characters from the Unicode standard. The list of characters is read from the
file `/usr/share/unicode/UnicodeData.txt` (in Linux distributions is likely to
be in a package named `unicode-data`) or similar.

For now is hardcoded until I figure it out the proper way to use options in
CtrlP.vim.

Installation
============

Just put the file in the proper `autoload` directory, like CtrlP does. Or use a
plugin manager like [Pathogen](https://github.com/tpope/vim-pathogen).

To load this extension into ctrlp, add this to your vimrc:

```VimL
let g:ctrlp_extensions = ['unicode']
```

If you have other extensions (for example, 'mixed'):

```VimL
let g:ctrlp_extensions = [
    \ 'mixed',
    \ 'unicode',
    \ ]
```

