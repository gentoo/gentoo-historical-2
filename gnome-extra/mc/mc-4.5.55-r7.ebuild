# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/mc/mc-4.5.55-r7.ebuild,v 1.2 2002/12/09 04:22:40 manson Exp $

IUSE="gpm nls samba ncurses X pam slang"

S=${WORKDIR}/${P}

DESCRIPTION="GNOME Midnight Commander"
SRC_URI="http://www.gnome.org/projects/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/projects/mc/"

DEPEND=">=sys-apps/e2fsprogs-1.19
	=dev-libs/glib-1.2*
	>=sys-devel/automake-1.5d-r1
	gpm? ( >=sys-libs/gpm-1.19.3 )
	pam? ( >=sys-libs/pam-0.72 )
	ncurses? ( >=sys-libs/ncurses-5.2 )
	slang? ( >=sys-libs/slang-1.4.2 )
	nls? ( sys-devel/gettext )
	samba? ( >=net-fs/samba-2.2.3a-r1 )
	X? ( virtual/x11 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

src_compile() {                           
	
	local myconf=""

	use pam \
		&& myconf="${myconf} --with-pam" \
		|| myconf="${myconf} --without-pam"

	use ncurses \
		&& myconf="${myconf} --with-ncurses" \
		|| ( use slang && myconf="${myconf} --with-slang" \
		|| myconf="${myconf} --with-included-slang" )

	use gpm \
		&& myconf="${myconf} --with-gpm-mouse=/usr" \
		|| myconf="${myconf} --without-gpm-mouse"

	use X \
		&& myconf="${myconf} --with-tm-x-support" \
		|| myconf="${myconf} --without-tm-x-support"

	use samba \
		&& myconf="${myconf} --with-samba" \
		&& ( \
		    cd ${S}/vfs
		    cp smbfs.c smbfs.c.orig
		    sed -e "s:/etc/smb\.conf:/etc/samba/smb\.conf:" smbfs.c.orig > smbfs.c
		    cd samba
		    cp Makefile.in Makefile.in.orig
		    sed -e 's:$(LIBDIR)\(/codepages\):/var/lib/samba\1:' \
			Makefile.in.orig > Makefile.in )
	
	use nls || myconf="${myconf} --disable-nls"
	
	cd ${S}
	libtoolize --force --copy
	aclocal -I ${S}/macros
	automake --add-missing

	econf \
		--with-vfs \
		--with-netrc \
		--with-ext2undel \
		--without-gnome \
		${myconf} || die
	make || die
}

src_install() {                               
	
	einstall
	
	dodoc ABOUT-NLS COPYING* FAQ INSTALL* NEWS README*
}

