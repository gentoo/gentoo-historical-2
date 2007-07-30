# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fakeroot/fakeroot-1.7.1.ebuild,v 1.1 2007/07/30 10:05:57 vapier Exp $

DESCRIPTION="Run commands in an environment faking root privileges"
HOMEPAGE="http://packages.qa.debian.org/f/fakeroot.html"
SRC_URI="mirror://debian/pool/main/f/fakeroot/${PF/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="test"

RDEPEND=""
DEPEND="test? ( app-arch/sharutils )"

src_install() {
	emake DESTDIR="${D}" install || die "install problem"
	dodoc AUTHORS BUGS ChangeLog DEBUG NEWS README*
}
