# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-misc/xlockmore/xlockmore-5.04.ebuild,v 1.4 2002/07/25 19:18:35 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Just another screensaver application for X"
SRC_URI="http://www.tux.org/~bagleyd/latest/xlockmore-5.04.tar.bz2"
HOMEPAGE="http://www.tux.org/~bagleyd/xlockmore.html"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86"

DEPEND="virtual/x11 
	media-libs/freetype
	opengl? ( virtual/opengl )
	pam? ( sys-libs/pam )
	nas? ( media-libs/nas )
	esd? ( media-sound/esound )
	motif? ( >=x11-libs/openmotif-2.1.30-r1 )
	gtk? ( x11-libs/gtk+ )"

src_compile() {
	local myconf
	use pam && myconf="${myconf} --enable-pam" \
		|| myconf="${myconf} --disable-pam --enable-xlockrc"
	use nas || myconf="${myconf} --without-nas"
	use esd && myconf="${myconf} --with-esound"
	use opengl || myconf="${myconf} --without-opengl --without-gltt --without-mesa"
	use truetype || myconf="${myconf} --without-ttf"

	use motif || myconf="${myconf} --without-motif"
	use gtk || myconf="${myconf} --without-gtk"

	./configure \
		--prefix=/usr \
		--mandir=${prefix}/share/man/man1 \
		--sharedstatedir=/usr/share/xlockmore \
		--host=${CHOST} ${myconf} || die "Configure failed"

	emake || die "Make failed"

}

src_install() {
	make install \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man/man1 \
		xapploaddir=${D}/usr/X11R6/lib/X11/app-defaults \
		|| die "Install failed"

	#Install pam.d file and unset setuid root 
	if use pam; then
		insinto /etc/pam.d
		newins etc/xlock.pamd xlock
		chmod 111 ${D}/usr/bin/xlock
	fi

	insinto /usr/share/xlockmore/sounds
	doins sounds/*

	dodoc docs/* README 
	dohtml docs/*.html
	rm ${D}/usr/share/doc/${PF}/*.html.gz
}
