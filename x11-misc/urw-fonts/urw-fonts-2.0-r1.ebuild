# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/x11-misc/urw-fonts/urw-fonts-2.0-r1.ebuild,v 1.1 2003/04/07 16:16:52 sethbc Exp $

DESCRIPTION="free good quality fonts gpl'd by URW++"
SRC_URI="mirror://gentoo/urw-fonts-2.0-29.src.rpm"
HOMEPAGE=""
KEYWORDS="~x86 ~ppc"
LICENSE="GPL-2"
DEPEND="rpm2targz"
SLOT="0"

S="${WORKDIR}"

src_unpack() {
	cp ${DISTDIR}/${A} ${WORKDIR}
	cd ${S}
	rpm2targz ${A}
	tar -xzf ${A/.rpm/.tar.gz}
	tar -xjf urw-fonts-2.0.tar.bz2
	tar -xjf urw-symbol.tar.bz2
	mv s050000l.* fonts/
	tar -xjf urw-tweaks.tar.bz2
	mv n019003l.* fonts/
	tar -xjf urw-dingbats.tar.bz2
	mv d050000l.* fonts/
	epatch urw-fonts-2.0-encodings.patch
}

src_install() {
	cd ${S}/fonts
	mkdir -p ${D}/usr/share/fonts/default/Type1
	cp -f *.afm *.pfb ${D}/usr/share/fonts/default/Type1
	mkdir -p ${D}/etc/fonts
	cp ${FILESDIR}/fonts.conf ${D}/etc/fonts/
}

pkg_postinst() {
	cat ${S}/fonts/fonts.scale >> /usr/share/fonts/default/Type1/fonts.scale
	
	mkfontdir /usr/share/fonts/default/Type1
}
