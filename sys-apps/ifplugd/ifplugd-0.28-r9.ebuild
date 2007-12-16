# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ifplugd/ifplugd-0.28-r9.ebuild,v 1.4 2007/12/16 17:30:22 drac Exp $

inherit eutils

DESCRIPTION="Brings up/down ethernet ports automatically with cable detection"
HOMEPAGE="http://0pointer.de/lennart/projects/ifplugd/"
SRC_URI="http://0pointer.de/lennart/projects/ifplugd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

DEPEND="dev-util/pkgconfig
	doc? ( www-client/lynx )
	>=dev-libs/libdaemon-0.5"
RDEPEND=">=dev-libs/libdaemon-0.5
	>=sys-apps/baselayout-1.12"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-nlapi.diff"
	epatch "${FILESDIR}/${P}-interface.patch"
	epatch "${FILESDIR}/${P}-strictalias.patch"
	epatch "${FILESDIR}/${P}-noip.patch"
}

src_compile() {
	econf $(use_enable doc lynx) \
		--with-initdir=/etc/init.d \
		--disable-xmltoman \
		--disable-subversion \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# Remove init.d configuration as we no longer use it
	rm -rf "${D}/etc/ifplugd" "${D}/etc/init.d/${PN}"

	dodir "/etc/${PN}"
	exeinto "/etc/${PN}"
	newexe "${FILESDIR}/${PN}.action" "${PN}.action" || die

	cd "${S}/doc"
	dodoc README SUPPORTED_DRIVERS
	use doc && dohtml *.html *.css
}

pkg_postinst() {
	# Warn about old init script
	einfo "baselayout now starts ifplugd automatically on wired interfaces"
	einfo "If you do not want this behaviour then add !plug to your modules"
	einfo "in /etc/conf.d/net like so"
	einfo "   modules=( \"!plug\" )"

	if [ -e "${ROOT}/etc/init.d/ifplugd" -o -e "${ROOT}/etc/conf.d/ifplugd" ] ; then
		echo
		ewarn "You should stop the ifplugd service now and remove its init"
		ewarn "script and config file"
		if [ "${ROOT}" = "/" ] ; then
			ewarn "   /etc/init.d/ifplugd stop"
			ewarn "   rc-update del ifplugd"
			ewarn "   rm -f /etc/{conf,init}.d/ifplugd"
		fi
	fi
}
