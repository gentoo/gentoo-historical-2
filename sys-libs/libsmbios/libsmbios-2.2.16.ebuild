# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libsmbios/libsmbios-2.2.16.ebuild,v 1.2 2009/06/21 21:03:05 cedk Exp $

EAPI=2

inherit python

DESCRIPTION="Provide access to (SM)BIOS information"
HOMEPAGE="http://linux.dell.com/libsmbios/main/index.html"
SRC_URI="http://linux.dell.com/libsmbios/download/libsmbios/${P}/${P}.tar.bz2"

LICENSE="GPL-2 OSL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="doc graphviz nls python test"

RDEPEND="dev-libs/libxml2
	sys-libs/zlib
	nls? ( virtual/libintl )
	python? ( >=dev-lang/python-2.3 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )
	graphviz? ( media-gfx/graphviz )
	nls? ( sys-devel/gettext )
	test? ( >=dev-util/cppunit-1.9.6 )"

src_prepare() {
	rm pkg/py-compile
	ln -s "$(type -P true)" pkg/py-compile || die
}

src_configure() {
	econf \
		$(use_enable doc doxygen) \
		$(use_enable graphviz) \
		$(use_enable nls) \
		$(use_enable python) || die
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"

	rm -rf "${D}etc/yum"
	rm -rf "${D}usr/lib/yum-plugins"

	insinto /usr/include/
	doins -r src/include/smbios/

	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	use python && python_mod_optimize /usr/share/smbios-utils
}

pkg_postrm() {
	use python && python_mod_cleanup /usr/share/smbios-utils
}
