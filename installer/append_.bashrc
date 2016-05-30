# CDH bash config
export PATH=$HOME/bin:$PATH
cdhistory(){
        cd "$@"
        cdh
}
cdhGo(){
        cd "$(cdh g $@)"
        cdh
}
alias cd=cdhistory
alias cdg=cdhGo
