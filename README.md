Shell
=====

Standard bash shell setup compatible with cygwin - I can't work without directory history in particular.

cdh - Most recently used directories. cdh l - lists the directory. cdh 23 opens directory 23rd MRU directory from list

f - ```find . -iname``` expander

fxg - ```find . -iname "" | xargs grep -In ""``` expander

g - ``` grep -Irni "" .``` expander 

mvim - Open grep search results in vim one by one (paste in results from g)

n - Number outputs of command e.g. ```grep -Irni "A search" | n```

nr - Pick from the output e.g. ```vim \`nr 11\````

v - Vim expander for grep results e.g. accepts file.c:23:

