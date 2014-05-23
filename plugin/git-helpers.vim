" Private functions{{{1
function! s:CurrentLineCommitHash()
  let l:line_range = line('.') . ',' . line('.')

  let l:blame = git_helper_library#GitCommand('blame -L ' . l:line_range)
  return matchstr(l:blame, '\v^[^ ]+')
endfunction

function! s:ColoredEcho(message)
  let formatted_message = repeat('-', 50) . "\n" . a:message

  echohl GitOutput
  echo formatted_message
  echohl None
endfunction
"}}}

function! s:CheckoutCurrentFile()
  call git_helper_library#GitCommand('checkout')
  edit!
endfunction

function! s:CopyBlameHash()
  let l:commit_hash = <SID>CurrentLineCommitHash()

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

function! s:ShowCommitMessage()
  let commit_hash = <SID>CurrentLineCommitHash()

  " Blank dirstat is a hacky way to avoid diff.
  let message = git_helper_library#GitCommand('show --pretty=format:"%B" --dirstat ' . commit_hash)

  call <SID>ColoredEcho(message)
endfunction

hi GitOutput ctermfg=lightgreen

command! GCheckout call <SID>CheckoutCurrentFile()
command! GCopyBlameHash call <SID>CopyBlameHash()
command! GCacheAndReset call <SID>CacheAndReset()
command! GShow call <SID>ShowCommitMessage()
