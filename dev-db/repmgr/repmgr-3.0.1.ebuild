# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/repmgr/repmgr-3.0.1.ebuild,v 1.1 2015/08/02 16:11:45 robbat2 Exp $

EAPI=5
inherit eutils
DESCRIPTION="PostgreSQL Replication Manager"
HOMEPAGE="http://www.repmgr.org/"
SRC_URI="http://www.repmgr.org/download/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=">=dev-db/postgresql-9.3[server]"
RDEPEND="${DEPEND}
	net-misc/rsync"

src_compile() {
	emake USE_PGXS=1
}

src_install() {
    emake DESTDIR="${D}" USE_PGXS=1 install
	find $D -ls
	export PGSLOT="$(postgresql-config show)"
	einfo "PGSLOT: ${PGSLOT}"
	PGBINDIR=${PGBASEDIR}/bin/
	PGCONTRIB=/usr/share/postgresql-${PGSLOT}/contrib/
	dodir $PGCONTRIB $PGBINDIR
	insinto $PGCONTRIB
	doins sql/repmgr2_repmgr3.sql
	dosym $PGBINDIR/repmgr /usr/bin/repmgr94
	dosym $PGBINDIR/repmgrd /usr/bin/repmgrd94
	dodoc  CREDITS HISTORY COPYRIGHT LICENSE TODO *.md *.rst
	insinto /etc
	newins repmgr.conf.sample repmgr.conf
	fowners postgres:postgres /etc/repmgr.conf
	ewarn "Remember to modify /etc/repmgr.conf"
}
