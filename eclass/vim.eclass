# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Ryan Phillips <rphillips@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/vim.eclass,v 1.4 2002/12/06 23:56:18 rphillips Exp $
# Ripped from the vim ebuilds. src_compile and install
# should be integrated in at some point

# Calculate the version based on the name of the ebuild
vim_version="${PV%_pre*}"
vim_pre="${PV##*_pre}"

if [ "$vim_version" = "$vim_pre" ]; then
	# Final releases prior to 6.0 include a dash and decimal point in
	# the directory name
	if [ "${vim_version%%.*}" -lt 6 ]; then
		S="$WORKDIR/vim-$vim_version"
	else
		S="$WORKDIR/vim${vim_version//.}"
	fi
	vim_letters=
	A="vim-$vim_version.tar.bz2"
	SRC_URI="ftp://ftp.vim.org/pub/vim/unix/$A
			 ftp://ftp.us.vim.org/pub/vim/unix/$A
			 http://www.ibiblio.org/gentoo/distfiles/${VIMPATCH}"
elif [ "$vim_pre" -lt 27 ]; then
	# Handle (prerelease) versions with one trailing letter
	vim_letters=`echo $vim_pre | awk '{printf "%c", $0+96}'`
	S="$WORKDIR/vim${vim_version//.}$vim_letters"
	A="vim-$vim_version$vim_letters.tar.bz2"
	SRC_URI="ftp://ftp.vim.org/pub/vim/unreleased/unix/$A
			 ftp://ftp.us.vim.org/pub/vim/unreleased/unix/$A
			 http://www.ibiblio.org/gentoo/distfiles/${VIMPATCH}"

elif [ "$vim_pre" -lt 703 ]; then
	# Handle (prerelease) versions with two trailing letters
	vim_letters=`echo $vim_pre | awk '{printf "%c%c", $0/26+96, $0%26+96}'`
	S="$WORKDIR/vim${vim_version//.}$vim_letters"
	A="vim-$vim_version$vim_letters.tar.bz2"
	SRC_URI="ftp://ftp.vim.org/pub/vim/unreleased/unix/$A
			 ftp://ftp.us.vim.org/pub/vim/unreleased/unix/$A
			 http://www.ibiblio.org/gentoo/distfiles/${VIMPATCH}"
else
	die "Eek!  I don't know how to interpret the version!"
fi

HOMEPAGE="http://www.vim.org/"
SLOT="0"
LICENSE="vim"

src_unpack() {
	unpack ${A}
	# Fixup a script to use awk instead of nawk
	cd ${S}/runtime/tools
	mv mve.awk mve.awk.old
	( read l; echo "#!/usr/bin/awk -f"; cat ) <mve.awk.old >mve.awk
	# Another set of patch's borrowed from src rpm to fix syntax error's etc.
	cd ${WORKDIR}
	tar xvjf  ${FILESDIR}/vimpatch.tar.bz2 
	cd $S
	patch -p1 < ${WORKDIR}/vim-4.2-speed_t.patch || die
	patch -p1 < ${WORKDIR}/vim-5.1-vimnotvi.patch || die
	patch -p1 < ${WORKDIR}/vim-5.6a-paths.patch || die
	patch -p1 < ${WORKDIR}/vim-6.0-fixkeys.patch || die
	patch -p1 < ${WORKDIR}/vim-6.0-specsyntax.patch || die
	patch -p1 < ${WORKDIR}/vim-6.0r-crv.patch || die
			
	cd ${WORKDIR}
	tar xvjf ${DISTDIR}/${VIMPATCH}
	cd ${S}
	
	# Apply any patches available for this version
	local patches=`echo ${WORKDIR}/${PV}.[0-9][0-9][0-9]`
	case "$patches" in
		*\]) 
			;; # globbing didn't work; no patches available
		*)
			cd $S
			for a in $patches; do
				echo -n "Applying patch $a..."
				patch -p0 < $a > /dev/null || die
				echo "OK"
			done
			;;
	esac
	
	# Also apply the ebuild syntax patch, until this is in Vim proper
	cd $S/runtime
	patch -f -p0 < ${FILESDIR}/ebuild.patch

}

