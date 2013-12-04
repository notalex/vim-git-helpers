function! s:CheckoutCurrentFile()
  call git_helper_library#GitCommand('checkout')
  edit!
endfunction

function! s:CopyBlameHash()
  let l:line_range = line('.') . ',' . line('.')

  let l:blame = git_helper_library#GitCommand('blame -L ' . l:line_range)
  let l:commit_hash = matchstr(l:blame, '\v^[^ ]+')

  call system('tmux set-buffer -b 0 ' . l:commit_hash)

  echo 'Copied commit hash'
endfunction

function! s:CacheAndReset()
  call git_helper_library#GitCommand('add')

  let l:checked_content = git_helper_library#GitCommand('show HEAD:./' . expand('%:t'))
  let l:checked_content_list = split(l:checked_content, "\n")

  normal! ggdG
  call setline('1', l:checked_content_list)

  write
endfunction

command! GCheckout call <SID>CheckoutCurrentFile()
command! GCopyBlameHash call <SID>CopyBlameHash()
command! GCacheAndReset call <SID>CacheAndReset()
