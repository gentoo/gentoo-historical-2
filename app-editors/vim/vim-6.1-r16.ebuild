# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/vim/vim-6.1-r16.ebuild,v 1.1 2002/10/27 22:52:29 rphillips Exp $

inherit vim

DESCRIPTION="Vi IMproved!"

src_compile() {
	local myconf
	myconf="--without-x"
	use nls    && myconf="$myconf --enable-multibyte"
	use nls    || myconf="$myconf --disable-nls"
	use perl   && myconf="$myconf --enable-perlinterp"
	use python && myconf="$myconf --enable-pythoninterp"
	use ruby   && myconf="$myconf --enable-rubyinterp"
	
# tclinterp is BROKEN.  See note above DEPEND=
#	use tcltk  && myconf="$myconf --enable-tclinterp"

# Added back gpm for temporary will remove if necessary, I think that I have
# fixed most of gpm so it should be fine.
	use gpm    || myconf="$myconf --disable-gpm"

	# This should fix a sandbox violation. 
	addwrite "${SSH_TTY}"
	
	#
	# Build a nogui version, this will install as /usr/bin/vim
	#
	./configure \
		--prefix=/usr --mandir=/usr/share/man --host=$CHOST \
		--with-features=huge --with-cscope $myconf \
		--enable-gui=no \
		|| die "vim configure failed"
	# Parallel make does not work
	make || die "vim make failed"
}

src_install() {
	dobin src/vim
	ln -s vim ${D}/usr/bin/vimdiff
	# Default vimrc
	insinto /usr/share/vim
	doins ${FILESDIR}/vimrc
}

pkg_postinst() {
	einfo ""
	einfo "gvim has now a seperate ebuild, 'emerge gvim' will install gvim"
}
