# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gatt-svn/gatt-svn-9999.ebuild,v 1.4 2007/02/02 08:11:48 opfer Exp $

inherit subversion

ESVN_REPO_URI="svn://80.108.115.144/gatt/trunk"
ESVN_PROJECT="Gentoo Arch Tester Tool"

DESCRIPTION="Gentoo Arch Tester Tool"
HOMEPAGE="http://www.gentoo.org/proj/en/base/x86/at.xml
	http://www.gentoo.org/proj/en/base/ppc/AT/index.xml
	http://www.gentoo.org/proj/en/base/amd64/at/index.xml
	http://www.gentoo.org/proj/en/base/alpha/AT/index.xml"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=dev-libs/boost-1.33.1
	>=dev-cpp/libthrowable-0.9.6"
RDEPEND="${DEPEND}
	www-client/pybugz"

pkg_setup() {
	ewarn
	ewarn "This is an Subversion snapshot, so no functionality is"
	ewarn "guaranteed!	Better not use it as root for now and backup"
	ewarn "at least your data in /etc/portage/!"
	einfo
	einfo "Read the README file to learn how to use the Gentoo Arch"
	einfo "Testing Tool"
	ebeep
}

src_install() {
	emake DESTDIR="${D}" install || die "installing ${PF} failed"
	dodoc README NEWS AUTHORS ChangeLog
	newdoc .todo TODO
}
