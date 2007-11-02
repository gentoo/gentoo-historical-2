# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/linux-logo/linux-logo-5.02.ebuild,v 1.4 2007/11/02 14:15:32 beandog Exp $

inherit eutils

MY_P=${PN/-/_}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A utility that displays an ANSI/ASCII logo and some system information"
HOMEPAGE="http://www.deater.net/weave/vmwprod/linux_logo/"
SRC_URI="http://www.deater.net/weave/vmwprod/linux_logo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ~mips ~ppc sparc x86"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	echo "./logos/gentoo.logo" >> logo_config
	echo "./logos/gentoo2.logo" >> logo_config
	echo "./logos/banner-simplified.logo" >> logo_config
	echo "./logos/banner.logo" >> logo_config
	echo "./logos/classic-no_periods.logo" >> logo_config
	echo "./logos/classic-no_periods_or_chars.logo" >> logo_config
	echo "./logos/classic.logo" >> logo_config
	cp "${FILESDIR}"/gentoo{,2}.logo "${S}"/logos/
	echo "NAME gentoo" >> "${S}"/logos/gentoo.logo
}

src_compile() {
	./configure --prefix="${D}"/usr || die
	sed -i -e "s/CFLAGS=.*/CFLAGS=${CFLAGS}/" {,libsysinfo-*/}Makefile.default
	emake || die
}

src_install() {
	make install || die

	dodoc BUGS README README.CUSTOM_LOGOS TODO USAGE LINUX_LOGO.FAQ

	cp "${FILESDIR}"/${PN}.conf "${WORKDIR}"
	sed -i -e 's/-L 4 -f -u/-f -u/' "${WORKDIR}"/${PN}.conf

	newinitd "${FILESDIR}"/${PN}.initscript ${PN}
	newconfd "${WORKDIR}"/${PN}.conf ${PN}
}

pkg_postinst() {
	echo
	elog "Linux_logo ebuild for Gentoo comes with two Gentoo logos."
	elog ""
	elog "To display the first Gentoo logo type: linux_logo -L gentoo"
	elog "To display the second Gentoo logo type: linux_logo -L gentoo-alt"
	elog "To display all the logos available type: linux_logo -L list."
	elog ""
	elog "To start linux_logo on boot, please type:"
	elog "   rc-update add linux-logo default"
	elog "which uses the settings found in"
	elog "   /etc/conf.d/linux-logo"
	echo
}
