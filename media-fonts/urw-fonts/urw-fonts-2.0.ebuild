# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/urw-fonts/urw-fonts-2.0.ebuild,v 1.4 2003/09/08 07:40:26 msterret Exp $

DESCRIPTION="free good quality fonts gpl'd by URW++"
SRC_URI="mirror://gentoo/urw-fonts-2.0-29.src.rpm"
HOMEPAGE=""
KEYWORDS="x86 ~ppc"
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
}

pkg_postinst() {
	cat ${S}/fonts/fonts.scale >> /usr/share/fonts/default/Type1/fonts.scale

	mkfontdir /usr/share/fonts/default/Type1
}
