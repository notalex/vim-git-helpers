let s:diff_buffer_name = '__git_checked_out_content__'

" Private functions{{{1
function! s:SetupSyntaxHighlighting(syntax)
  execute 'set syntax=' . a:syntax
endfunction

function! s:DiffOff()
  execute 'bdelete! ' . s:diff_buffer_name
  diffoff
  nnoremap <buffer> q q
endfunction

function! s:SetupDiffOffMappings()
  nmap <buffer> q :call <SID>DiffOff()<CR>
endfunction

function! s:SetupTempBuffer()
  execute 'edit ' . s:diff_buffer_name
  call git_helper_library#SetupTempBuffer(s:diff_buffer_name)
endfunction
" }}}

function! s:Diff()
  let l:syntax = &syntax
  call git_helper_library#StoreScriptFileName()
  let l:data = git_helper_library#GitCommand('show HEAD~0:./' . expand('%:t'))

  call <SID>SetupTempBuffer()

  call <SID>SetupSyntaxHighlighting(l:syntax)
  call <SID>SetupDiffOffMappings()

  let l:data_list = split(l:data, "\n")
  call setline(1, l:data_list)

  call git_helper_library#ReopenSourceFile()
  call <SID>SetupDiffOffMappings()

  execute 'vertical diffsplit ' . s:diff_buffer_name
  wincmd w
endfunction

command! Gdiff call <SID>Diff()
