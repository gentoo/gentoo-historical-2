# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgadmin3/pgadmin3-1.12.3-r1.ebuild,v 1.1 2011/07/10 23:12:51 titanofold Exp $

EAPI="4"

WX_GTK_VER="2.8"

inherit autotools multilib wxwidgets

DESCRIPTION="wxWidgets GUI for PostgreSQL."
HOMEPAGE="http://www.pgadmin.org/"
SRC_URI="mirror://postgresql/${PN}/release/v${PV}/src/${P}.tar.gz"

LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
SLOT="0"
IUSE="debug"

DEPEND="x11-libs/wxGTK:2.8[X]
	>=dev-db/postgresql-base-8.4.0
	>=dev-libs/libxml2-2.5
	>=dev-libs/libxslt-1.1"
RDEPEND="${DEPEND}"

pkg_setup() {
	local pgslot=$(postgresql-config show)

	if [[ ${pgslot//.} < 84 ]] ; then
		eerror "PostgreSQL slot must be set to 8.4 or higher."
		eerror "    postgresql-config set 8.4"
		die "PostgreSQL slot is not set to 8.4 or higher."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/cflags.patch" \
		"${FILESDIR}/ssl-detect.patch"
	eautoreconf
}

src_configure() {
	econf --with-wx-version=2.8 \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install

	newicon "${S}/pgadmin/include/images/pgAdmin3.png" ${PN}.png

	# icon location for the desktop file provided in pkg folder
	insinto /usr/share/pgadmin3
	doins "${S}/pgadmin/include/images/pgAdmin3.png"

	domenu "${S}/pkg/pgadmin3.desktop"

	# Fixing world-writable files
	fperms -R go-w /usr/share
}
