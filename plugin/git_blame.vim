let s:blame_buffer_name = '__git_blame_output__'
let s:default_starting_commit = 'HEAD'

function! s:BlameCommitUnderCursor()
  let l:commit_hash = expand('<cWORD>')
  call <SID>GitBlame(l:commit_hash)
endfunction

function! s:SetupBlameMappings()
  nmap <buffer> <C-n> :call <SID>BlameCommitUnderCursor()<CR>
  nmap <buffer> q :bdelete<CR>
endfunction

function! s:SetupBlameBufferAndMappings()
  let l:blame_window_number = bufwinnr(s:blame_buffer_name)

  if l:blame_window_number < 0
    let s:file_name = expand('%:.')

    execute 'edit ' . s:blame_buffer_name
    set buftype=nowrite
    set nowrap

    call s:SetupBlameMappings()
  else
    execute l:blame_window_number . 'wincmd w'
  endif
endfunction

function! s:GitBlame(starting_commit)
  " Whether the source is the original file or the blame buffer, the line
  " number should be retained.
  let l:source_line_number = line('.')

  call <SID>SetupBlameBufferAndMappings()

  let l:data = system('git blame ' . a:starting_commit . '^ ' . s:file_name)
  let l:data_list = split(l:data, "\n")

  normal! ggdG
  call setline(1, l:data_list)

  execute l:source_line_number
endfunction

command! GBlame call <SID>GitBlame(s:default_starting_commit)
