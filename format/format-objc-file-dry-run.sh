#!/usr/bin/env bash
# format-objc-file-dry-run.sh
# Outputs a formatted Objective-C file to stdout (doesn't alter the file).
# Copyright 2015 Square, Inc

export CDPATH=""
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# "#pragma Formatter Exempt" or "// MARK: Formatter Exempt" means don't format this file.
# Read the first line and trim it.
line="$(head -1 "$1" | xargs)"
if [ "$line" == "#pragma Formatter Exempt" -o "$line" == "// MARK: Formatter Exempt" ]; then
  cat "$1" && exit 0
fi

file=$1
changed_lines=$2

commands[0]="| python $DIR/custom/LiteralSymbolSpacer.py"
commands[${#commands[@]}]="| python \"$DIR\"/custom/InlineConstructorOnSingleLine.py"
commands[${#commands[@]}]="| python \"$DIR\"/custom/MacroSemicolonAppender.py"

if [[ ${#changed_lines} -gt 0 ]]; then
	for line in ${changed_lines[@]}; do
		commands[${#commands[@]}]="| $DIR/bin/clang-format-3.8-custom -style=file -lines=$line"
	done
else
	commands[${#commands[@]}]="| $DIR/bin/clang-format-3.8-custom -style=file"
fi



commands[${#commands[@]}]="| python \"$DIR\"/custom/GenericCategoryLinebreakIndentation.py"
commands[${#commands[@]}]="| python \"$DIR\"/custom/ParameterAfterBlockNewline.py"
commands[${#commands[@]}]="| python \"$DIR\"/custom/HasIncludeSpaceRemover.py"
commands[${#commands[@]}]="| python \"$DIR\"/custom/NewLineAtEndOfFileInserter.py"


cmd="cat $file"
for var in ${commands[@]}; do
	cmd="$cmd $var"
done
eval $cmd




#origin script as blew
# cat $file | \
# python "$DIR"/custom/LiteralSymbolSpacer.py | \
# python "$DIR"/custom/InlineConstructorOnSingleLine.py | \
# python "$DIR"/custom/MacroSemicolonAppender.py | \

# "$DIR"/bin/clang-format-3.8-custom -style=file -lines=50:56 | \
# "$DIR"/bin/clang-format-3.8-custom -style=file -lines=70:76 | \
# "$DIR"/bin/clang-format-3.8-custom -style=file -lines=86:93 | \

# python "$DIR"/custom/GenericCategoryLinebreakIndentation.py | \
# python "$DIR"/custom/ParameterAfterBlockNewline.py | \
# python "$DIR"/custom/HasIncludeSpaceRemover.py | \
# python "$DIR"/custom/NewLineAtEndOfFileInserter.py