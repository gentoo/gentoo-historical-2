# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/edna/edna-0.5-r4.ebuild,v 1.3 2004/12/16 10:39:04 corsair Exp $

inherit eutils

IUSE="oggvorbis"

DESCRIPTION="Greg Stein's python streaming audio server for desktop or LAN use"
HOMEPAGE="http://edna.sourceforge.net/"

SRC_URI="mirror://sourceforge/edna/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~mips ~hppa ~amd64 ppc64"

DEPEND="dev-lang/python
	oggvorbis? ( dev-python/pyogg )
	oggvorbis? ( dev-python/pyvorbis )"

src_install() {

	einfo "Installing in daemon mode"
	insinto /etc/init.d
	insopts -m 755
	newins ${FILESDIR}/edna.gentoo edna

	dodir /usr/bin /usr/$(get_libdir)/edna /usr/$(get_libdir)/edna/templates
	exeinto /usr/bin ; newexe edna.py edna
	exeinto /usr/$(get_libdir)/edna ; doexe ezt.py
	exeinto /usr/$(get_libdir)/edna ; doexe MP3Info.py
	insinto /usr/$(get_libdir)/edna/templates
	insopts -m 644
	doins templates/*

	insinto /etc/edna
	insopts -m 644
	doins edna.conf
	dosym /usr/$(get_libdir)/edna/templates /etc/edna/templates

	dodoc COPYING README ChangeLog
	dohtml -r www/*
}

pkg_postinst() {
	ewarn
	einfo "Edit edna.conf to taste before starting (multiple source"
	einfo "directories are allowed).  Test ednad from a shell prompt"
	einfo "until you have it configured properly, then add edna to"
	einfo "the default runlevel when you're ready.  Add the USE flag"
	einfo "oggvorbis if you want edna to serve ogg files."
	einfo ""
	einfo "See edna.conf and the html docs for more info."
	ewarn
}
