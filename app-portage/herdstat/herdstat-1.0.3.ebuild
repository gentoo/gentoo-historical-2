# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/herdstat/herdstat-1.0.3.ebuild,v 1.2 2005/04/22 13:35:46 ka0ttic Exp $

inherit bash-completion

DESCRIPTION="Utility that parses Gentoo's herds.xml and allows queries based on herd or developer"
HOMEPAGE="http://developer.berlios.de/projects/herdstat/"
SRC_URI="http://download.berlios.de/herdstat/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc ~alpha"
IUSE="debug"

RDEPEND="dev-libs/xmlwrapp
	net-misc/wget"
DEPEND="dev-libs/xmlwrapp
	>=sys-apps/sed-4"

src_compile() {
	econf $(use_enable debug) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	keepdir /var/lib/herdstat
	make DESTDIR="${D}" install || die "make install failed"
	dobashcompletion bashcomp
	dodoc AUTHORS ChangeLog README TODO NEWS
}

pkg_postinst() {
	chown root:portage /var/lib/herdstat
	chmod 0775 /var/lib/herdstat

	echo
	einfo "You must be in the portage group to use herdstat."
	bash-completion_pkg_postinst
}
