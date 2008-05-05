# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libsmbios/libsmbios-2.0.2.ebuild,v 1.1 2008/05/05 13:47:49 cedk Exp $

DESCRIPTION="Provide access to (SM)BIOS information"
HOMEPAGE="http://linux.dell.com/libsmbios/main/index.html"
SRC_URI="http://linux.dell.com/libsmbios/download/libsmbios/${P}/${P}.tar.gz"

LICENSE="GPL-2 OSL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="test"

DEPEND="dev-libs/libxml2
	sys-libs/zlib
	test? ( dev-util/cppunit )"
RDEPEND=${DEPEND}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_test() {
	einfo "testing currently broken - bypassing"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	insinto /usr/include/
	doins -r include/smbios/

	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	ewarn "If you upgrade from a version of libsmbios older than 2.0.2,"
	ewarn "you should run revdep-rebuild."
}
