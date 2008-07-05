# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/nspluginwrapper/nspluginwrapper-1.0.0.ebuild,v 1.1 2008/07/05 23:52:53 peper Exp $

inherit eutils nsplugins flag-o-matic multilib

DESCRIPTION="Netscape Plugin Wrapper - Load 32bit plugins on 64bit browser"
HOMEPAGE="http://www.gibix.net/projects/nspluginwrapper/"
SRC_URI="http://www.gibix.net/projects/nspluginwrapper/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	app-emulation/emul-linux-x86-xlibs
	app-emulation/emul-linux-x86-gtklibs
	|| ( >=sys-apps/util-linux-2.13 sys-apps/setarch )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf --with-biarch \
		--with-lib32=$(ABI=x86 get_libdir) \
		--with-lib64=$(get_libdir) \
		--pkglibdir=/usr/$(get_libdir)/${PN} || die
	emake || die
}

src_install() {
	emake -j1 DESTDIR="${D}" DONT_STRIP=yes install || die

	inst_plugin /usr/$(get_libdir)/nspluginwrapper/x86_64/linux/npwrapper.so
	dosym /usr/$(get_libdir)/nspluginwrapper/x86_64/linux/npconfig /usr/bin/nspluginwrapper

	dodoc NEWS README TODO ChangeLog
}

pkg_postinst() {
	einfo "Auto installing 32bit plugins..."
	nspluginwrapper -a -i
	elog "Any 32bit plugins you currently have installed have now been"
	elog "configured to work in a 64bit browser. Any plugins you install in"
	elog "the future will first need to be setup with:"
	elog "  \"nspluginwrapper -i <path-to-32bit-plugin>\""
	elog "before they will function in a 64bit browser"
	elog
}

# this is terribly ugly, but without a way to query portage as to whether
# we are upgrading/reinstalling a package versus unmerging, I can't think of
# a better way

pkg_prerm() {
	einfo "Removing wrapper plugins..."
	nspluginwrapper -a -r
}

pkg_postrm() {
	if [[ -x /usr/bin/nspluginwrapper ]]; then
		einfo "Auto installing 32bit plugins..."
		nspluginwrapper -a -i
	fi
}
