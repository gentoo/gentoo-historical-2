# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/fwbuilder/fwbuilder-2.0.4.ebuild,v 1.1 2004/12/18 16:49:04 carlo Exp $

inherit eutils

DESCRIPTION="A firewall GUI"
HOMEPAGE="http://www.fwbuilder.org/"
SRC_URI="mirror://sourceforge/fwbuilder/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~sparc ~ppc"
IUSE="nls"

DEPEND="~net-libs/libfwbuilder-${PV}
	nls? ( >=sys-devel/gettext-0.11.4 )
	>=dev-libs/libxslt-1.0.7"

src_compile() {
	export QMAKESPEC="linux-g++"

	econf `use_enable nls` || die

	addwrite "${QTDIR}/etc/settings"
	emake || die "emake failed"
}

src_install() {
	emake DDIR=${D} install || die
}

pkg_postinst() {
	echo ""
	einfo "You need to emerge iproute2 on the machine that"
	einfo "will run the firewall script."
	echo ""
}
