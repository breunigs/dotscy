" Don't confuse netrw with visual host keys.
let g:netrw_list_cmd = "ssh    -oVisualHostKey=no HOSTNAME ls -FLa"
let g:netrw_scp_cmd  = "scp -q -oVisualHostKey=no"
let g:netrw_sftp_cmd = "sftp   -oVisualHostKey=no"

" Redraw the screen after loading a file, this breaks often.
function! NetReadFixup(method, line1, line2)
	redraw!
endfunction
