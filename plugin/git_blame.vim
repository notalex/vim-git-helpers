let s:blame_buffer_name = '__git_blame_output__'
let s:default_starting_commit = 'HEAD'

function! s:BlameCommitUnderCursor()
  let l:commit_hash = expand('<cWORD>')

  if strlen(l:commit_hash)
    call <SID>GitBlame(l:commit_hash)
  else " When there is a blank buffer after UndoWithLineNumberRetain.
    redo
  endif
endfunction

function! s:UndoWithLineNumberRetain()
  let l:line_number = line('.')
  undo
  execute l:line_number
endfunction

function! s:SetupBlameMappings()
  nmap <buffer> <C-n> :call <SID>BlameCommitUnderCursor()<CR>
  nmap <buffer> <C-p> :call <SID>UndoWithLineNumberRetain()<CR>
  nmap <buffer> q :bdelete<CR>
endfunction

function! s:SetupSyntaxHighlighting(syntax)
  execute 'set syntax=' . a:syntax

  syntax match GitBlameHash /\v^[^ ]+/
  syntax match GitBlameInfo /\s(.\+\d)/

  hi GitBlameHash ctermfg=157 guifg=#afffaf
  hi GitBlameInfo ctermfg=252 guifg=#d0d0d0
endfunction

function! s:SetupBlameBufferAndMappings()
  let l:blame_window_number = bufwinnr(s:blame_buffer_name)

  if l:blame_window_number < 0
    let s:file_name = expand('%:.')
    let l:syntax = &syntax

    execute 'edit ' . s:blame_buffer_name
    set buftype=nowrite
    set nowrap
    call <SID>SetupSyntaxHighlighting(l:syntax)

    call <SID>SetupBlameMappings()
  else
    execute l:blame_window_number . 'wincmd w'
  endif
endfunction

function! s:GitBlame(starting_commit)
  " Whether the source is the original file or the blame buffer, the line
  " number should be retained.
  let l:source_line_number = line('.')

  call <SID>SetupBlameBufferAndMappings()

  let l:data = system('git blame ' . a:starting_commit . '^ ' .
    \ ' --date ' . s:blame_date_format . ' ' . s:file_name)

  let l:data_list = split(l:data, "\n")

  normal! ggdG
  call setline(1, l:data_list)

  execute l:source_line_number
endfunction

function! s:Blame(starting_commit, date_format)
  let s:blame_date_format = a:date_format

  call <SID>GitBlame(a:starting_commit)
endfunction

command! GBlame call <SID>Blame(s:default_starting_commit, 'short')
command! GBlameLong call <SID>Blame(s:default_starting_commit, 'iso')
