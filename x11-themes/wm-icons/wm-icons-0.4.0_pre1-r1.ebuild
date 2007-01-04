# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/wm-icons/wm-icons-0.4.0_pre1-r1.ebuild,v 1.12 2007/01/04 19:45:32 flameeyes Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit autotools

DESCRIPTION="A Large Assortment of Beutiful Themed Icons, Created with FVWM in mind"

HOMEPAGE="http://wm-icons.sourceforge.net/"
SRC_URI="mirror://gentoo/wm-icons-${PV}-cvs-01092003.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 x86"

IUSE=""
RDEPEND="sys-apps/gawk dev-lang/perl"
DEPEND="${RDEPEND} sys-devel/autoconf sys-devel/automake sys-apps/sed"

S=${WORKDIR}/wm-icons

src_unpack() {
	unpack ${A}

	sed -i 's#$(bindir)/wm-icons-config#true#g' ${S}/Makefile.am
	# duplication of bin/Makefile in configure.in #91764
	sed -i '132s/bin\/Makefile//' ${S}/configure.in
	# non-portable comment bombs automake.
	sed -i 's/\t#/#/' ${S}/Makefile.am

	cd "${S}"
	eautoreconf
}

src_compile() {
	econf --enable-all-sets --enable-icondir=/usr/share/icons/wm-icons || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	# strange makefile...
	einstall icondir=${D}/usr/share/icons/wm-icons DESTDIR=${D}

	dodir /usr/bin
	mv ${D}/${D}/usr/bin/wm-icons-config ${D}/usr/bin/wm-icons-config
	rm -rf ${D}/var

	einfo "Setting default aliases..."
	${D}/usr/bin/wm-icons-config --user-dir="${D}/usr/share/icons/wm-icons" --defaults

	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README
}

pkg_postinst() {
	einfo "Users can use the wm-icons-config utility to create aliases in their"
	einfo "home directory, FVWM users can then set this in their ImagePath"
	einfo
	einfo "Sample configurations for fvwm1, fvwm2, fvwm95 and scwm are available in"
	einfo "/usr/share/wm-icons"
	einfo
}
