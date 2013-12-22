" =============================================================================
" File:          autoload/ctrlp/unicode.vim
" Description:   Unicode character table extension for ctrlp.vim
" Author:        Alejandro Exojo Piqueras
" =============================================================================


" Get the script's filename.
let s:n = exists('s:n') ? s:n : fnamemodify(expand('<sfile>', 1), ':t:r')

" Load guard
if ( exists('g:loaded_ctrlp_'.s:n) && g:loaded_ctrlp_{s:n} )
	\ || v:version < 700 || &cp
	finish
endif
let g:loaded_ctrlp_{s:n} = 1


" Add this extension's settings to g:ctrlp_ext_vars
"
" Required:
"
" + init: the name of the input function including the brackets and any
"         arguments
"
" + accept: the name of the action function (only the name)
"
" + lname & sname: the long and short names to use for the statusline
"
" + type: the matching type
"   - line : match full line
"   - path : match full line like a file or a directory path
"   - tabs : match until first tab character
"   - tabe : match until last tab character
"
" Optional:
"
" + enter: the name of the function to be called before starting ctrlp
"
" + exit: the name of the function to be called after closing ctrlp
"
" + opts: the name of the option handling function called when initialize
"
" + sort: disable sorting (enabled by default when omitted)
"
call add(g:ctrlp_ext_vars, {
	\ 'init':   'ctrlp#'.s:n.'#init()',
	\ 'accept': 'ctrlp#'.s:n.'#accept',
	\ 'lname':  'unicode character',
	\ 'sname':  'uch',
	\ 'type':   'line',
	\ 'sort':   0,
	\ })

" \ 'enter':  'ctrlp#'.s:n.'#enter()',
" \ 'exit':   'ctrlp#'.s:n.'#exit()',
" \ 'opts':   'ctrlp#'.s:n.'#opts()',


" Provide a list of strings to search in
"
" Return: a Vim's List
"
function! ctrlp#{s:n}#init()
	let result = []

	" Try first UnicodeData.txt, since it's simpler.
	let path = get(g:, 'ctrlp_unicode_unicodedata_file',
		\ '/usr/share/unicode/UnicodeData.txt')

	if !filereadable(path)
		let path = get(g:, 'ctrlp_unicode_charmap_file',
			\ '/usr/share/i18n/charmaps/UTF-8.gz')
		if !filereadable(path)
			return result
		endif

		" Copy and decompress the file.
		let tempfile = tempname()
		" Consider: Pure Vim alternative to copying the file without system().
		" let ret = writefile(readfile(path, "b"), tempfile.'.gz', "b")
		" if ret != 0
		" 	return result
		" endif
		silent execute '!cp' shellescape(path) shellescape(tempfile.'.gz')
		call system('gzip -dn ' . tempfile.'.gz')

		" Start parsing.
		let lines = readfile(tempfile)

		let started = 0
		for line in lines
			if started == 0 && line ==# 'CHARMAP'
				let started = 1
				continue
			endif
			if line ==# 'END CHARMAP'
				break
			endif

			if started == 1
				let pieces = split(line, '\s\+')

				" Skip lines that provide ranges, since are not useful anyway:
				" <U3400>..<U343F> /xe3/x90/x80 <CJK>
				" <UE000>..<UE03F> /xee/x80/x80 <Private Use>
				if stridx(pieces[0], '.') != -1
					continue
				endif
				let number = matchstr(pieces[0], '\x\+')
				" Remove the two already parsed elements of the list and join
				" the remaining pieces.
				call remove(pieces, 0, 1) " From 0 to 1: two items
				call add(result, number . "\t" . join(pieces, ' '))
			endif
		endfor
	else
		let lines = readfile(path)

		for line in lines
			let pieces = split(line, ';')

			call add(result, pieces[0] . "\t" . pieces[1])
		endfor
	endif

	return result
endfunction


" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#{s:n}#accept(mode, str)
	call ctrlp#exit()

	let l:values = split(a:str, '	')
	execute ":normal i\<C-v>u" . l:values[0]

endfunction


" Do something before enterting ctrlp
" function! ctrlp#{s:n}#enter()
" endfunction


" Do something after exiting ctrlp
" function! ctrlp#{s:n}#exit()
" endfunction


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#{s:n}#id()
	return s:id
endfunction

" vim:fen:fdl=0:ts=4:sw=4:sts=4
