# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/emacs/emacs-21.3.ebuild,v 1.2 2003/03/27 15:11:06 mkennedy Exp $

IUSE="X nls motif leim gnome Xaw3d"

S=${WORKDIR}/${P}
DESCRIPTION="An incredibly powerful, extensible text editor"
SRC_URI="ftp://ftp.codefactory.se/pub/gnu/${PN}/${P}.tar.gz
	leim? ( ftp://ftp.codefactory.se/pub/gnu/emacs/leim-${PV}.tar.gz )"
HOMEPAGE="http://www.gnu.org/software/emacs"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ~alpha"

DEPEND="sys-libs/ncurses
	sys-libs/gdbm
	X? ( virtual/x11
		>=media-libs/libungif-4.1.0
		>=media-libs/jpeg-6b-r2 
		>=media-libs/tiff-3.5.5-r3 
		>=media-libs/libpng-1.2.1 ) 
	Xaw3d? ( x11-libs/Xaw3d )
	motif? ( >=x11-libs/openmotif-2.1.30 ) 
	nls? ( sys-devel/gettext )
	gnome? ( gnome-base/gnome-desktop )"

PROVIDE="virtual/emacs virtual/editor"
SANDBOX_DISABLED="1"

DFILE=emacs.desktop

src_compile() {
	local myconf
	use nls || myconf="${myconf} --disable-nls"
	use X && myconf="${myconf} \
			--with-x \
			--with-xpm \
			--with-jpeg \
			--with-tiff \
			--with-gif \
			--with-png" \
		|| myconf="${myconf} --without-x"
	use motif && myconf="${myconf} --with-x-toolkit=motif"
	use Xaw3d && myconf="${myconf} --with-x-toolkit=athena"
	./configure --host=${CHOST} \
		--prefix=/usr \
		--libexecdir=/usr/lib \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		${myconf} || die
	emake || die
}

src_install () {
	make prefix=${D}/usr \
		libexecdir=${D}/usr/lib \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
	einfo "Fixing info documentation..."
 	rm -f ${D}/usr/share/info/dir
 	for i in ${D}/usr/share/info/*
 	do
 		mv ${i%.info} $i.info
 	done

	einfo "Fixing permissions..."
 	find ${D} -perm 664 |xargs chmod 644
 	find ${D} -type d |xargs chmod 755

	dodoc BUGS ChangeLog README

 	dodir /usr/share/emacs/${PVR}/leim
 	touch ${D}/usr/share/emacs/${PVR}/leim/.keep

	if use gnome
	then
		insinto /usr/share/gnome/apps/Application
		doins ${FILESDIR}/${DFILE}
	fi
}
