# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/eix/eix-0.8.8.ebuild,v 1.8 2007/03/12 18:21:21 kloeri Exp $

DESCRIPTION="Small utility for searching ebuilds with indexing for fast results"
HOMEPAGE="http://eix.sourceforge.net"
SRC_URI="mirror://sourceforge/eix/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="sqlite"

DEPEND="sqlite? ( >=dev-db/sqlite-3 )"
RDEPEND="${DEPEND}"

src_compile() {
	econf $(use_with sqlite) || die "econf failed"
	emake || die "emake failed"
	src/eix --dump-defaults >eixrc || die "generating eixrc failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog TODO

	insinto /etc
	doins eixrc
}

pkg_postinst() {
	elog "As of >=eix-0.5.4, \"metadata\" is the new default cache."
	elog "It's independent of the portage-version and the cache used by portage."
}
