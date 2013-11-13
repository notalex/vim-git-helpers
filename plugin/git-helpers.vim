function! s:CheckoutCurrentFile()
  call git_helper_library#GitCommand('checkout', expand('%'))
  edit!
endfunction

function! s:CopyBlameHash()
  let l:line_range = line('.') . ',' . line('.')

  let l:blame = git_helper_library#GitCommand('blame -L ' . l:line_range, expand('%'))
  let l:commit_hash = matchstr(l:blame, '\v^[^ ]+')

  call system('tmux set-buffer -b 0 ' . l:commit_hash)

  echo 'Copied commit hash'
endfunction

command! GCheckout call <SID>CheckoutCurrentFile()
command! GCopyBlameHash call <SID>CopyBlameHash()
