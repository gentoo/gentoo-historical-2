# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xlockmore/xlockmore-5.17.ebuild,v 1.1 2005/06/17 00:50:00 smithj Exp $

inherit gnuconfig eutils pam

IUSE="nas esd motif opengl truetype gtk pam"

DESCRIPTION="Just another screensaver application for X"
SRC_URI="http://ftp.tux.org/pub/tux/bagleyd/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.tux.org/~bagleyd/xlockmore.html"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc ~ppc64"

DEPEND="virtual/x11
	media-libs/freetype
	opengl? ( virtual/opengl )
	pam? ( virtual/pam )
	nas? ( media-libs/nas )
	esd? ( media-sound/esound )
	motif? ( x11-libs/openmotif )
	gtk? ( =x11-libs/gtk+-1.2* )"

src_compile() {

	local myconf
	use pam || myconf="${myconf} --enable-xlockrc"

	use opengl || myconf="${myconf} --without-opengl --without-gltt --without-mesa"

	econf \
		--sharedstatedir=${D}/usr/share/xlockmore \
		--enable-vtlock \
		$(use_enable pam) \
		$(use_with truetype ttf) \
		$(use_with gtk) \
		$(use_with motif) \
		$(use_with esd esound) \
		$(use_with nas) \
		${myconf} \
		|| die "econf failed"

	emake || die "Make failed"

}

src_install() {
	einstall \
		xapploaddir=${D}/etc/X11/app-defaults \
		mandir=${D}/usr/share/man/man1 \
		|| die "einstall failed"

	#Install pam.d file and unset setuid root
	pamd_mimic_system xlock auth
	use pam && chmod 755 ${D}/usr/bin/xlock

	insinto /usr/share/xlockmore/sounds
	doins sounds/*

	dodoc docs/* README
	dohtml docs/*.html
	rm ${D}/usr/share/doc/${PF}/*.html.gz
}
