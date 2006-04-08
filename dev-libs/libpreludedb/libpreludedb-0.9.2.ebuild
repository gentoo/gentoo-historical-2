# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libpreludedb/libpreludedb-0.9.2.ebuild,v 1.4 2006/04/08 16:55:29 dertobi123 Exp $

inherit flag-o-matic

DESCRIPTION="Prelude-IDS framework for easy access to the Prelude database"
HOMEPAGE="http://www.prelude-ids.org/"
SRC_URI="http://www.prelude-ids.org/download/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE="doc mysql postgres perl python"

DEPEND="virtual/libc
	>=dev-libs/libprelude-0.9.0
	doc? ( dev-util/gtk-doc )
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )"

src_compile() {
	local myconf

	use doc && myconf="${myconf} --enable-gtk-doc" || myconf="${myconf} --enable-gtk-doc=no"
	use mysql && myconf="${myconf} --enable-mysql" || myconf="${myconf} --enable-mysql=no"
	use postgres && myconf="${myconf} --enable-postgresql" || myconf="${myconf} --enable-postgresql=no"
	use perl && myconf="${myconf} --enable-perl" || myconf="${myconf} --enable-perl=no"
	use python && myconf="${myconf} --enable-python" || myconf="${myconf} --enable-python=no"
	econf ${myconf} || die "econf failed"

	emake -j1 || die "emake failed"
	# -j1 may not be necessary in the future
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}

pkg_postinst() {
	einfo "For additional installation instructions go to"
	einfo "https://trac.prelude-ids.org/wiki/InstallingLibpreludedb"
}
