scriptencoding utf-8

if &compatible || (exists('g:loaded_fortune') && g:loaded_fortune)
  finish
endif
let g:loaded_fortune = 1

let s:fortune_file = expand(expand('<sfile>:p:h:h').'/data/fortunes')
let s:fortune_url = 'https://raw.githubusercontent.com/bmc/fortunes/master/fortunes'

fu! s:warn(msg)
  echohl WarningMsg
  echo a:msg
  echohl Normal
endfu

fu! fortune#download()
  call mkdir(fnamemodify(s:fortune_file, ':h'))
  if executable('wget')
    silent exe '!wget -LO '.s:fortune_file.' '.s:fortune_url
  elseif executable('curl')
    silent exe '!curl -fLo '.s:fortune_file.' '.s:fortune_url
  else
    call s:warn('Require wget or curl')
  endif
endfu

fu! fortune#fortune()
  if !filereadable(s:fortune_file)
    call fortune#download()
  endif
  if !exists('s:fortunes')
    let s:fortunes = []
    let lines = readfile(s:fortune_file)
    let fortune = []
    for line in lines
      if line == '%'
        call add(s:fortunes, fortune)
        let fortune = []
      else
        call add(fortune, line)
      endif
    endfor
  endif
  return s:fortunes[s:random(len(s:fortunes))]
endfu

fu! s:random(n)
  return float2nr(fmod(localtime(), a:n))
endfu
