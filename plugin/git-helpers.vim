function! s:CheckoutCurrentFile()
  let l:file_path = expand('%')
  call system('git checkout ' . l:file_path)
  edit!
endfunction

command! GCheckout call <SID>CheckoutCurrentFile()
