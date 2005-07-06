# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/vim-doc.eclass,v 1.9 2005/07/06 20:23:20 agriffis Exp $
#
# This eclass is used by vim.eclass and vim-plugin.eclass to update
# the documentation tags.  This is necessary since vim doesn't look in
# /usr/share/vim/vimfiles/doc for documentation; it only uses the
# versioned directory, for example /usr/share/vim/vim62/doc
#
# We depend on vim being installed, which is satisfied by either the
# DEPEND in vim-plugin or by whatever version of vim is being
# installed by the eclass.


update_vim_helptags() {
	local vimfiles vim d s

	# This is where vim plugins are installed
	vimfiles=/usr/share/vim/vimfiles

	if [[ $PN != vim-core ]]; then
		# Find a suitable vim binary for updating tags :helptags
		if use ppc-macos ; then
			vim=$(which gvim 2>/dev/null )
		else
			vim=$(which vim 2>/dev/null)
			[[ -z "$vim" ]] && vim=$(which gvim 2>/dev/null)
			[[ -z "$vim" ]] && vim=$(which kvim 2>/dev/null)
		fi
		if [[ -z "$vim" ]]; then
			ewarn "No suitable vim binary to rebuild documentation tags"
		fi
	fi

	# Install the documentation symlinks into the versioned vim
	# directory and run :helptags
	for d in /usr/share/vim/vim[0-9]*; do
		[[ -d "$d/doc" ]] || continue	# catch a failed glob

		# Remove links, and possibly remove stale dirs
		find $d/doc -name \*.txt -type l | while read s; do
			[[ $(readlink "$s") = $vimfiles/* ]] && rm -f "$s"
		done
		if [[ -f "$d/doc/tags" && $(find "$d" | wc -l | tr -d ' ') = 3 ]]; then
			# /usr/share/vim/vim61
			# /usr/share/vim/vim61/doc
			# /usr/share/vim/vim61/doc/tags
			einfo "Removing $d"
			rm -r "$d"
			continue
		fi

		# Re-create / install new links
		if [[ -d $vimfiles/doc ]]; then
			ln -s $vimfiles/doc/*.txt $d/doc 2>/dev/null
		fi

		# Update tags; need a vim binary for this
		if [[ -n "$vim" ]]; then
			einfo "Updating documentation tags in $d"
			DISPLAY= $vim -u NONE -U NONE -T xterm -X -n -f \
				'+set nobackup nomore' \
				"+helptags $d/doc" \
				'+qa!' </dev/null &>/dev/null
		fi
	done
}
