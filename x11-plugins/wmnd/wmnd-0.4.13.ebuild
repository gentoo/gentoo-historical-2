# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmnd/wmnd-0.4.13.ebuild,v 1.4 2010/05/28 09:43:28 maekke Exp $

IUSE="snmp"
DESCRIPTION="WindowMaker Network Devices (dockapp)"
HOMEPAGE="http://www.thregr.org/~wavexx/software/wmnd/"
SRC_URI="http://www.thregr.org/~wavexx/software/wmnd/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	snmp? ( >=net-analyzer/net-snmp-5.2.1 )"

src_compile()
{
	if use snmp; then
		LDFLAGS="$LDFLAGS -lcrypto"
	fi

	LDFLAGS="$LDFLAGS" econf || die "configure failed"
	emake || die "parallel make failed"
}

src_install()
{
	einstall || die "make install failed"

	dodoc README AUTHORS ChangeLog NEWS TODO

	# gpl.info is no valid .info file. Causes errors with install-info.
	rm -r "${D}"/usr/share/info
}
