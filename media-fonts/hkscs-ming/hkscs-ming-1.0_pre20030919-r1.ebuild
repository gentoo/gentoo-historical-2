# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/hkscs-ming/hkscs-ming-1.0_pre20030919-r1.ebuild,v 1.1 2004/06/21 13:11:54 usata Exp $

inherit rpm font

RESTRICT="nomirror nostrip"

RPM_V=1.0

DESCRIPTION="Hong Kong SAR Government Official Reference Chinese Font that implements ISO10646 and HKSCS-2001"
HOMEPAGE="http://www.info.gov.hk/digital21/eng/hkscs/hkscs_iso.html"
SRC_URI="http://www.info.gov.hk/digital21/chi/hkscs/download/linux_redhat/setup.bin"

LICENSE="HKSCS"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=""

S=${WORKDIR}
FONT_S="${S}/usr/share/inputmethod"
FONT_SUFFIX="ttf"

src_unpack() {
	# complicated and convoluted unpack procedure
	LINENUMBER=237
	cd ${S}; tail -n +${LINENUMBER} ${DISTDIR}/${A} | tar zxv || die "unpack failed"

	# then we rpm_unpack the fonts package
	rpm_unpack ${S}/package_rh/imfont-${RPM_V}-0.i386.rpm
}

src_compile() {
	return
}

pkg_postinst() {
	einfo "The font name installed is 'Ming(for ISO10646)'. To add make it"
	einfo "the default Chinese font, you should add entries to your"
	einfo "/etc/fonts/local.conf similar to:"
	einfo " "
	einfo "<alias>"
	einfo "    <family>Luxi Sans</family>"
	einfo "    <family>Bitstream Vera Sans</family>"
	einfo "    <family>Ming(for ISO10646)</family>"
	einfo "    <default><family>sans-serif</family></default>"
	einfo "</alias>"
	einfo " "
}
