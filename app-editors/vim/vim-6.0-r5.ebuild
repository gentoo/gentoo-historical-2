# Copyright 2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Aron Griffis <agriffis@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-editors/vim/vim-6.0-r5.ebuild,v 1.2 2002/02/17 00:51:21 agriffis Exp $

# Please name the ebuild as follows.  If this is followed, there
# should be no need to modify this ebuild when the Vim version is
# updated.  (Yes it's overkill, but it was fun!)
#
#   vim-6.0, when 6.0 is finally released
#   vim-6.0_pre9, where 9 = (i), for vim-6.0i
#   vim-6.0_pre47, where 47 = 26(a) + 21(u), for vim-6.0au
#   vim-6.0_pre72, where 72 = 52(b) + 20(t), for vim-6.0bt
#
# Quick reference:
#   a=1   e=5   i=9   m=13  q=17  u=21  y=25
#   b=2   f=6   j=10  n=14  r=18  v=22  z=26
#   c=3   g=7   k=11  o=15  s=19  w=23 aa=27
#   d=4   h=8   l=12  p=16  t=20  x=24 ab=28 (etc.)
#
# (08 Sep 2001 agriffis)

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
	SRC_URI="ftp://ftp.us.vim.org/pub/vim/unix/$A
			 ftp://ftp.vim.org/pub/vim/unix/$A"
elif [ "$vim_pre" -lt 27 ]; then
	# Handle (prerelease) versions with one trailing letter
	vim_letters=`echo $vim_pre | awk '{printf "%c", $0+96}'`
	S="$WORKDIR/vim${vim_version//.}$vim_letters"
	A="vim-$vim_version$vim_letters.tar.bz2"
	SRC_URI="ftp://ftp.us.vim.org/pub/vim/unreleased/unix/$A
			 ftp://ftp.vim.org/pub/vim/unreleased/unix/$A"
elif [ "$vim_pre" -lt 703 ]; then
	# Handle (prerelease) versions with two trailing letters
	vim_letters=`echo $vim_pre | awk '{printf "%c%c", $0/26+96, $0%26+96}'`
	S="$WORKDIR/vim${vim_version//.}$vim_letters"
	A="vim-$vim_version$vim_letters.tar.bz2"
	SRC_URI="ftp://ftp.us.vim.org/pub/vim/unreleased/unix/$A
			 ftp://ftp.vim.org/pub/vim/unreleased/unix/$A"
else
	die "Eek!  I don't know how to interpret the version!"
fi

DESCRIPTION="Vi IMproved! ${PV}"
HOMEPAGE="http://www.vim.org/"

DEPEND="virtual/glibc 
		>=sys-libs/ncurses-5.2-r2
		dev-util/cscope
		gpm?	( >=sys-libs/gpm-1.19.3 )
		gnome?	( >=gnome-base/gnome-libs-1.4.1.2-r1 )
		gtk?	( >=x11-libs/gtk+-1.2.10-r4 )
		X?		( x11-base/xfree )
		perl?	( sys-devel/perl )
		python? ( dev-lang/python )
		ruby?	( >=dev-lang/ruby-1.6.4 )"
#		tcltk?	( dev-lang/tcl )"
# It appears that the tclinterp stuff in Vim is broken right now.
# When you --enable-tclinterp flag, then the following command never
# returns:
#
#	 VIMINIT='let OS = system("uname -s")' vim
#
# Please don't re-enable the tclinterp flag without verifying first
# that the above works.	 Thanks.  (08 Sep 2001 agriffis)

src_unpack() {
	unpack $A
	# Fixup a script to use awk instead of nawk
	cd $S/runtime/tools
	mv mve.awk mve.awk.old
	( read l; echo "#!/usr/bin/awk -f"; cat ) <mve.awk.old >mve.awk
	# Apply any patches available for this version
	local patches=`echo $FILESDIR/$PV.[0-9][0-9][0-9]`
	case "$patches" in
		*\]) 
			break # globbing didn't work; no patches available
			;; 
		*)
			cd $S
			for a in $patches; do
				patch -p0 < $a
			done
			;;
	esac
	# Also apply the ebuild syntax patch, until this is in Vim proper
	cd runtime
	patch -p0 < ${FILESDIR}/ebuild.patch
}

src_compile() {
	local myconf
	use nls	   || myconf="--disable-nls"
	use gpm	   || myconf="$myconf --disable-gpm"
	use perl   && myconf="$myconf --enable-perlinterp"
#	use python && myconf="$myconf --enable-pythoninterp"
	use ruby   && myconf="$myconf --enable-rubyinterp"
# tclinterp is BROKEN.  See note above DEPEND=
#	use tcltk  && myconf="$myconf --enable-tclinterp"

	#
	# First, build a gui version, this will install as /usr/bin/gvim
	#
	if use gnome; then
		guiconf="--enable-gui=gnome --with-x"
	elif use gtk; then
		guiconf="--enable-gui=gtk --with-x"
	elif use X; then
		guiconf="--enable-gui=athena --with-x"
	else
		# No gui version will be built
		guiconf=""
	fi
	if [ -n "$guiconf" ]; then
		./configure \
			--prefix=/usr --mandir=/usr/share/man --host=$CHOST \
			--enable-max-features --enable-cscope $myconf $guiconf \
			|| die "gvim configure failed"
		# Parallel make does not work
		make || die "gvim make failed"
		mv src/vim src/gvim
	fi

	#
	# Second, build a nogui version, this will install as /usr/bin/vim
	#
	./configure \
		--prefix=/usr --mandir=/usr/share/man --host=$CHOST \
		--enable-max-features --with-cscope $myconf \
		--enable-gui=no --without-x \
		|| die "vim configure failed"
	# Parallel make does not work
	make || die "vim make failed"
}

src_install() {
	# Install the nogui version
	mkdir -p $D/usr/{bin,share/man/man1,share/vim}
	make install STRIP=true DESTDIR=$D \
		BINDIR=/usr/bin MANDIR=/usr/share/man DATADIR=/usr/share
	# Install the gui version, if it was built
	if [ -f src/gvim ]; then
		install -m755 src/gvim $D/usr/bin/gvim
		ln -s gvim $D/usr/bin/gvimdiff
	fi
	# Docs
	dodoc README*
	cd $D/usr/share/doc/$PF
	ln -s ../../vim/*/doc $P
	# Default vimrc and gvimrc (who cares if gvim wasn't built)
	insinto /usr/share/vim
	doins ${FILESDIR}/vimrc ${FILESDIR}/gvimrc
}
