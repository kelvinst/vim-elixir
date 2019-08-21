if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" Matchit support
if exists('loaded_matchit') && !exists('b:match_words')
  let b:match_ignorecase = 0

  let b:match_words = '\:\@<!\<\%(do\|fn\)\:\@!\>' .
        \ ':' .
        \ '\<\%(else\|elsif\|catch\|after\|rescue\)\:\@!\>' .
        \ ':' .
        \ '\:\@<!\<end\>' .
        \ ',{:},\[:\],(:)'
endif

setlocal shiftwidth=2 softtabstop=2 expandtab iskeyword+=!,?
setlocal comments=:#
setlocal commentstring=#\ %s

let &l:path =
      \ join([
      \   'lib',
      \   'src',
      \   'deps/**/lib',
      \   'deps/**/src',
      \   &g:path
      \ ], ',')
setlocal includeexpr=elixir#util#get_filename(v:fname)
setlocal suffixesadd=.ex,.exs,.eex,.leex,.erl,.xrl,.yrl,.hrl

let &l:define = 'def\(macro\|guard\|delegate\)\=p\='

silent! setlocal formatoptions-=t formatoptions+=croqlj

let b:block_begin = '\<\(do$\|fn\>\)'
let b:block_end = '\<end\>'

nnoremap <buffer> <silent> <expr> ]] ':silent keeppatterns /'.b:block_begin.'<CR>'
nnoremap <buffer> <silent> <expr> [[ ':silent keeppatterns ?'.b:block_begin.'<CR>'
nnoremap <buffer> <silent> <expr> ][ ':silent keeppatterns /'.b:block_end  .'<CR>'
nnoremap <buffer> <silent> <expr> [] ':silent keeppatterns ?'.b:block_end  .'<CR>'

onoremap <buffer> <silent> <expr> ]] ':silent keeppatterns /'.b:block_begin.'<CR>'
onoremap <buffer> <silent> <expr> [[ ':silent keeppatterns ?'.b:block_begin.'<CR>'
onoremap <buffer> <silent> <expr> ][ ':silent keeppatterns /'.b:block_end  .'<CR>'
onoremap <buffer> <silent> <expr> [] ':silent keeppatterns ?'.b:block_end  .'<CR>'

let b:undo_ftplugin = 'setlocal sw< sts< et< isk< com< cms< path< inex< sua< def< fo<'.
      \ '| unlet! b:match_ignorecase b:match_words b:block_begin b:block_end'

if get(g:, 'loaded_projectionist', 0)
  let g:projectionist_heuristics = get(g:, 'projectionist_heuristics', {})

  call extend(g:projectionist_heuristics, {
        \ "&mix.exs":
        \   {
        \     'apps/*/mix.exs': { 'type': 'app' },
        \     'lib/*.ex': {
        \       'type': 'lib',
        \       'alternate': 'test/{}_test.exs',
        \       'template': [
        \         'defmodule {camelcase|capitalize|dot} do',
        \         'end'
        \       ],
        \     },
        \     'test/*_test.exs': {
        \       'type': 'test',
        \       'alternate': 'lib/{}.ex',
        \       'dispatch': "mix test test/{}_test.exs`=v:lnum ? ':'.v:lnum : ''`",
        \       'template': [
        \         'defmodule {camelcase|capitalize|dot}Test do',
        \         '  use ExUnit.Case',
        \         '',
        \         '  alias {camelcase|capitalize|dot}',
        \         '',
        \         '  doctest {basename|capitalize}',
        \         'end'
        \       ],
        \     },
        \     'mix.exs': { 'type': 'mix' },
        \     'config/*.exs': { 'type': 'config' },
        \     '*.ex': {
        \       'makery': {
        \         'lint': { 'compiler': 'credo' },
        \         'test': { 'compiler': 'exunit' },
        \         'build': { 'compiler': 'mix' }
        \       }
        \     },
        \     '*.exs': {
        \       'makery': {
        \         'lint': { 'compiler': 'credo' },
        \         'test': { 'compiler': 'exunit' },
        \         'build': { 'compiler': 'mix' }
        \       }
        \     }
        \   }
        \ }, 'keep')
endif

