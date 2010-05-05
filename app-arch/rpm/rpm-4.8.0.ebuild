# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm/rpm-4.8.0.ebuild,v 1.1 2010/05/05 20:54:03 sochotnicky Exp $

EAPI=2

inherit eutils autotools flag-o-matic perl-module distutils

DESCRIPTION="Red Hat Package Management Utils"
HOMEPAGE="http://www.rpm.org"
SRC_URI="http://rpm.org/releases/rpm-4.8.x/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="nls python doc sqlite capabilities lua acl"

RDEPEND="=sys-libs/db-4.5*
	>=sys-libs/zlib-1.2.3-r1
	>=app-arch/bzip2-1.0.1
	>=dev-libs/popt-1.7
	>=app-crypt/gnupg-1.2
	dev-libs/elfutils
	virtual/libintl
	>=dev-lang/perl-5.8.8
	python? ( >=dev-lang/python-2.3 )
	nls? ( virtual/libintl )
	sqlite? ( >=dev-db/sqlite-3.3.5 )
	lua? ( >=dev-lang/lua-5.1.0 )
	acl? ( virtual/acl )
	capabilities? ( >=sys-libs/libcap-2.0 )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-autotools.patch
	epatch "${FILESDIR}"/${P}-db-path.patch

	eautoreconf
}

src_compile() {
	emake || die "emake failed"
}

src_configure() {
	econf \
		--without-selinux \
		--with-external-db \
		$(use_enable python) \
		$(use_with doc hackingdocs) \
		$(use_enable sqlite sqlite3) \
		$(use_enable nls) \
		$(use_with lua) \
		$(use_with capabilities cap)\
		$(use_with acl)\
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" INSTALLDIRS=vendor install || die "emake install failed"

	mv "${D}"/bin/rpm "${D}"/usr/bin
	rmdir "${D}"/bin

	use nls || rm -rf "${D}"/usr/share/man/??

	keepdir /usr/src/rpm/{SRPMS,SPECS,SOURCES,RPMS,BUILD}

	dodoc CHANGES CREDITS GROUPS README* RPM*
	use doc && dohtml -r apidocs/html/*

	# Fix perllocal.pod file collision
	fixlocalpod
}

pkg_postinst() {
	if [[ -f "${ROOT}"/var/lib/rpm/Packages ]] ; then
		einfo "RPM database found... Rebuilding database (may take a while)..."
		"${ROOT}"/usr/bin/rpm --rebuilddb --root="${ROOT}"
	else
		einfo "No RPM database found... Creating database..."
		"${ROOT}"/usr/bin/rpm --initdb --root="${ROOT}"
	fi

	distutils_pkg_postinst
}
