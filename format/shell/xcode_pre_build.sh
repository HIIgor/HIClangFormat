#!/bin/bash


#pre build shell


#开发模式的pod库
devpods=`cat podfile | grep pod_one | awk -F "[\ \',\\/]" '{print $9}'`

# 壳工程git目录
format_dir=$( cd "$(dirname $(dirname "${BASH_SOURCE[0]}") )" && pwd )

cp -f "${format_dir}/.clang-format" ~

for element in ${devpods[@]}; do
	#组件
	githook_path=`pwd`/${element}/.git/hooks

	if [[ -e $githook_path ]]; then

		precommit="$githook_path/pre-commit"

		cp -f ${format_dir}/shell/git_pre_commit.sh $precommit && chmod 777 $precommit

		#获取行号
		#repo_line=`grep -n "current_repo_path=" $precommit | cut -d ":" -f 1`

		#替换第3行
		sed -i '' '3c\
		'current_repo_path=$( cd "$(dirname ${format_dir})" && pwd )'
		' $precommit
	else
		echo "$githook_path does not exist"
	fi
done

