# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/vim/vim-6.1-r17.ebuild,v 1.5 2002/12/12 00:34:52 rphillips Exp $

VIMPATCH="vimpatch-1-263.tar.bz2"
inherit vim

DESCRIPTION="Vi IMproved!"
KEYWORDS="~x86"
DEPEND="app-editors/vim-core
	sys-libs/libtermcap-compat
	dev-util/cscope
	>=sys-libs/ncurses-5.2-r2
	gpm?	( >=sys-libs/gpm-1.19.3 )
	perl?	( sys-devel/perl )
	python? ( dev-lang/python )
	ruby?	( >=dev-lang/ruby-1.6.4 )"
#	tcltk?	( dev-lang/tcl )"

src_compile() {
	local myconf
	myconf="--without-x --with-features=big --enable-multibyte"
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

	# move config files to /etc/vim/
	echo "#define SYS_VIMRC_FILE \"/etc/vim/vimrc\"" \
		>>${WORKDIR}/vim61/src/feature.h
	echo "#define SYS_GVIMRC_FILE \"/etc/vim/gvimrc\"" \
		>>${WORKDIR}/vim61/src/feature.h

	# Parallel make does not work
	make || die "vim make failed"
}

src_install() {
	dobin src/vim
	ln -s vim ${D}/usr/bin/vimdiff
	# Default vimrc
	insinto /etc/vim/
	doins ${FILESDIR}/vimrc
}

pkg_postinst() {
	einfo ""
	einfo "gvim has now a seperate ebuild, 'emerge gvim' will install gvim"
}
