scriptencoding utf-8

let s:keep_cpo = &cpoptions
set cpoptions&vim

if exists('s:loaded')
    finish
endif
let s:loaded = 1

let s:default_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

function! fzf_preview#get_default_action() abort
    return s:default_action
endfunction

function! fzf_preview#action_for(key, ...) abort
    let default = a:0 ? a:1 : ''
    let cmd = get(get(g:, 'fzf_action', s:default_action), a:key, default)
    return type(cmd) == type('') ? cmd : default
endfunction

function! fzf_preview#p(bang, ...) abort
    let preview_args = get(g:, 'fzf_preview_window', ['right:50%', 'ctrl-/'])
    if empty(preview_args)
        return { 'options': ['--preview-window', 'hidden'] }
    endif

    " For backward-compatiblity
    if type(preview_args) == type('')
        let preview_args = [preview_args]
    endif
    return call('fzf#vim#with_preview', extend(copy(a:000), preview_args))
endfunction

function! fzf_preview#history(arg, options, bang) abort
    let bang = a:bang || a:arg[len(a:arg) - 1] ==# '!'
    if a:arg[0] ==# ':'
        call fzf#vim#command_history(a:options, bang)
    elseif a:arg[0] ==# '/'
        call fzf#vim#search_history(a:options, bang)
    else
        call fzf#vim#history(fzf_preview#p(bang), bang)
    endif
endfunction

function! fzf_preview#quickfix(loc, bang) abort
    call fzf_preview#quickfix#run(a:loc, a:bang)
endfunction

let &cpoptions = s:keep_cpo
unlet s:keep_cpo
