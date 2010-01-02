# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/pe-format/pe-format-1.ebuild,v 1.2 2010/01/02 12:19:59 fauli Exp $

inherit eutils

DESCRIPTION="PE Format binfmt_misc entry"
HOMEPAGE="http://www.kernel.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="|| ( dev-lang/mono dev-dotnet/pnet )"

src_compile() {
	true;
}

src_install() {
	newinitd "${FILESDIR}/pe-format.init-1" pe-format || die "failed to install init script"
	newconfd "${FILESDIR}/pe-format.conf" pe-format || die "failed to install config"
}

pkg_postinst() {
	ebeep 5

	einfo
	ewarn "Using this script will confuse applications which are designed to use PE"
	ewarn "applications such as Wine and Cedega."
	einfo

	epause 5
}
