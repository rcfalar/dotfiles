if status is-interactive
    # Starship custom prompt
    starship init fish | source

    # Direnv + Zoxide
    command -v direnv &> /dev/null && direnv hook fish | source
    command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source

    # Better ls
    alias ls='eza --icons --group-directories-first'

    # Abbrs
	abbr .. 'cd ..'
	abbr ... 'cd ...'
	abbr .... 'cd ....'
	abbr h 'cd ~'
	abbr c 'clear'
	abbr e 'exit'
	abbr vi 'nvim'
	abbr v 'nvim'
	abbr vim 'nvim'
    abbr lg 'lazygit'
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'
	abbr cpu 'btop'
    abbr l 'ls'
    abbr ll 'ls -lah'
    abbr la 'ls -a'
    abbr lla 'ls -la'

function sh 
    sudo (history | head -n1)
end
    # Custom colours
    cat ~/.local/state/caelestia/sequences.txt 2> /dev/null

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end
end
