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

function! s:SetupDiffBuffers(data)
  let l:syntax = &syntax
  call git_helper_library#StoreScriptFileName()

  call <SID>SetupTempBuffer()

  call <SID>SetupSyntaxHighlighting(l:syntax)
  call <SID>SetupDiffOffMappings()

  let l:data_list = split(a:data, "\n")
  call setline(1, l:data_list)

  call git_helper_library#ReopenSourceFile()
  call <SID>SetupDiffOffMappings()

  execute 'vertical diffsplit ' . s:diff_buffer_name
  wincmd w
endfunction

" }}}

function! s:DiffHead()
  let head_data = git_helper_library#GitCommand('show HEAD~0:./' . expand('%:t'))
  call <SID>SetupDiffBuffers(head_data)
endfunction

function! s:Diff()
  let cached_data = git_helper_library#GitCommand('show :' . expand('%'))
  let diff_data = git_helper_library#GitCommand('diff')

  if strlen(cached_data) && strlen(diff_data)
    call <SID>SetupDiffBuffers(cached_data)
  else
    call <SID>DiffHead()
  end
endfunction

command! GDiff call <SID>Diff()
command! GDiffHead call <SID>DiffHead()
