" pathogen.vim - path option manipulation
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      2.4

" Install in ~/.vim/autoload (or ~\vimfiles\autoload).
"
" For management of individually installed plugins in ~/.vim/bundle (or
" ~\vimfiles\bundle), adding `execute pathogen#infect()` to the top of your
" .vimrc is the only other setup necessary.
"
" The API is documented inline below.

if exists("g:loaded_pathogen") || &cp
  finish
endif
let g:loaded_pathogen = 1

" Point of entry for basic default usage.  Give a relative path to invoke
" pathogen#interpose() (defaults to "bundle/{}"), or an absolute path to invoke
" pathogen#surround().  Curly braces are expanded with pathogen#expand():
" "bundle/{}" finds all subdirectories inside "bundle" inside all directories
" in the runtime path.
function! pathogen#infect(...) abort
  for path in a:0 ? filter(reverse(copy(a:000)), 'type(v:val) == type("")') : ['bundle/{}']
    if path =~# '^\%({\=[$~\\/]\|{\=\w:[\\/]\).*[{}*]'
      call pathogen#surround(path)
    elseif path =~# '^\%([$~\\/]\|\w:[\\/]\)'
      call s:warn('Change pathogen#infect('.string(path).') to pathogen#infect('.string(path.'/{}').')')
      call pathogen#surround(path . '/{}')
    elseif path =~# '[{}*]'
      call pathogen#interpose(path)
    else
      call s:warn('Change pathogen#infect('.string(path).') to pathogen#infect('.string(path.'/{}').')')
      call pathogen#interpose(path . '/{}')
    endif
  endfor
  call pathogen#cycle_filetype()
  if pathogen#is_disabled($MYVIMRC)
    return 'finish'
  endif
  return ''
endfunction

" Split a path into a list.
function! pathogen#split(path) abort
  if type(a:path) == type([]) | return a:path | endif
  if empty(a:path) | return [] | endif
  let split = split(a:path,'\\\@<!\%(\\\\\)*\zs,')
  return map(split,'substitute(v:val,''\\\([\\,]\)'',''\1'',"g")')
endfunction

" Convert a list to a path.
function! pathogen#join(...) abort
  if type(a:1) == type(1) && a:1
    let i = 1
    let space = ' '
  else
    let i = 0
    let space = ''
  endif
  let path = ""
  while i < a:0
    if type(a:000[i]) == type([])
      let list = a:000[i]
      let j = 0
      while j < len(list)
        let escaped = substitute(list[j],'[,'.space.']\|\\[\,'.space.']\@=','\\&','g')
        let path .= ',' . escaped
        let j += 1
      endwhile
    else
      let path .= "," . a:000[i]
    endif
    let i += 1
  endwhile
  return substitute(path,'^,','','')
endfunction

" Convert a list to a path with escaped spaces for 'path', 'tag', etc.
function! pathogen#legacyjoin(...) abort
  return call('pathogen#join',[1] + a:000)
endfunction

" Turn filetype detection off and back on again if it was already enabled.
function! pathogen#cycle_filetype() abort
  if exists('g:did_load_filetypes')
    filetype off
    filetype on
  endif
endfunction

" Check if a bundle is disabled.  A bundle is considered disabled if its
" basename or full name is included in the list g:pathogen_blacklist or the
" comma delimited environment variable $VIMBLACKLIST.
function! pathogen#is_disabled(path) abort
  if a:path =~# '\~$'
    return 1
  endif
  let sep = pathogen#slash()
  let blacklist =
        \ get(g:, 'pathogen_blacklist', get(g:, 'pathogen_disabled', [])) +
        \ pathogen#split($VIMBLACKLIST)
  if !empty(blacklist)
    call map(blacklist, 'substitute(v:val, "[\\/]$", "", "")')
  endif
  return index(blacklist, fnamemodify(a:path, ':t')) != -1 || index(blacklist, a:path) != -1
endfunction

" Prepend the given directory to the runtime path and append its corresponding
" after directory.  Curly braces are expanded with pathogen#expand().
function! pathogen#surround(path) abort
  let sep = pathogen#slash()
  let rtp = pathogen#split(&rtp)
  let path = fnamemodify(a:path, ':s?[\\/]\=$??')
  let before = filter(pathogen#expand(path), '!pathogen#is_disabled(v:val)')
  let after = filter(reverse(pathogen#expand(path, sep.'after')), '!pathogen#is_disabled(v:val[0:-7])')
  call filter(rtp, 'index(before + after, v:val) == -1')
  let &rtp = pathogen#join(before, rtp, after)
  return &rtp
endfunction

" For each directory in the runtime path, add a second entry with the given
" argument appended.  Curly braces are expanded with pathogen#expand().
function! pathogen#interpose(name) abort
  let sep = pathogen#slash()
  let name = a:name
  if has_key(s:done_bundles, name)
    return ""
  endif
  let s:done_bundles[name] = 1
  let list = []
  for dir in pathogen#split(&rtp)
    if dir =~# '\<after$'
      let list += reverse(filter(pathogen#expand(dir[0:-6].name, sep.'after'), '!pathogen#is_disabled(v:val[0:-7])')) + [dir]
    else
      let list += [dir] + filter(pathogen#expand(dir.sep.name), '!pathogen#is_disabled(