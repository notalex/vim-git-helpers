function! git_helper_library#GitCommand(command, file_path)
  let l:current_pwd = getcwd()

  if strlen(matchstr(a:file_path, '\v.+/.+'))
    let l:parent_folder = matchlist(a:file_path, '\v(^.+)/[^/]+$')[1]
    " Switching to file's folder avoids errors when *pwd* is not under git.
    execute 'lcd ' . l:parent_folder
  endif

  let l:filename = matchstr(a:file_path, '\v[^/]+$')
  let l:output = system('git ' . a:command . ' ' . l:filename)

  execute 'lcd ' . l:current_pwd

  return l:output
endfunction
