function! s:CheckoutCurrentFile()
  let l:checkout_log = system('git checkout ' . expand('%'))

  if strlen(matchstr(l:checkout_log, '^error: pathspec'))
    let l:current_pwd = getcwd()

    lcd %:h
    call system('git checkout ' . expand('%'))

    execute 'lcd ' . l:current_pwd
  endif

  edit!
endfunction

function! s:CopyBlameHash()
  let l:line_range = line('.') . ',' . line('.')
  let l:blame = system('git blame -L ' . l:line_range . ' ' . expand('%'))
  let l:commit_hash = matchstr(l:blame, '\v^[^ ]+')
  call system('tmux set-buffer -b 0 ' . l:commit_hash)
  echo 'Copied commit hash'
endfunction

command! GCheckout call <SID>CheckoutCurrentFile()
command! GCopyBlameHash call <SID>CopyBlameHash()
